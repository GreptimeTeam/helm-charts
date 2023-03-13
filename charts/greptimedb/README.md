# Overview

Helm chart for [GreptimeDB](https://github.com/GreptimeTeam/greptimedb) cluster.

## How to install

**Note**: Make sure you already install the [greptimedb-operator](../greptimedb-operator/README.md).

```console
# Add charts repo.
helm repo add greptime https://greptimeteam.github.io/helm-charts/
helm repo update

# Optional: Install etcd cluster.
# You also can use your own etcd cluster.
helm install etcd greptime/greptimedb-etcd -n default --devel

# Install greptimedb in default namespace.
helm install greptimedb greptime/greptimedb --set etcdEndpoints=greptimedb-etcd-svc.default:2379 -n default --devel
```

## How to uninstall

```console
helm uninstall greptimedb -n default
```
