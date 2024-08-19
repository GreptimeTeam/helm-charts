#!/usr/bin/env bash

set -e

OPERATOR_VERSION=${1:-$(awk '/appVersion:/{print $2}' "charts/greptimedb-operator/Chart.yaml")}

function upgrade_crds() {
  if [ -z "$OPERATOR_VERSION" ]; then
    echo "Failed to get the operator version."
    exit 1
  fi

  if [ "$OPERATOR_VERSION" == "latest" ]; then
    echo "Applying CRDs for the latest released greptimedb-operator version"
    kubectl apply -f "https://github.com/GreptimeTeam/greptimedb-operator/releases/latest/download/greptimedbclusters.yaml"
    kubectl apply -f "https://github.com/GreptimeTeam/greptimedb-operator/releases/latest/download/greptimedbstandalones.yaml"
    exit 0
  fi

  echo "Applying CRDs for the current greptimedb-operator version $OPERATOR_VERSION"
  kubectl apply -f "https://github.com/GreptimeTeam/greptimedb-operator/releases/download/v$OPERATOR_VERSION/greptimedbclusters.yaml"
  kubectl apply -f "https://github.com/GreptimeTeam/greptimedb-operator/releases/download/v$OPERATOR_VERSION/greptimedbstandalones.yaml"
}

upgrade_crds
