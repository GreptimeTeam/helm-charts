#!/usr/bin/env bash

set -e

DB_HOST="127.0.0.1"
DB_PORT="4002"
TABLE_NAME="greptimedb_standalone_test"

CreateTableSQL="CREATE TABLE %s (
                        ts TIMESTAMP DEFAULT current_timestamp(),
                        n INT,
    					          row_id INT,
                        TIME INDEX (ts),
                        PRIMARY KEY(n)
               )
               PARTITION ON COLUMNS (n) (
                   n < 5,
                   n < 9,
                   n < 1000
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

function deploy_greptimedb_standalone() {
  cd charts
  helm upgrade --install greptimedb-standalone greptimedb-standalone -n default

  # Wait for greptimedb standalone to be ready
  kubectl rollout status --timeout=60s statefulset/greptimedb-standalone -n default
}

function mysql_test_greptimedb_standalone() {
  kubectl port-forward -n default svc/greptimedb-standalone \
    4000:4000 \
    4001:4001 \
    4002:4002 \
    4003:4003 > /tmp/connections.out &

  sleep 3

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
  # Deploy the greptimedb-standalone helm chart
  deploy_greptimedb_standalone

  # Add mysql test with greptimedb standalone
  mysql_test_greptimedb_standalone

  # clean resource
  cleanup
}

main
