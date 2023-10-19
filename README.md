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

**Note**: Since our charts are still in development, we don't release the stable release version, and the `--devel` option is required.

### Install the GreptimeDB Cluster

If you want to deploy the GreptimeDB cluster, you can use the following command(use the `default` namespace):

1. **Deploy etcd cluster**

   We recommend using the Bitnami etcd [chart](https://github.com/bitnami/charts/blob/main/bitnami/etcd/README.md) to deploy the etcd cluster:

   ```console
   helm install etcd oci://registry-1.docker.io/bitnamicharts/etcd \
   --set replicaCount=3 \
   --set auth.rbac.create=false \
   --set auth.rbac.token.enabled=false \
   -n default
   ```

2. **Deploy GreptimeDB operator**

   ```console
   helm install greptimedb-operator greptime/greptimedb-operator -n default --devel
   ```


3. **Deploy GreptimeDB cluster**

   ```console
   helm install mycluster greptime/greptimedb-cluster -n default --devel
   ```

   If you already have the etcd cluster, you can configure the `etcdEndpoints`：

   ```console
   helm install mycluster greptime/greptimedb-cluster \
   --set etcdEndpoints=etcd.default:2379 \
   -n default --devel
   ```

   You also can list the current releases by `helm` command:

   ```console
   helm list -n default
   ```

4. **Use `kubectl port-forward` to access the GreptimeDB cluster**

   ```console
   # You can use the MySQL client to connect the cluster, for example: 'mysql -h 127.0.0.1 -P 4002'.
   kubectl port-forward svc/mycluster-frontend 4002:4002 > connections.out &
   
   # You can use the PostgreSQL client to connect the cluster, for example: 'psql -h 127.0.0.1 -p 4003 -d public'.
   kubectl port-forward svc/mycluster-frontend 4003:4003 > connections.out &
   ```

   You also can read and write data by [Cluster](https://docs.greptime.com/user-guide/cluster).

### Upgrade

If you want to re-deploy the service because the configurations changed, you can:

```console
helm upgrade <your-release> <chart> --values <your-values-file> -n <namespace>
```

For example:

```console
helm upgrade mycluster greptime/greptimedb --values ./values.yaml
```

### Uninstallation

If you want to terminate the GreptimeDB cluster, you can use the following command:

```console
helm uninstall mycluster -n default
helm uninstall etcd -n default
helm uninstall greptimedb-operator -n default
```

The CRDs of GreptimeDB are not deleted [by default](https://helm.sh/docs/topics/charts/#limitations-on-crds). You can delete them by the following command:

```console
kubectl delete crds greptimedbclusters.greptime.io
```

## List of Charts

- [greptimedb-operator](./charts/greptimedb-operator/README.md)
- [greptimedb-standalone](./charts/greptimedb-standalone/README.md)
- [greptimedb-cluster](./charts/greptimedb-cluster/README.md)
- **Deprecated**: [greptimedb](./charts/greptimedb/README.md)

## License

helm-charts uses the [Apache 2.0 license](./LICENSE) to strike a balance between open contributions and allowing you to use the software however you want.
