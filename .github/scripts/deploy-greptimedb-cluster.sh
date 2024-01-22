#!/usr/bin/env bash

set -e

DB_HOST="127.0.0.1"
DB_PORT="4002"
TABLE_NAME="greptimedb_cluster_test"

CreateTableSQL="CREATE TABLE %s (
                        ts TIMESTAMP DEFAULT current_timestamp(),
                        n INT,
    					          row_id INT,
                        TIME INDEX (ts),
                        PRIMARY KEY(n)
               )
               PARTITION BY RANGE COLUMNS (n) (
    				 	     PARTITION r0 VALUES LESS THAN (5),
    					     PARTITION r1 VALUES LESS THAN (9),
    					     PARTITION r2 VALUES LESS THAN (MAXVALUE)
					     )"

InsertDataSQL="INSERT INTO %s(n, row_id) VALUES (%d, %d)"

SelectDataSQL="SELECT * FROM %s"

DropTableSQL="DROP TABLE %s"

TestRowIDNum=1

function create_table() {
  local table_name=$1
  local sql=$(printf "$CreateTableSQL" "$table_name")
  mysql -h "$DB_HOST" -P "$DB_PORT" -e "$sql"
}

function insert_data() {
  local table_name=$1
  local sql=$(printf "$InsertDataSQL" "$table_name" "$TestRowIDNum" "$TestRowIDNum")
  mysql -h "$DB_HOST" -P "$DB_PORT" -e "$sql"
}

function select_data() {
  local table_name=$1
  local sql=$(printf "$SelectDataSQL" "$table_name")
  mysql -h "$DB_HOST" -P "$DB_PORT" -e "$sql"
}

function drop_table() {
  local table_name=$1
  local sql=$(printf "$DropTableSQL" "$table_name")
  mysql -h "$DB_HOST" -P "$DB_PORT" -e "$sql"
}

function deploy_greptimedb_cluster() {
  helm upgrade --install mycluster greptimedb-cluster -n default

  # Wait for greptimedb cluster to be ready
  while true; do
    PHASE=$(kubectl -n default get gtc mycluster -o jsonpath='{.status.clusterPhase}')
    if [ "$PHASE" == "Running" ]; then
      echo "Cluster is ready"
      break
    else
      echo "Cluster is not ready yet: Current phase: $PHASE"
      sleep 5 # wait for 5 seconds before check again
    fi
  done
}

function deploy_greptimedb_operator() {
  cd charts
  helm upgrade --install greptimedb-operator greptimedb-operator -n default

  # Wait for greptimedb operator to be ready
  kubectl rollout status --timeout=60s deployment/greptimedb-operator -n default
}

function deploy_etcd() {
  helm upgrade --install etcd oci://registry-1.docker.io/bitnamicharts/etcd \
    --set replicaCount=1 \
    --set auth.rbac.create=false \
    --set auth.rbac.token.enabled=false \
    -n default

  # Wait for etcd to be ready
  kubectl rollout status --timeout=120s statefulset/etcd -n default
}

function mysql_test_greptimedb_cluster() {
  kubectl port-forward -n default svc/mycluster-frontend \
    4000:4000 \
    4001:4001 \
    4002:4002 \
    4003:4003 > /tmp/connections.out &

  sleep 5

  create_table "$TABLE_NAME"
  insert_data "$TABLE_NAME"
  select_data "$TABLE_NAME"
  drop_table "$TABLE_NAME"
}

function cleanup() {
  echo "Cleaning up..."
  pkill -f "kubectl port-forward"
}

function main() {
  # Deploy the bitnami etcd helm chart
  deploy_etcd

  # Deploy the greptimedb-operator helm chart
  deploy_greptimedb_operator

  # Deploy the greptimedb-cluster helm chart
  deploy_greptimedb_cluster

  # Add mysql test with greptimedb cluster
  mysql_test_greptimedb_cluster

  # clean resource
  cleanup
}

main
