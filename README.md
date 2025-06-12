# Greptime Helm Charts

## Overview

This is the repository that contains [Greptime](https://greptime.com/) Helm charts.

## Prerequisites

- [Helm v3](https://helm.sh/docs/intro/install/)

## Getting Started

### Add Chart Repository

You can add the chart repository with the following commands:

```console
helm repo add greptime https://greptimeteam.github.io/helm-charts/
helm repo update
```

You can run the following command to see the charts:

```console
helm search repo greptime
```

### OCI Artifacts

Besides using the GitHub chart repo, you can also use OCI artifacts.

The charts are also available in ACR namespace `greptime-registry.cn-hangzhou.cr.aliyuncs.com/charts`. 

You don't have to add a chart repository explicitly when using OCI artifacts, for example:

```console
helm upgrade \
  --install \
  --create-namespace \
  --set image.registry=greptime-registry.cn-hangzhou.cr.aliyuncs.com \
  greptimedb-operator oci://greptime-registry.cn-hangzhou.cr.aliyuncs.com/charts/greptimedb-operator \
  -n greptimedb-admin
```

The chart name and version will remain consistent with the GitHub chart repo.

### Install the GreptimeDB Cluster

If you want to deploy the GreptimeDB cluster, you can use the following commands:

1. **Deploy etcd cluster**

   We recommend using the Bitnami etcd [chart](https://github.com/bitnami/charts/blob/main/bitnami/etcd/README.md) to deploy the etcd cluster:

   ```console
   helm upgrade \
     --install etcd oci://registry-1.docker.io/bitnamicharts/etcd \
     --set replicaCount=3 \
     --set auth.rbac.create=false \
     --set auth.rbac.token.enabled=false \
     --create-namespace \
     -n etcd-cluster
   ```

   You can also use `oci://greptime-registry.cn-hangzhou.cr.aliyuncs.com/charts/etcd:11.3.4`.

   For detailed operations (backup, restore, monitoring, defrag), refer to the [etcd management guide](https://docs.greptime.com/user-guide/deployments-administration/manage-metadata/manage-etcd).


2. **Deploy GreptimeDB operator**

   The greptimedb-operator will install in the `greptimedb-admin` namespace:

   ```console
   helm upgrade \
     --install \
     --create-namespace \
     greptimedb-operator greptime/greptimedb-operator \
     -n greptimedb-admin
   ```

3. **Deploy GreptimeDB cluster**

   Install the GreptimeDB cluster in the `default` namespace:

    - **Default installation**

      The default installation will use the local storage:

      ```console
      helm upgrade \
        --install mycluster \
        --set meta.backendStorage.etcd.endpoints=etcd.etcd-cluster.svc.cluster.local:2379 \
        greptime/greptimedb-cluster \
        -n default
      ```

    - **Use AWS S3 as backend storage**

      Before installation, you must create the AWS S3 bucket, and the cluster will use the bucket as backend storage:

      ```console
      helm upgrade \
        --install mycluster \
        --set meta.backendStorage.etcd.endpoints=etcd.etcd-cluster.svc.cluster.local:2379 \
        --set objectStorage.s3.bucket="your-bucket" \
        --set objectStorage.s3.region="region-of-bucket" \
        --set objectStorage.s3.root="root-directory-of-data" \
        --set objectStorage.credentials.accessKeyId="your-access-key-id" \
        --set objectStorage.credentials.secretAccessKey="your-secret-access-key" \
        greptime/greptimedb-cluster \
        -n default
      ```

4. **Use `kubectl port-forward` to access the GreptimeDB cluster**

   ```console
   # You can use the MySQL or PostgreSQL client to connect the cluster, for example: 'mysql -h 127.0.0.1 -P 4002'.
   kubectl port-forward -n default svc/mycluster-frontend 4001:4001 4002:4002 4003:4003 4000:4000
   ```

   If you want to expose the service to the public, you can use the `kubectl port-forward` command with the `--address` option:

   ```console
   kubectl port-forward --address 0.0.0.0 svc/mycluster-frontend 4001:4001 4002:4002 4003:4003 4000:4000
   ```

   You can also [read](https://docs.greptime.com/user-guide/query-data/overview) and [write](https://docs.greptime.com/user-guide/ingest-data/overview) data by referring to the documentation.

### Upgrade

If you want to re-deploy the service because the configurations changed, you can:

```console
helm upgrade --install <your-release> <chart> --values <your-values-file> -n <namespace>
```

For example:

```console
helm upgrade --install mycluster greptime/greptimedb-cluster --values ./values.yaml
```

### Uninstallation

If you want to terminate the GreptimeDB cluster, you can use the following command:

```console
helm uninstall mycluster -n default
helm uninstall etcd -n etcd-cluster
helm uninstall greptimedb-operator -n greptimedb-admin
```

The CRDs of GreptimeDB are **not deleted by default** after uninstalling greptimedb-operator unless you use `--set crds.keep=false`.

You can delete CRDs manually by the following commands:

```console
kubectl delete crds greptimedbclusters.greptime.io
kubectl delete crds greptimedbstandalones.greptime.io
```

## List of Charts

- [greptimedb-operator](./charts/greptimedb-operator/README.md)
- [greptimedb-standalone](./charts/greptimedb-standalone/README.md)
- [greptimedb-cluster](./charts/greptimedb-cluster/README.md)

## License

helm-charts uses the [Apache 2.0 license](./LICENSE) to strike a balance between open contributions and allowing you to use the software however you want.
