# greptimedb-cluster

A Helm chart for deploying GreptimeDB cluster in Kubernetes

![Version: 0.1.5](https://img.shields.io/badge/Version-0.1.5-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.4.4](https://img.shields.io/badge/AppVersion-0.4.4-informational?style=flat-square)

## Source Code

- https://github.com/GreptimeTeam/greptimedb

## How to install

### Prerequisites

1. Install the [greptimedb-operator](../greptimedb-operator/README.md);

2. Install the etcd cluster:

   ```console
   helm install etcd oci://registry-1.docker.io/bitnamicharts/etcd \
     --set replicaCount=3 \
     --set auth.rbac.create=false \
     --set auth.rbac.token.enabled=false \
     -n default
   ```

### Default installation

The default installation will use the local storage:

```console
helm install greptimedb-cluster greptime/greptimedb-cluster -n default
```

### Use AWS S3 as backend storage

Before installation, you must create the AWS S3 bucket, and the cluster will use the bucket as backend storage:

```console
helm install mycluster greptime/greptimedb-cluster \
  --set storage.s3.bucket=<your-bucket> \
  --set storage.s3.region=<region-of-bucket> \
  --set storage.s3.root=<root-directory-of-data> \
  --set storage.s3.secretName=s3-credentials \
  --set storage.credentials.secretName=s3-credentials \
  --set storage.credentials.secretCreation.enabled=true \
  --set storage.credentials.secretCreation.enableEncryption=false \
  --set storage.credentials.secretCreation.data.access-key-id=<your-access-key-id> \
  --set storage.credentials.secretCreation.data.secret-access-key=<your-secret-access-key>
```

If you set `storage.s3.root` as `mycluser`, then the data layout will be:

```
<your-bucket>
├── mycluser
│   ├── data/
```

## How to uninstall

```console
helm uninstall greptimedb-cluster -n default
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| datanode.config | string | `""` | Extra datanode config in toml format. |
| datanode.podTemplate | object | `{}` | The pod template for datanode. |
| datanode.replicas | int | `3` | Datanode replicas |
| datanode.storage.storageClassName | string | `nil` | Storage class for datanode persistent volume |
| datanode.storage.storageRetainPolicy | string | `"Retain"` | Storage retain policy for datanode persistent volume |
| datanode.storage.storageSize | string | `"10Gi"` | Storage size for datanode persistent volume |
| datanode.storage.walDir | string | `"/tmp/greptimedb/wal"` | The wal directory of the storage, default is "/tmp/greptimedb/wal" |
| frontend.config | string | `""` | Extra frontend config in toml format. |
| frontend.podTemplate | object | `{}` | The pod template for frontend. |
| frontend.replicas | int | `1` | Frontend replicas |
| frontend.service | object | `{}` | Frontend service |
| frontend.tls | object | `{}` | Frontend tls configure |
| grpcServicePort | int | `4001` | GreptimeDB grpc service port |
| httpServicePort | int | `4000` | GreptimeDB http service port |
| image.pullSecrets | list | `[]` | The image pull secrets |
| image.registry | string | `"docker.io"` | The image registry |
| image.repository | string | `"greptime/greptimedb"` | The image repository |
| image.tag | string | `"v0.4.4"` | The image tag |
| initializer.registry | string | `"docker.io"` | Initializer image registry |
| initializer.repository | string | `"greptime/greptimedb-initializer"` | Initializer image repository |
| initializer.tag | string | `"0.1.0-alpha.17"` | Initializer image tag |
| meta.config | string | `""` | Extra Meta config in toml format. |
| meta.etcdEndpoints | string | `"etcd.default.svc.cluster.local:2379"` | Meta etcd endpoints |
| meta.podTemplate | object | `{}` | The pod template for Meta. |
| meta.replicas | int | `1` | Meta replicas |
| mysqlServicePort | int | `4002` | GreptimeDB mysql service port |
| openTSDBServicePort | int | `4242` | GreptimeDB opentsdb service port |
| postgresServicePort | int | `4003` | GreptimeDB postgres service port |
| prometheusMonitor | object | `{}` | Configure to prometheus podmonitor |
| resources.limits | object | `{"cpu":"500m","memory":"512Mi"}` | The resources limits for the container |
| resources.requests | object | `{"cpu":"500m","memory":"512Mi"}` | The requested resources for the container |
| storage | object | `{"local":{},"oss":{},"s3":{}}` | Configure to storage |
