# Overview

Helm chart for [GreptimeDB](https://github.com/GreptimeTeam/greptimedb) standalone mode.

## How to install

```console
# Add charts repo.
helm repo add greptime https://greptimeteam.github.io/helm-charts/
helm repo update

# Install greptimedb in default namespace.
helm install greptimedb greptime/greptimedb-standalone -n default --devel
```

## How to uninstall

```console
helm uninstall greptimedb -n default
```
