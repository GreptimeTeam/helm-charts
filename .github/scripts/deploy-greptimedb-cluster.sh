#!/usr/bin/env bash

set -e

function deploy_greptimedb_cluster() {
  helm repo add greptime https://greptimeteam.github.io/helm-charts/
  helm repo update
  cd charts
  helm upgrade --install mycluster greptimedb-cluster -n default
}

function deploy_greptimedb_operator() {
  helm repo add greptime https://greptimeteam.github.io/helm-charts/
  helm repo update
  cd charts
  helm upgrade --install greptimedb-operator greptimedb-operator -n default
}

function deploy_etcd() {
  helm upgrade --install etcd oci://registry-1.docker.io/bitnamicharts/etcd \
    --set replicaCount=1 \
    --set auth.rbac.create=false \
    --set auth.rbac.token.enabled=false \
    -n default
}

function sql_test_greptimedb_cluster() {
  kubectl port-forward -n default svc/mycluster-frontend 4002:4002 > connections.out &
}

function main() {
  # Deploy the bitnami etcd helm chart.
  deploy_etcd

  # Deploy the greptimedb-operator helm chart.
  deploy_greptimedb_operator

  # Deploy the greptimedb-cluster helm chart.
  deploy_greptimedb_cluster

  # Add sql test with greptimedb cluster
  sql_test_greptimedb_cluster
}

main
