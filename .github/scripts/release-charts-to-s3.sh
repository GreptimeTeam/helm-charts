#!/usr/bin/env bash

set -ue

GREPTIME_RELEASE_BUCKET=$1
RELEASE_DIR=releases/charts

function update_greptime_charts() {
  helm repo add greptime https://greptimeteam.github.io/helm-charts/
  helm repo update
}

function release_charts_to_s3() {
  repo=$1
  chart=$2

  mkdir "$chart"
  echo "Pulling chart from '$repo/$chart'..."

  helm pull "$repo"/"$chart" -d "$chart"

  package=$(ls ./"$chart")

  if [ -z "$package" ]; then
    echo "No package found from $repo/$chart"
    exit 1
  fi

  # Get the version from the package, for example, greptimedb-0.1.1-alpha.12.tgz -> 0.1.1-alpha.12.
  version=$(echo "$package" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+[-a-zA-Z0-9.]*' | sed 's/.tgz//')

  if [ -z "$version" ]; then
    echo "No version found from $repo/$chart"
    exit 1
  fi

  echo "Releasing package '$package' to 's3://$GREPTIME_RELEASE_BUCKET/$RELEASE_DIR/$chart/$version'..."

  aws s3 cp "$chart"/"$package" s3://"$GREPTIME_RELEASE_BUCKET"/"$RELEASE_DIR"/"$chart"/"$version"/"$package"

  echo "$version" > latest-version.txt

  # Create a latest-version.txt file in the chart directory.
  aws s3 cp latest-version.txt s3://"$GREPTIME_RELEASE_BUCKET"/"$RELEASE_DIR"/"$chart"/latest-version.txt
}

function update_index() {
  helm plugin install https://github.com/hypnoglow/helm-s3.git
  helm s3 init s3://"$GREPTIME_RELEASE_BUCKET"/"$RELEASE_DIR" --force
  helm repo index --url s3://"$GREPTIME_RELEASE_BUCKET"/"$RELEASE_DIR" --merge index.yaml .
  aws s3 cp index.yaml s3://"$GREPTIME_RELEASE_BUCKET"/"$RELEASE_DIR"/
}

function main() {
  update_greptime_charts
  release_charts_to_s3 greptime greptimedb-operator
  release_charts_to_s3 greptime greptimedb-standalone
  release_charts_to_s3 greptime greptimedb-cluster
  release_charts_to_s3 oci://registry-1.docker.io/bitnamicharts etcd
  update_index
}

# The entrypoint for the script.
main
