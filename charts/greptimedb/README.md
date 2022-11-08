# Overview

This chart bootstrap GreptimeDB cluster.

# Overview

Helm chart for [GreptimeDB](https://github.com/GreptimeTeam/greptimedb) cluster.

## How to install

**Note**: Make sure you already install the [greptimedb-operator](../greptimedb-operator/README.md).

```
# Build the dependencies(etcd).
$ helm dependency build greptimedb

# Install GreptimeDB.
$ helm install mydb greptimedb -n default
```

## How to uninstall

```
$ helm uninstall mydb -n default
```
