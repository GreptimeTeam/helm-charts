#! /usr/bin/env bash

set -e

function get_operator_app_version() {
  operator_app_version=$(awk '/appVersion:/{print $2}' "charts/greptimedb-operator/Chart.yaml")

  if [[ -z "$operator_app_version" ]]; then
    echo "Failed to get 'appVersion' from charts/greptimedb-operator/Chart.yaml"
    exit 1
  fi
}

function main() {
  get_operator_app_version

  curl -sL "https://github.com/GreptimeTeam/greptimedb-operator/releases/download/v$operator_app_version/greptimedbclusters.yaml" -o /tmp/greptimedbclusters.yaml
  yq e '.spec' /tmp/greptimedbclusters.yaml | awk '{print "  " $0}' > /tmp/greptimedbclusters.spec
  sed -e '/\${{ spec }}/{
      s/\${{ spec }}//g
      r /tmp/greptimedbclusters.spec
      d
  }' scripts/crds/templates/crd-greptimedbcluster.tmpl > charts/greptimedb-operator/templates/crds/crd-greptimedbcluster.yaml

  curl -sL "https://github.com/GreptimeTeam/greptimedb-operator/releases/download/v$operator_app_version/greptimedbstandalones.yaml" -o /tmp/greptimedbstandalones.yaml
  yq e '.spec' /tmp/greptimedbstandalones.yaml | awk '{print "  " $0}' > /tmp/greptimedbstandalones.spec
  sed -e '/\${{ spec }}/{
      s/\${{ spec }}//g
      r /tmp/greptimedbstandalones.spec
      d
  }' scripts/crds/templates/crd-greptimedbstandalone.tmpl > charts/greptimedb-operator/templates/crds/crd-greptimedbstandalone.yaml
}

main
