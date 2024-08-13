#!/usr/bin/env bash

OCI_REGISTRY_URL=${OCI_REGISTRY_URL:-"greptime-registry.cn-hangzhou.cr.aliyuncs.com"}
OCI_NAMESPACE=${OCI_NAMESPACE:-"charts"}
CHARTS_DIR="charts"

for dir in "$CHARTS_DIR"/*/; do
  # Ensure the directory exists and is not empty.
  if [ -d "$dir" ]; then
    # Get the chart name from the directory path.
    chart_name=$(basename "$dir")

    # Package the chart, specifying the directory and output path directly.
    helm package "$dir" --destination "$dir"

    # Get the packaged chart file path.
    packaged_file=$(find "$dir" -type f -name "*.tgz")

    echo "Package $chart_name to $packaged_file and push to oci://$OCI_REGISTRY_URL/$OCI_NAMESPACE/$chart_name ..."

    # Push the packaged chart to the OCI repository, handling the output path.
    helm push "${packaged_file}" "oci://$OCI_REGISTRY_URL/$OCI_NAMESPACE"
  fi
done
