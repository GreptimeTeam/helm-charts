
# greptimedb-cluster

A Helm chart for deploying GreptimeDB cluster in Kubernetes

![Version: 0.1.2](https://img.shields.io/badge/Version-0.1.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.4.1](https://img.shields.io/badge/AppVersion-0.4.1-informational?style=flat-square)

## How to install

**Note**: Make sure you already install the [greptimedb-operator](../greptimedb-operator/README.md).

```console
# Add charts repo.
helm repo add greptime https://greptimeteam.github.io/helm-charts/
helm repo update
```

```console
# Optional: Install etcd cluster.
# You also can use your own etcd cluster.
helm install etcd oci://registry-1.docker.io/bitnamicharts/etcd \
    --set replicaCount=3 \
    --set auth.rbac.create=false \
    --set auth.rbac.token.enabled=false \
    -n default
```

```console
# Install greptimedb in default namespace.
helm install greptimedb-cluster greptime/greptimedb-cluster -n default
```

## How to uninstall

```console
helm uninstall greptimedb-cluster -n default
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| datanode.componentSpec | object | `{}` | Datanode componentSpec |
| datanode.replicas | int | `3` | Datanode replicas |
| datanode.storage.storageClassName | string | `nil` | Storage class for datanode persistent volume |
| datanode.storage.storageRetainPolicy | string | `"Retain"` | Storage retain policy for datanode persistent volume |
| datanode.storage.storageSize | string | `"10Gi"` | Storage size for datanode persistent volume |
| datanode.storage.walDir | string | `"/tmp/greptimedb/wal"` | The wal directory of the storage, default is "/tmp/greptimedb/wal" |
| frontend.componentSpec | object | `{}` | Frontend componentSpec |
| frontend.replicas | int | `1` | Frontend replicas |
| frontend.service | object | `{}` | Frontend service |
| frontend.tls | object | `{}` | Frontend tls configure |
| grpcServicePort | int | `4001` | GreptimeDB grpc service port |
| httpServicePort | int | `4000` | GreptimeDB http service port |
| image.pullSecrets | list | `[]` | The image pull secrets |
| image.registry | string | `"docker.io"` | The image registry |
| image.repository | string | `"greptime/greptimedb"` | The image repository |
| image.tag | string | `"v0.4.1"` | The image tag |
| initializer.registry | string | `"docker.io"` | Initializer image registry |
| initializer.repository | string | `"greptime/greptimedb-initializer"` | Initializer image repository |
| initializer.tag | string | `"0.1.0-alpha.17"` | Initializer image tag |
| meta.componentSpec | object | `{}` | Meta componentSpec |
| meta.etcdEndpoints | string | `"etcd.default.svc.cluster.local:2379"` | Meta etcd endpoints |
| meta.replicas | int | `1` | Meta replicas |
| mysqlServicePort | int | `4002` | GreptimeDB mysql service port |
| openTSDBServicePort | int | `4242` | GreptimeDB opentsdb service port |
| postgresServicePort | int | `4003` | GreptimeDB postgres service port |
| prometheusMonitor | object | `{}` | Configure to prometheus podmonitor |
| resources.limits | object | `{"cpu":"500m","memory":"512Mi"}` | The resources limits for the container |
| resources.requests | object | `{"cpu":"500m","memory":"512Mi"}` | The requested resources for the container |
| storage | object | `{"local":{},"oss":{},"s3":{}}` | Configure to storage |