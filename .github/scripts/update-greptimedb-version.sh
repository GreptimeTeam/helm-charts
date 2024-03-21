#!/bin/bash

TAG="v0.7.1"

function replace_tag() {
  if [ -n "$IMAGE_TAG" ]; then
      TAG=$IMAGE_TAG
  fi
}

function update_greptimedb_standalone_chart() {
  file_path="charts/greptimedb-standalone/Chart.yaml"

  current_version=$(yq eval '.version' "$file_path")

  major=$(echo "$current_version" | awk -F. '{print $1}')
  minor=$(echo "$current_version" | awk -F. '{print $2}')
  patch=$(echo "$current_version" | awk -F. '{print $3}')

  next_version="$major.$minor.$((patch + 1))"

  appVersion="${TAG#v}"
  yq eval ".appVersion = \"$appVersion\"" -i "$file_path"
  yq eval ".version = \"$next_version\"" -i "$file_path"

  echo "Chart version updated to $next_version successfully."
}

function update_greptimedb_standalone_image() {
  yq e ".image.tag = \"$TAG\"" charts/greptimedb-standalone/values.yaml > /tmp/greptimedb-standalone-values-updated.yaml
  diff -U0 -w -b --ignore-blank-lines charts/greptimedb-standalone/values.yaml /tmp/greptimedb-standalone-values-updated.yaml > /tmp/greptimedb-standalone-values.diff
  patch charts/greptimedb-standalone/values.yaml < /tmp/greptimedb-standalone-values.diff

  echo "GreptimeDB standalone image updated to $TAG successfully."
}

function update_greptimedb_cluster_chart() {
  file_path="charts/greptimedb-cluster/Chart.yaml"

  current_version=$(yq eval '.version' "$file_path")

  major=$(echo "$current_version" | awk -F. '{print $1}')
  minor=$(echo "$current_version" | awk -F. '{print $2}')
  patch=$(echo "$current_version" | awk -F. '{print $3}')

  next_version="$major.$minor.$((patch + 1))"

  appVersion="${TAG#v}"
  yq eval ".appVersion = \"$appVersion\"" -i "$file_path"
  yq eval ".version = \"$next_version\"" -i "$file_path"

  echo "Chart version updated to $next_version successfully."
}

function update_greptimedb_cluster_image() {
  yq e ".image.tag = \"$TAG\"" charts/greptimedb-cluster/values.yaml > /tmp/greptimedb-cluster-values-updated.yaml
  diff -U0 -w -b --ignore-blank-lines charts/greptimedb-cluster/values.yaml /tmp/greptimedb-cluster-values-updated.yaml > /tmp/greptimedb-cluster-values.diff
  patch charts/greptimedb-cluster/values.yaml < /tmp/greptimedb-cluster-values.diff

  echo "GreptimeDB cluster image updated to $TAG successfully."
}

function main() {
  replace_tag
  update_greptimedb_cluster_image
  update_greptimedb_cluster_chart
  update_greptimedb_standalone_image
  update_greptimedb_standalone_chart
}

main
