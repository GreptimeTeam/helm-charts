#!/usr/bin/env bash

set -e

function deploy_greptimedb_standalone() {
  helm repo add greptime https://greptimeteam.github.io/helm-charts/
  helm repo update
  cd charts
  helm upgrade --install greptimedb-standalone greptimedb-standalone -n default
}

function sql_test_greptimedb_standalone() {
  kubectl port-forward -n default svc/greptimedb-standalone 4002:4002 > connections.out &
}

function main() {
  # Deploy the greptimedb-standalone helm chart.
  deploy_greptimedb_standalone

  # Add sql test with greptimedb standalone
  sql_test_greptimedb_standalone
}

main
