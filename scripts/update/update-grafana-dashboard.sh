#!/bin/bash

UPSTREAM_DASHBOARD_URL=https://raw.githubusercontent.com/GreptimeTeam/greptimedb/refs/heads/main/grafana/dashboards/cluster/dashboard.json

update_chart_version() {
  # Extract the version and increment the last digit by 1.
  VERSION=$(cat charts/greptimedb-cluster/Chart.yaml | grep -m 1 'version:' | awk '{print $2}')
  VERSION_PARTS=(${VERSION//./ })
  VERSION_PARTS[2]=$((${VERSION_PARTS[2]} + 1))
  NEW_VERSION="${VERSION_PARTS[0]}.${VERSION_PARTS[1]}.${VERSION_PARTS[2]}"
  echo "Updating chart version from '${VERSION}' to '${NEW_VERSION}'"
  sed -i "s/version: ${VERSION}/version: ${NEW_VERSION}/g" charts/greptimedb-cluster/Chart.yaml
}

update_grafana_dashboard() {
  # Download the latest dashboard from the upstream repository.
  curl -o /tmp/latest-dashboard.json ${UPSTREAM_DASHBOARD_URL}

  # Check for differences.
  if ! cmp -s /tmp/latest-dashboard.json charts/greptimedb-cluster/dashboards/greptimedb-cluster-metrics.json; then

    # Configure Git configs.
    git config --global user.email helm-charts-ci@greptime.com
    git config --global user.name helm-charts-ci

    # Copy the new dashboard file.
    cp /tmp/latest-dashboard.json charts/greptimedb-cluster/dashboards/greptimedb-cluster-metrics.json

    # Checkout a new branch.
    BRANCH_NAME="ci/update-grafana-dashboard-$(date +%Y%m%d)"
    git checkout -b $BRANCH_NAME

    # Update the chart version.
    update_chart_version

    # Execute the `make docs` command.
    make docs

    # Commit the changes.
    git add charts/greptimedb-cluster
    git commit -m "ci: update Grafana dashboard from upstream"
    git push origin $BRANCH_NAME

    # Create a Pull Request.
    gh pr create \
      --title "ci: update Grafana dashboard from upstream" \
      --body "This PR updates the Grafana dashboard from the upstream repository." \
      --base main \
      --head $BRANCH_NAME
  else
    exit 0
  fi
}

update_grafana_dashboard
