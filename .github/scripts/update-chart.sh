#!/bin/bash

CHART="$1"
VERSION="$2"

function update_chart() {
  if [ -z "$CHART" ] || [ -z "$VERSION" ]; then
    echo "Error: Missing required arguments CHART or VERSION."
    exit 1
  fi

  if [[ "$CHART" != "greptimedb-standalone" && "$CHART" != "greptimedb-operator" && "$CHART" != "greptimedb-cluster" ]]; then
    echo "Error: Invalid CHART value: "$CHART"."
    exit 1
  fi

  if [[ ! "$VERSION" =~ ^v && "$CHART" != "greptimedb-operator" ]]; then
    echo "Error: VERSION must start with 'v'."
    exit 1
  fi

  chart_file="./charts/"$CHART"/Chart.yaml"
  values_file="./charts/"$CHART"/values.yaml"

  current_version=$(yq eval '.version' "$chart_file")

  major=$(echo "$current_version" | awk -F. '{print $1}')
  minor=$(echo "$current_version" | awk -F. '{print $2}')
  patch=$(echo "$current_version" | awk -F. '{print $3}')

  next_version="$major.$minor.$((patch + 1))"

  if [[ "$CHART" == "greptimedb-operator" ]]; then
    # The greptimedb-operator image tag not have 'v' prefix.
    appVersion=$VERSION
  else
    appVersion=${VERSION#v}
  fi

  yq eval ".appVersion = \"$appVersion\"" -i "$chart_file"
  yq eval ".version = \"$next_version\"" -i "$chart_file"

  echo "The chart $CHART version updated to $next_version successfully."

  yq e ".image.tag = \"$VERSION\"" "$values_file" > /tmp/"$CHART"-values-updated.yaml
  diff -U0 -w -b --ignore-blank-lines "$values_file" /tmp/"$CHART"-values-updated.yaml > /tmp/"$CHART"-values.diff
  patch "$values_file" < /tmp/"$CHART"-values.diff

  echo "The chart $CHART image updated to $VERSION successfully."
}

update_chart
