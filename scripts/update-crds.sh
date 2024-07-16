#!/bin/bash

function get_operator_app_version() {
  operator_app_version=$(awk '/appVersion:/{print $2}' "charts/greptimedb-operator/Chart.yaml")
}

function main() {
  get_operator_app_version

  curl -sL "https://github.com/GreptimeTeam/greptimedb-operator/releases/download/v$operator_app_version/greptimedbclusters.yaml" -o charts/greptimedb-operator/crds/greptimedbclusters.yaml
  curl -sL "https://github.com/GreptimeTeam/greptimedb-operator/releases/download/v$operator_app_version/greptimedbstandalones.yaml" -o charts/greptimedb-operator/crds/greptimedbstandalones.yaml
}

main
