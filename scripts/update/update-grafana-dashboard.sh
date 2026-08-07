#!/bin/bash

set -e

UPSTREAM_DASHBOARD_BASE_URL=https://raw.githubusercontent.com/GreptimeTeam/greptimedb/refs/heads/main/grafana/dashboards
DASHBOARDS=(
  "metrics/cluster/dashboard.json:greptimedb-cluster-metrics.json"
  "events/dashboard.json:greptimedb-cluster-events.json"
)

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
  local dashboard
  local destination
  local latest_dashboard
  local source
  local updated=false

  for dashboard in "${DASHBOARDS[@]}"; do
    source=${dashboard%%:*}
    destination=${dashboard#*:}
    latest_dashboard="/tmp/${destination}"

    curl -fsSL -o "${latest_dashboard}" "${UPSTREAM_DASHBOARD_BASE_URL}/${source}"
    if ! cmp -s "${latest_dashboard}" "charts/greptimedb-cluster/dashboards/${destination}"; then
      cp "${latest_dashboard}" "charts/greptimedb-cluster/dashboards/${destination}"
      updated=true
    fi
  done

  if ! ${updated}; then
    exit 0
  fi

  # Configure Git configs.
  git config --global user.email helm-charts-ci@greptime.com
  git config --global user.name helm-charts-ci

  # Checkout a new branch.
  BRANCH_NAME="ci/update-grafana-dashboard-$(date +%Y%m%d%H%M%S)"
  git checkout -b $BRANCH_NAME

  # Update the chart version.
  update_chart_version

  # Execute the `make docs` command.
  make docs

  # Commit the changes.
  git add charts/greptimedb-cluster
  git commit -s -m "ci: update Grafana dashboard from upstream"
  git push origin $BRANCH_NAME

  # Create a Pull Request.
  gh pr create \
    --title "ci: update Grafana dashboard from upstream" \
    --body "This PR updates the Grafana dashboard from the upstream repository." \
    --base main \
    --head $BRANCH_NAME \
    --reviewer sunng87 \
    --reviewer daviderli614 \
    --reviewer killme2008
}

update_grafana_dashboard
