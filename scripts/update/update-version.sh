#!/bin/bash

CHART="$1"
VERSION="$2"

function update_version() {
  if [ -z "$CHART" ] || [ -z "$VERSION" ]; then
    echo "Error: Missing required arguments CHART or VERSION."
    exit 1
  fi

  if [[ "$CHART" != "greptimedb-standalone" && "$CHART" != "greptimedb-operator" && "$CHART" != "greptimedb-cluster" ]]; then
    echo "Error: Invalid CHART value: "$CHART"."
    exit 1
  fi

  if [[ ! "$VERSION" =~ ^v ]]; then
    echo "Error: VERSION must start with 'v'."
    exit 1
  fi

  chart_file="./charts/"$CHART"/Chart.yaml"
  values_file="./charts/"$CHART"/values.yaml"

  current_chart_version=$(yq eval '.version' "$chart_file")
  current_app_version=$(yq eval '.appVersion' "$chart_file")

  new_version=${VERSION#v}

  current_major=$(echo "$current_app_version" | awk -F. '{print $1}')
  current_minor=$(echo "$current_app_version" | awk -F. '{print $2}')

  new_major=$(echo "$new_version" | awk -F. '{print $1}')
  new_minor=$(echo "$new_version" | awk -F. '{print $2}')

  if [[ "$current_major" != "$new_major" || "$current_minor" != "$new_minor" ]]; then
    next_chart_version="$new_version"
  else
    chart_major=$(echo "$current_chart_version" | awk -F. '{print $1}')
    chart_minor=$(echo "$current_chart_version" | awk -F. '{print $2}')
    chart_patch=$(echo "$current_chart_version" | awk -F. '{print $3}')

    next_chart_version="$chart_major.$chart_minor.$((chart_patch + 1))"
  fi

  yq eval ".version = \"$next_chart_version\"" -i "$chart_file"
  yq eval ".appVersion = \"$new_version\"" -i "$chart_file"

  echo "The chart $CHART version updated to $next_chart_version successfully."

  yq e ".image.tag = \"$VERSION\"" "$values_file" > /tmp/"$CHART"-values-updated.yaml
  diff -U0 -w -b --ignore-blank-lines "$values_file" /tmp/"$CHART"-values-updated.yaml > /tmp/"$CHART"-values.diff
  patch "$values_file" < /tmp/"$CHART"-values.diff

  echo "The chart $CHART image updated to $VERSION successfully."
}

update_version
