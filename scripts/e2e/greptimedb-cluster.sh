#!/usr/bin/env bash

set -euo pipefail

# Configuration
DB_HOST="127.0.0.1"
DB_PORT="4002"
TABLE_NAME="greptimedb_cluster_test_$(date +%s)"
PORT_FORWARD_PID=""
CONNECTION_LOG="/tmp/connections.out"
TIMEOUT_CLUSTER=300
SLEEP_INTERVAL=5

# SQL Templates
CreateTableSQL="CREATE TABLE %s (
                    ts TIMESTAMP DEFAULT current_timestamp(),
                    n INT,
                    row_id INT,
                    TIME INDEX (ts),
                    PRIMARY KEY(n)
               )
               PARTITION ON COLUMNS (n) (
                   n < 5,
                   n >= 5 AND n < 9,
                   n >= 9
               )"

InsertDataSQL="INSERT INTO %s(n, row_id) VALUES (%d, %d)"
SelectDataSQL="SELECT * FROM %s"
DropTableSQL="DROP TABLE %s"
TestRowIDNum=1

function log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

function create_table() {
    local table_name=$1
    local sql=$(printf "$CreateTableSQL" "$table_name")
    log "Creating table: $table_name"
    if ! mysql -h "$DB_HOST" -P "$DB_PORT" -e "$sql"; then
        log "Failed to create table: $table_name"
        exit 1
    fi
}

function insert_data() {
    local table_name=$1
    local sql=$(printf "$InsertDataSQL" "$table_name" "$TestRowIDNum" "$TestRowIDNum")
    log "Inserting data into: $table_name"
    if ! mysql -h "$DB_HOST" -P "$DB_PORT" -e "$sql"; then
        log "Failed to insert data into: $table_name"
        exit 1
    fi
}

function select_data() {
    local table_name=$1
    local sql=$(printf "$SelectDataSQL" "$table_name")
    log "Querying data from: $table_name"
    if ! mysql -h "$DB_HOST" -P "$DB_PORT" -e "$sql"; then
        log "Failed to select data from: $table_name"
        exit 1
    fi
}

function drop_table() {
    local table_name=$1
    local sql=$(printf "$DropTableSQL" "$table_name")
    log "Dropping table: $table_name"
    if ! mysql -h "$DB_HOST" -P "$DB_PORT" -e "$sql"; then
        log "Failed to drop table: $table_name"
        exit 1
    fi
}

function deploy_etcd() {
    log "Deploying etcd..."
    if ! helm upgrade --install etcd \
        oci://registry-1.docker.io/bitnamicharts/etcd \
        --set replicaCount=1 \
        --set auth.rbac.create=false \
        --set auth.rbac.token.enabled=false \
        --create-namespace \
        --version 12.0.8 \
        --set global.security.allowInsecureImages=true \
        --set image.registry=docker.io \
        --set image.repository=greptime/etcd \
        --set image.tag=3.6.1-debian-12-r3 \
        -n etcd-cluster; then
        log "Failed to deploy etcd"
        exit 1
    fi

    log "Waiting for etcd to be ready..."
    if ! kubectl rollout status --timeout=120s statefulset/etcd -n etcd-cluster; then
        log "ETCD deployment failed or timed out"
        exit 1
    fi
}

function deploy_greptimedb_operator() {
    log "Deploying GreptimeDB Operator..."
    if ! helm upgrade --install greptimedb-operator charts/greptimedb-operator -n default; then
        log "Failed to deploy greptimedb-operator"
        exit 1
    fi

    log "Waiting for operator to be ready..."
    if ! kubectl rollout status --timeout=120s deployment/greptimedb-operator -n default; then
        log "Operator deployment failed or timed out"
        exit 1
    fi
}

function deploy_greptimedb_cluster() {
    log "Setting up dependencies..."
    if ! helm repo add grafana https://grafana.github.io/helm-charts --force-update; then
        log "Failed to add grafana repo"
        exit 1
    fi

    if ! helm repo add jaeger-all-in-one https://raw.githubusercontent.com/hansehe/jaeger-all-in-one/master/helm/charts --force-update; then
        log "Failed to add jaeger repo"
        exit 1
    fi

    if ! helm dependency build charts/greptimedb-cluster; then
        log "Failed to build dependencies"
        exit 1
    fi

    log "Deploying GreptimeDB Cluster..."
    if ! helm upgrade --install mycluster charts/greptimedb-cluster -n default \
           --set meta.backendStorage.etcd.endpoints=etcd.etcd-cluster.svc.cluster.local:2379; then
        log "Failed to deploy greptimedb-cluster"
        exit 1
    fi

    log "Waiting for cluster to be ready (timeout: ${TIMEOUT_CLUSTER}s)..."
    local elapsed_time=0
    while true; do
        PHASE=$(kubectl -n default get gtc mycluster -o jsonpath='{.status.clusterPhase}' 2>/dev/null || echo "Unknown")
        if [ "$PHASE" == "Running" ]; then
            log "Cluster is ready"
            break
        elif [ $elapsed_time -ge $TIMEOUT_CLUSTER ]; then
            log "Timed out waiting for cluster to be ready. Current phase: $PHASE"
            exit 1
        else
            log "Cluster is not ready yet: Current phase: $PHASE"
            sleep $SLEEP_INTERVAL
        fi
        elapsed_time=$((elapsed_time + SLEEP_INTERVAL))
    done
}

function start_port_forward() {
    log "Starting port forwarding..."
    kubectl port-forward -n default svc/mycluster-frontend \
        4000:4000 \
        4001:4001 \
        4002:4002 \
        4003:4003 > "$CONNECTION_LOG" 2>&1 &

    PORT_FORWARD_PID=$!
    sleep 5

    if ! ps -p "$PORT_FORWARD_PID" > /dev/null; then
        log "Port forwarding failed. Check $CONNECTION_LOG for details."
        exit 1
    fi
    log "Port forwarding established (PID: $PORT_FORWARD_PID)"
}

function stop_port_forward() {
    if [[ -n "$PORT_FORWARD_PID" ]]; then
        log "Stopping port forwarding (PID: $PORT_FORWARD_PID)..."
        if kill -0 "$PORT_FORWARD_PID" 2>/dev/null; then
            kill "$PORT_FORWARD_PID" || true
        fi
        PORT_FORWARD_PID=""
    fi
}

function run_mysql_tests() {
    start_port_forward

    create_table "$TABLE_NAME"
    insert_data "$TABLE_NAME"
    select_data "$TABLE_NAME"
    drop_table "$TABLE_NAME"

    stop_port_forward
}

function cleanup() {
    log "Starting cleanup..."
    stop_port_forward

    # Clean up any orphaned port-forward processes
    pids=$(pgrep -f "kubectl port-forward.*mycluster-frontend" || true)
    if [[ -n "$pids" ]]; then
        log "Cleaning up orphaned port-forward processes: $pids"
        kill $pids 2>/dev/null || true
    fi

    log "Cleanup completed"
}

function main() {
    log "Starting GreptimeDB cluster test..."

    deploy_etcd
    deploy_greptimedb_operator
    deploy_greptimedb_cluster
    run_mysql_tests

    log "All tests completed successfully"
}

main
