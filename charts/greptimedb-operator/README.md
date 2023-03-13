# Overview

Helm chart for GreptimeDB [operator](https://github.com/GreptimeTeam/greptimedb-operator).

## How to install

```console
# Add charts repo.
helm repo add greptime https://greptimeteam.github.io/helm-charts/

# Update charts repo.
helm repo update

# Search charts repo.
helm search repo greptime -l --devel 

# Deploy greptimedb-operator in default namespace.
helm install greptimedb-operator greptime/greptimedb-operator -n default --devel

# Specifiy the chart version.
helm install greptimedb-operator greptime/greptimedb-operator -n default --version <chart-version>
```

## How to uninstall

```console
helm uninstall greptimedb-operator -n default
```
