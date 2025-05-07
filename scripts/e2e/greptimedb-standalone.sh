#!/usr/bin/env bash

set -euo pipefail

# Configuration variables
DB_HOST="127.0.0.1"
DB_PORT="4002"
TABLE_NAME="greptimedb_standalone_test_$(date +%s)"
PORT_FORWARD_PID=""
CONNECTION_LOG="/tmp/connections.out"

# SQL templates
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

# Setup traps for clean exit
trap 'cleanup; exit 1' INT TERM ERR
trap 'cleanup; exit 0' EXIT

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
    log "Inserting test data into: $table_name"
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

function deploy_greptimedb_standalone() {
    log "Deploying GreptimeDB standalone..."
    if ! helm upgrade --install greptimedb-standalone charts/greptimedb-standalone -n default; then
        log "Failed to deploy greptimedb-standalone"
        exit 1
    fi

    log "Waiting for GreptimeDB to be ready..."
    if ! kubectl rollout status --timeout=120s statefulset/greptimedb-standalone -n default; then
        log "GreptimeDB standalone deployment failed or timed out"
        exit 1
    fi
}

function start_port_forward() {
    log "Starting port forwarding..."
    kubectl port-forward -n default svc/greptimedb-standalone \
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
    pids=$(pgrep -f "kubectl port-forward.*greptimedb-standalone" || true)
    if [[ -n "$pids" ]]; then
        log "Cleaning up orphaned port-forward processes: $pids"
        kill $pids 2>/dev/null || true
    fi

    log "Cleanup completed"
}

function main() {
    log "Starting GreptimeDB standalone test..."
    deploy_greptimedb_standalone
    run_mysql_tests
    log "All tests completed successfully"
}

main
