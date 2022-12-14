# Greptime Helm Charts

## Overview

This is the repository that contains [Greptime](https://greptime.com/) Helm charts.

## Prerequisites

- [Helm v3](https://helm.sh/docs/intro/install/)

## Getting Started

### Add chart repository

You can add the chart repository with the following commands:

```console
helm repo add greptime https://greptimeteam.github.io/helm-charts/
helm repo update
```

You can run the following command to see the charts:

```console
helm search repo greptime -l --devel
```

### Install the greptimedb chart

If you want to deploy GreptimeDB cluster, you can use the following command:

1. Deploy GreptimeDB operator

   ```console
   # Deploy greptimedb-operator in new namespace.
   helm install gtcloud greptime/greptimedb-operator -n default --devel
   ```

2. Deploy etcd cluster

   ```console
   helm install mydb-etcd greptime/greptimedb-etcd -n default --devel
   ```

3. Deploy GreptimeDB cluster

   ```console
   helm install mydb greptime/greptimedb --set etcdEndpoints=mydb-etcd-svc.default:2379 -n default --devel
   ```
   
4. Use kubectl port-forward to access GreptimeDB cluster

   ```console
   kubectl port-forward svc/mydb-frontend 4002:4002 > connections.out &
   ```

You also can list the current releases by `helm` command:

```console
helm list --all-namespaces
```

If you want to terminate the GreptimeDB cluster, you can use the following command:

```console
helm uninstall mydb
helm uninstall mydb-etcd
helm uninstall gtcloud -n greptimedb-operator-system
```

The CRDs of GreptimeDB are not deleted [by default](https://helm.sh/docs/topics/charts/#limitations-on-crds). You can delete them by the following command:

```console
kubectl delete crds greptimedbclusters.greptime.io
```

## List of Charts

- [greptimedb-operator](./charts/greptimedb-operator/README.md)
- [greptimedb-etcd](./charts/greptimedb-etcd/README.md)
- [greptimedb](./charts/greptimedb/README.md)

## License

helm-charts uses the [Apache 2.0 license](./LICENSE) to strike a balance between
open contributions and allowing you to use the software however you want.
