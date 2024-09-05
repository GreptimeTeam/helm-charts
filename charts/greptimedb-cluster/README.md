# greptimedb-cluster

A Helm chart for deploying GreptimeDB cluster in Kubernetes.

![Version: 0.2.10](https://img.shields.io/badge/Version-0.2.10-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.9.2](https://img.shields.io/badge/AppVersion-0.9.2-informational?style=flat-square)

## Source Code

- https://github.com/GreptimeTeam/greptimedb

## How to install

### Prerequisites

1. Install the [greptimedb-operator](../greptimedb-operator/README.md);

2. Install the etcd cluster:

   ```console
   helm upgrade \
    --install etcd oci://registry-1.docker.io/bitnamicharts/etcd \
    --set replicaCount=3 \
    --set auth.rbac.create=false \
    --set auth.rbac.token.enabled=false \
    --create-namespace \
    -n etcd-cluster
   ```

### Default installation

The default installation will use the local storage:

```console
helm upgrade \
  --install mycluster \
  --set meta.etcdEndpoints=etcd.etcd-cluster.svc.cluster.local:2379 \
  greptime/greptimedb-cluster \
  -n default
```

### Use AWS S3 as backend storage

Before installation, you must create the AWS S3 bucket, and the cluster will use the bucket as backend storage:

```console
helm upgrade \
  --install mycluster \
  --set meta.etcdEndpoints=etcd.etcd-cluster.svc.cluster.local:2379 \
  --set objectStorage.s3.bucket="your-bucket" \
  --set objectStorage.s3.region="region-of-bucket" \
  --set objectStorage.s3.root="root-directory-of-data" \
  --set objectStorage.credentials.accessKeyId="your-access-key-id" \
  --set objectStorage.credentials.secretAccessKey="your-secret-access-key" \
  greptime/greptimedb-cluster \
  -n default
```

If you set `storage.s3.root` as `mycluser`, then the data layout will be:

```
<your-bucket>
├── mycluser
│   ├── data/
```

## How to uninstall

```console
helm uninstall mycluster -n default
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| auth | object | `{"enabled":false,"fileName":"passwd","mountPath":"/etc/greptimedb/auth","users":[{"password":"admin","username":"admin"}]}` | The static auth for greptimedb, only support one user now(https://docs.greptime.com/user-guide/clients/authentication#authentication). |
| auth.enabled | bool | `false` | Enable static auth |
| auth.fileName | string | `"passwd"` | The auth file name, the full path is `${mountPath}/${fileName}` |
| auth.mountPath | string | `"/etc/greptimedb/auth"` | The auth file path to store the auth info |
| auth.users | list | `[{"password":"admin","username":"admin"}]` | The users to be created in the auth file |
| base.podTemplate | object | `{"affinity":{},"annotations":{},"labels":{},"main":{"args":[],"command":[],"env":[],"readinessProbe":{},"resources":{"limits":{},"requests":{}}},"nodeSelector":{},"serviceAccountName":"","tolerations":[]}` | The pod template for base |
| base.podTemplate.affinity | object | `{}` | The pod affinity |
| base.podTemplate.annotations | object | `{}` | The annotations to be created to the pod. |
| base.podTemplate.labels | object | `{}` | The labels to be created to the pod. |
| base.podTemplate.main | object | `{"args":[],"command":[],"env":[],"readinessProbe":{},"resources":{"limits":{},"requests":{}}}` | The base spec of main container |
| base.podTemplate.main.args | list | `[]` | The arguments to be passed to the command |
| base.podTemplate.main.command | list | `[]` | The command to be executed in the container |
| base.podTemplate.main.env | list | `[]` | The environment variables for the container |
| base.podTemplate.main.readinessProbe | object | `{}` | The config for readiness probe of the main container |
| base.podTemplate.main.resources.limits | object | `{}` | The resources limits for the container |
| base.podTemplate.main.resources.requests | object | `{}` | The requested resources for the container |
| base.podTemplate.nodeSelector | object | `{}` | The pod node selector |
| base.podTemplate.serviceAccountName | string | `""` | The global service account |
| base.podTemplate.tolerations | list | `[]` | The pod tolerations |
| datanode | object | `{"configData":"","configFile":"","podTemplate":{"affinity":{},"annotations":{},"labels":{},"main":{"args":[],"command":[],"env":[],"image":"","readinessProbe":{},"resources":{"limits":{},"requests":{}},"volumeMounts":[]},"nodeSelector":{},"serviceAccount":{"annotations":{},"create":false},"tolerations":[],"volumes":[]},"replicas":3,"storage":{"dataHome":"/data/greptimedb","storageClassName":null,"storageRetainPolicy":"Retain","storageSize":"10Gi","walDir":"/data/greptimedb/wal"}}` | Datanode configure |
| datanode.configData | string | `""` | Extra raw toml config data of datanode. Skip if the `configFile` is used. |
| datanode.configFile | string | `""` | Extra toml file of datanode. |
| datanode.podTemplate | object | `{"affinity":{},"annotations":{},"labels":{},"main":{"args":[],"command":[],"env":[],"image":"","readinessProbe":{},"resources":{"limits":{},"requests":{}},"volumeMounts":[]},"nodeSelector":{},"serviceAccount":{"annotations":{},"create":false},"tolerations":[],"volumes":[]}` | The pod template for datanode |
| datanode.podTemplate.affinity | object | `{}` | The pod affinity |
| datanode.podTemplate.annotations | object | `{}` | The annotations to be created to the pod. |
| datanode.podTemplate.labels | object | `{}` | The labels to be created to the pod. |
| datanode.podTemplate.main | object | `{"args":[],"command":[],"env":[],"image":"","readinessProbe":{},"resources":{"limits":{},"requests":{}},"volumeMounts":[]}` | The spec of main container |
| datanode.podTemplate.main.args | list | `[]` | The arguments to be passed to the command |
| datanode.podTemplate.main.command | list | `[]` | The command to be executed in the container |
| datanode.podTemplate.main.env | list | `[]` | The environment variables for the container |
| datanode.podTemplate.main.image | string | `""` | The datanode image. |
| datanode.podTemplate.main.readinessProbe | object | `{}` | The config for readiness probe of the main container |
| datanode.podTemplate.main.resources.limits | object | `{}` | The resources limits for the container |
| datanode.podTemplate.main.resources.requests | object | `{}` | The requested resources for the container |
| datanode.podTemplate.main.volumeMounts | list | `[]` | The pod volumeMounts |
| datanode.podTemplate.nodeSelector | object | `{}` | The pod node selector |
| datanode.podTemplate.serviceAccount.annotations | object | `{}` | The annotations for datanode serviceaccount |
| datanode.podTemplate.serviceAccount.create | bool | `false` | Create a service account |
| datanode.podTemplate.tolerations | list | `[]` | The pod tolerations |
| datanode.podTemplate.volumes | list | `[]` | The pod volumes |
| datanode.replicas | int | `3` | Datanode replicas |
| datanode.storage.dataHome | string | `"/data/greptimedb"` | The dataHome directory, default is "/data/greptimedb/" |
| datanode.storage.storageClassName | string | `nil` | Storage class for datanode persistent volume |
| datanode.storage.storageRetainPolicy | string | `"Retain"` | Storage retain policy for datanode persistent volume |
| datanode.storage.storageSize | string | `"10Gi"` | Storage size for datanode persistent volume |
| datanode.storage.walDir | string | `"/data/greptimedb/wal"` | The wal directory of the storage, default is "/data/greptimedb/wal" |
| debugPod.enabled | bool | `false` | Enable debug pod |
| debugPod.image | object | `{"registry":"docker.io","repository":"greptime/greptime-tool","tag":"20240905-67eaa147"}` | The debug pod image |
| debugPod.resources | object | `{"limits":{"cpu":"200m","memory":"256Mi"},"requests":{"cpu":"50m","memory":"64Mi"}}` | The debug pod resource |
| flownode | object | `{"configData":"","configFile":"","enabled":false,"podTemplate":{"affinity":{},"annotations":{},"labels":{},"main":{"args":[],"command":[],"env":[],"image":"","readinessProbe":{},"resources":{"limits":{},"requests":{}},"volumeMounts":[]},"nodeSelector":{},"serviceAccount":{"annotations":{},"create":false},"tolerations":[],"volumes":[]},"replicas":1}` | Flownode configure. **It's NOT READY YET** |
| flownode.configData | string | `""` | Extra raw toml config data of flownode. Skip if the `configFile` is used. |
| flownode.configFile | string | `""` | Extra toml file of flownode. |
| flownode.enabled | bool | `false` | Enable flownode |
| flownode.podTemplate | object | `{"affinity":{},"annotations":{},"labels":{},"main":{"args":[],"command":[],"env":[],"image":"","readinessProbe":{},"resources":{"limits":{},"requests":{}},"volumeMounts":[]},"nodeSelector":{},"serviceAccount":{"annotations":{},"create":false},"tolerations":[],"volumes":[]}` | The pod template for frontend |
| flownode.podTemplate.affinity | object | `{}` | The pod affinity |
| flownode.podTemplate.annotations | object | `{}` | The annotations to be created to the pod. |
| flownode.podTemplate.labels | object | `{}` | The labels to be created to the pod. |
| flownode.podTemplate.main | object | `{"args":[],"command":[],"env":[],"image":"","readinessProbe":{},"resources":{"limits":{},"requests":{}},"volumeMounts":[]}` | The spec of main container |
| flownode.podTemplate.main.args | list | `[]` | The arguments to be passed to the command |
| flownode.podTemplate.main.command | list | `[]` | The command to be executed in the container |
| flownode.podTemplate.main.env | list | `[]` | The environment variables for the container |
| flownode.podTemplate.main.image | string | `""` | The flownode image. |
| flownode.podTemplate.main.readinessProbe | object | `{}` | The config for readiness probe of the main container |
| flownode.podTemplate.main.resources.limits | object | `{}` | The resources limits for the container |
| flownode.podTemplate.main.resources.requests | object | `{}` | The requested resources for the container |
| flownode.podTemplate.main.volumeMounts | list | `[]` | The pod volumeMounts |
| flownode.podTemplate.nodeSelector | object | `{}` | The pod node selector |
| flownode.podTemplate.serviceAccount.annotations | object | `{}` | The annotations for flownode serviceaccount |
| flownode.podTemplate.serviceAccount.create | bool | `false` | Create a service account |
| flownode.podTemplate.tolerations | list | `[]` | The pod tolerations |
| flownode.podTemplate.volumes | list | `[]` | The pod volumes |
| flownode.replicas | int | `1` | Flownode replicas |
| frontend | object | `{"configData":"","configFile":"","podTemplate":{"affinity":{},"annotations":{},"labels":{},"main":{"args":[],"command":[],"env":[],"image":"","readinessProbe":{},"resources":{"limits":{},"requests":{}},"volumeMounts":[]},"nodeSelector":{},"serviceAccount":{"annotations":{},"create":false},"tolerations":[],"volumes":[]},"replicas":1,"service":{},"tls":{}}` | Frontend configure |
| frontend.configData | string | `""` | Extra raw toml config data of frontend. Skip if the `configFile` is used. |
| frontend.configFile | string | `""` | Extra toml file of frontend. |
| frontend.podTemplate | object | `{"affinity":{},"annotations":{},"labels":{},"main":{"args":[],"command":[],"env":[],"image":"","readinessProbe":{},"resources":{"limits":{},"requests":{}},"volumeMounts":[]},"nodeSelector":{},"serviceAccount":{"annotations":{},"create":false},"tolerations":[],"volumes":[]}` | The pod template for frontend |
| frontend.podTemplate.affinity | object | `{}` | The pod affinity |
| frontend.podTemplate.annotations | object | `{}` | The annotations to be created to the pod. |
| frontend.podTemplate.labels | object | `{}` | The labels to be created to the pod. |
| frontend.podTemplate.main | object | `{"args":[],"command":[],"env":[],"image":"","readinessProbe":{},"resources":{"limits":{},"requests":{}},"volumeMounts":[]}` | The spec of main container |
| frontend.podTemplate.main.args | list | `[]` | The arguments to be passed to the command |
| frontend.podTemplate.main.command | list | `[]` | The command to be executed in the container |
| frontend.podTemplate.main.env | list | `[]` | The environment variables for the container |
| frontend.podTemplate.main.image | string | `""` | The frontend image. |
| frontend.podTemplate.main.readinessProbe | object | `{}` | The config for readiness probe of the main container |
| frontend.podTemplate.main.resources.limits | object | `{}` | The resources limits for the container |
| frontend.podTemplate.main.resources.requests | object | `{}` | The requested resources for the container |
| frontend.podTemplate.main.volumeMounts | list | `[]` | The pod volumeMounts |
| frontend.podTemplate.nodeSelector | object | `{}` | The pod node selector |
| frontend.podTemplate.serviceAccount.annotations | object | `{}` | The annotations for frontend serviceaccount |
| frontend.podTemplate.serviceAccount.create | bool | `false` | Create a service account |
| frontend.podTemplate.tolerations | list | `[]` | The pod tolerations |
| frontend.podTemplate.volumes | list | `[]` | The pod volumes |
| frontend.replicas | int | `1` | Frontend replicas |
| frontend.service | object | `{}` | Frontend service |
| frontend.tls | object | `{}` | Frontend tls configure |
| grpcServicePort | int | `4001` | GreptimeDB grpc service port |
| httpServicePort | int | `4000` | GreptimeDB http service port |
| image.pullSecrets | list | `[]` | The image pull secrets |
| image.registry | string | `"docker.io"` | The image registry |
| image.repository | string | `"greptime/greptimedb"` | The image repository |
| image.tag | string | `"v0.9.2"` | The image tag |
| initializer.registry | string | `"docker.io"` | Initializer image registry |
| initializer.repository | string | `"greptime/greptimedb-initializer"` | Initializer image repository |
| initializer.tag | string | `"v0.1.0-alpha.29"` | Initializer image tag |
| meta | object | `{"configData":"","configFile":"","enableRegionFailover":false,"etcdEndpoints":"etcd.default.svc.cluster.local:2379","podTemplate":{"affinity":{},"annotations":{},"labels":{},"main":{"args":[],"command":[],"env":[],"image":"","resources":{"limits":{},"requests":{}},"volumeMounts":[]},"nodeSelector":{},"readinessProbe":{},"serviceAccount":{"annotations":{},"create":false},"tolerations":[],"volumes":[]},"replicas":1,"storeKeyPrefix":""}` | Meta configure |
| meta.configData | string | `""` | Extra raw toml config data of meta. Skip if the `configFile` is used. |
| meta.configFile | string | `""` | Extra toml file of meta. |
| meta.enableRegionFailover | bool | `false` | Whether to enable region failover |
| meta.etcdEndpoints | string | `"etcd.default.svc.cluster.local:2379"` | Meta etcd endpoints |
| meta.podTemplate | object | `{"affinity":{},"annotations":{},"labels":{},"main":{"args":[],"command":[],"env":[],"image":"","resources":{"limits":{},"requests":{}},"volumeMounts":[]},"nodeSelector":{},"readinessProbe":{},"serviceAccount":{"annotations":{},"create":false},"tolerations":[],"volumes":[]}` | The pod template for meta |
| meta.podTemplate.affinity | object | `{}` | The pod affinity |
| meta.podTemplate.annotations | object | `{}` | The annotations to be created to the pod. |
| meta.podTemplate.labels | object | `{}` | The labels to be created to the pod. |
| meta.podTemplate.main | object | `{"args":[],"command":[],"env":[],"image":"","resources":{"limits":{},"requests":{}},"volumeMounts":[]}` | The spec of main container |
| meta.podTemplate.main.args | list | `[]` | The arguments to be passed to the command |
| meta.podTemplate.main.command | list | `[]` | The command to be executed in the container |
| meta.podTemplate.main.env | list | `[]` | The environment variables for the container |
| meta.podTemplate.main.image | string | `""` | The meta image. |
| meta.podTemplate.main.resources.limits | object | `{}` | The resources limits for the container |
| meta.podTemplate.main.resources.requests | object | `{}` | The requested resources for the container |
| meta.podTemplate.main.volumeMounts | list | `[]` | The pod volumeMounts |
| meta.podTemplate.nodeSelector | object | `{}` | The pod node selector |
| meta.podTemplate.readinessProbe | object | `{}` | The config for readiness probe of the main container |
| meta.podTemplate.serviceAccount.annotations | object | `{}` | The annotations for meta serviceaccount |
| meta.podTemplate.serviceAccount.create | bool | `false` | Create a service account |
| meta.podTemplate.tolerations | list | `[]` | The pod tolerations |
| meta.podTemplate.volumes | list | `[]` | The pod volumes |
| meta.replicas | int | `1` | Meta replicas |
| meta.storeKeyPrefix | string | `""` | Meta will store data with this key prefix |
| mysqlServicePort | int | `4002` | GreptimeDB mysql service port |
| objectStorage | object | `{"gcs":{},"oss":{},"s3":{}}` | Configure to object storage |
| postgresServicePort | int | `4003` | GreptimeDB postgres service port |
| prometheusMonitor | object | `{"enabled":false,"interval":"30s","labels":{"release":"prometheus"}}` | Configure to prometheus PodMonitor |
| prometheusMonitor.enabled | bool | `false` | Create PodMonitor resource for scraping metrics using PrometheusOperator |
| prometheusMonitor.interval | string | `"30s"` | Interval at which metrics should be scraped |
| prometheusMonitor.labels | object | `{"release":"prometheus"}` | Add labels to the PodMonitor |
| remoteWal | object | `{"enabled":false,"kafka":{"brokerEndpoints":[]}}` | Configure to remote wal |
| remoteWal.enabled | bool | `false` | Enable remote wal |
| remoteWal.kafka | object | `{"brokerEndpoints":[]}` | The remote wal type, only support kafka now. |
| remoteWal.kafka.brokerEndpoints | list | `[]` | The kafka broker endpoints |
