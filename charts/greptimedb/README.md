# Overview

Helm chart for [GreptimeDB](https://github.com/GreptimeTeam/greptimedb) cluster.

## How to install

**Note**: Make sure you already install the [greptimedb-operator](../greptimedb-operator/README.md).

```console
# Add charts repo.
helm repo add greptime https://greptimeteam.github.io/helm-charts/
helm repo update

# Install greptimedb in default namespace.
helm install mydb greptime/greptimedb -n default --devel
```

If you want to install greptimedb from local charts, you can:

```console
# Build dependency.
helm dependency update

# Install greptimedb in default namespace.
helm install mydb greptimedb -n default
```

## How to uninstall

```console
helm uninstall mydb -n default
```
