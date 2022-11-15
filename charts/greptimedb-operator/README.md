# Overview

Helm chart for GreptimeDB [operator](https://github.com/GreptimeTeam/greptimedb-operator).

## How to install

```console
# Add charts repo.
helm repo add greptime https://greptimeteam.github.io/helm-charts/
helm repo update

# Deploy greptimedb-operator in default namespace.
helm install gtcloud greptime/greptimedb-operator -n default --devel

# Specifiy the chart version.
helm install gtcloud greptime/greptimedb-operator -n default --version <chart-version>
```

## How to uninstall

```console
helm uninstall gtcloud -n default
```
