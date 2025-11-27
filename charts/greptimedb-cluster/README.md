# greptimedb-cluster

A Helm chart for deploying GreptimeDB cluster in Kubernetes.

![Version: 0.6.42](https://img.shields.io/badge/Version-0.6.42-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0-beta.1](https://img.shields.io/badge/AppVersion-1.0.0--beta.1-informational?style=flat-square)

## Source Code

- https://github.com/GreptimeTeam/greptimedb

## Compatibility Matrix

Each row in the following matrix represents a version combination, indicating the required `greptimedb-operator` chart version when installing `greptimedb-cluster` chart.

| `greptimedb-cluster` Chart Version | `greptimedb-operator` Chart Version |
|----------------------------------|----------------------------------------------|
| < `0.4.0`                        | < `0.3.0` with GreptimeDB Operator Tag < `v0.3.0` |
| ≥ `0.4.0`                        | ≥ `0.3.0` with GreptimeDB Operator Tag ≥ `v0.3.0` |
| ≥ `0.6.38`                       | ≥ `0.5.3` with GreptimeDB Operator Tag ≥ `v0.5.2` |

## How to install

### Prerequisites

1. Install the [greptimedb-operator](../greptimedb-operator/README.md) and pay attention to the version compatibility in the above matrix.

2. Install the etcd cluster:

   ```console
   helm upgrade \
    --install etcd oci://registry-1.docker.io/bitnamicharts/etcd \
    --set replicaCount=3 \
    --set auth.rbac.create=false \
    --set auth.rbac.token.enabled=false \
    --create-namespace \
    --version 12.0.8 \
    --set global.security.allowInsecureImages=true \
    --set image.registry=docker.io \
    --set image.repository=greptime/etcd \
    --set image.tag=3.6.1-debian-12-r3 \
    -n etcd-cluster
   ```

### Default installation

The default installation will use the local storage:

```console
helm upgrade \
  --install mycluster \
  --set meta.backendStorage.etcd.endpoints=etcd.etcd-cluster.svc.cluster.local:2379 \
  greptime/greptimedb-cluster \
  -n default
```

### Use AWS S3 as backend storage

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

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://grafana.github.io/helm-charts | grafana | 8.5.8 |
| https://greptimeteam.github.io/helm-charts | greptimedb-enterprise-dashboard | 0.1.0 |
| https://greptimeteam.github.io/helm-charts | greptimedb-remote-compaction | 0.1.1 |
| https://raw.githubusercontent.com/hansehe/jaeger-all-in-one/master/helm/charts | jaeger-all-in-one | 0.1.12 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalLabels | object | `{}` | additional labels to add to all resources |
| auth | object | `{"enabled":false,"fileName":"passwd","mountPath":"/etc/greptimedb/auth","users":[{"password":"admin","username":"admin"}]}` | The static auth for greptimedb, only support one user now(https://docs.greptime.com/user-guide/deployments-administration/authentication/static). |
| auth.enabled | bool | `false` | Enable static auth |
| auth.fileName | string | `"passwd"` | The auth file name, the full path is `${mountPath}/${fileName}` |
| auth.mountPath | string | `"/etc/greptimedb/auth"` | The auth file path to store the auth info |
| auth.users | list | `[{"password":"admin","username":"admin"}]` | The users to be created in the auth file. Each user can have an optional `permission` field with values: `readwrite`, `readonly`, or `writeonly`. |
| base.podTemplate | object | `{"affinity":{},"annotations":{},"labels":{},"main":{"args":[],"command":[],"env":[],"extraArgs":[],"livenessProbe":{},"readinessProbe":{},"resources":{},"securityContext":{},"startupProbe":{}},"nodeSelector":{},"securityContext":{},"serviceAccountName":"","terminationGracePeriodSeconds":30,"tolerations":[]}` | The pod template for base |
| base.podTemplate.affinity | object | `{}` | The pod affinity |
| base.podTemplate.annotations | object | `{}` | The annotations to be created to the pod. |
| base.podTemplate.labels | object | `{}` | The labels to be created to the pod. |
| base.podTemplate.main | object | `{"args":[],"command":[],"env":[],"extraArgs":[],"livenessProbe":{},"readinessProbe":{},"resources":{},"securityContext":{},"startupProbe":{}}` | The base spec of main container |
| base.podTemplate.main.args | list | `[]` | The arguments to be passed to the command |
| base.podTemplate.main.command | list | `[]` | The command to be executed in the container |
| base.podTemplate.main.env | list | `[]` | The environment variables for the container |
| base.podTemplate.main.extraArgs | list | `[]` | The ExtraArgs specifies additional command-line arguments for the container entrypoint |
| base.podTemplate.main.livenessProbe | object | `{}` | The config for liveness probe of the main container |
| base.podTemplate.main.readinessProbe | object | `{}` | The config for readiness probe of the main container |
| base.podTemplate.main.securityContext | object | `{}` | The configurations for security context of main container. |
| base.podTemplate.main.startupProbe | object | `{}` | The config for startup probe of the main container |
| base.podTemplate.nodeSelector | object | `{}` | The pod node selector |
| base.podTemplate.securityContext | object | `{}` | The configurations for pod security context. |
| base.podTemplate.serviceAccountName | string | `""` | The global service account |
| base.podTemplate.terminationGracePeriodSeconds | int | `30` | The termination grace period seconds |
| base.podTemplate.tolerations | list | `[]` | The pod tolerations |
| customImageRegistry | object | `{"enabled":false,"password":"","registry":"","secretName":"greptimedb-custom-image-pull-secret","username":""}` | Custom image registry |
| customImageRegistry.enabled | bool | `false` | Whether to enable custom image registry and generate a pull secret in the release namespace |
| customImageRegistry.password | string | `""` | The password of the custom image |
| customImageRegistry.registry | string | `""` | The registry of the custom image |
| customImageRegistry.secretName | string | `"greptimedb-custom-image-pull-secret"` | The name of the pull secret. You can use the name in `image.pullSecrets`. |
| customImageRegistry.username | string | `""` | The username of the custom image |
| dashboards | object | `{"annotations":{},"enabled":false,"extraLabels":{},"label":"grafana_dashboard","labelValue":"1","namespace":""}` | Deploy grafana dashboards for the grafana dashboard sidecar. https://github.com/grafana/helm-charts/tree/main/charts/grafana#sidecar-for-dashboards |
| dashboards.annotations | object | `{}` | Additional annotation for the configmap |
| dashboards.enabled | bool | `false` | Enable the grafana dashboards sidecar. |
| dashboards.extraLabels | object | `{}` | Extra labels for the configmap |
| dashboards.label | string | `"grafana_dashboard"` | The label as defined in the grafana helmchart. https://github.com/grafana/helm-charts/tree/main/charts/grafana#sidecar-for-dashboards |
| dashboards.labelValue | string | `"1"` | The label value as defined in the grafana helmchart. https://github.com/grafana/helm-charts/tree/main/charts/grafana#sidecar-for-dashboards |
| dashboards.namespace | string | `""` | The namespace in which the grafana dashboard configmaps are installed |
| datanode | object | `{"configData":"","configFile":"","enabled":true,"logging":{},"podTemplate":{"affinity":{},"annotations":{},"labels":{},"main":{"args":[],"command":[],"env":[],"extraArgs":[],"image":"","livenessProbe":{},"readinessProbe":{},"resources":{},"securityContext":{},"startupProbe":{},"volumeMounts":[]},"nodeSelector":{},"securityContext":{},"serviceAccount":{"annotations":{},"create":false},"tolerations":[],"volumes":[]},"replicas":1,"storage":{"annotations":{},"dataHome":"/data/greptimedb","labels":{},"mountPath":"/data/greptimedb","storageClassName":null,"storageRetainPolicy":"Retain","storageSize":"20Gi","useEmptyDir":false},"tracing":{"enabled":false,"endpoint":"http://mycluster-monitor-standalone.default:4000/v1/otlp/v1/traces","sampleRatio":"1.0"}}` | Datanode configure |
| datanode.configData | string | `""` | Extra raw toml config data of datanode. Skip if the `configFile` is used. |
| datanode.configFile | string | `""` | Extra toml file of datanode. |
| datanode.logging | object | `{}` | Logging configuration for datanode, if not set, it will use the global logging configuration. |
| datanode.podTemplate | object | `{"affinity":{},"annotations":{},"labels":{},"main":{"args":[],"command":[],"env":[],"extraArgs":[],"image":"","livenessProbe":{},"readinessProbe":{},"resources":{},"securityContext":{},"startupProbe":{},"volumeMounts":[]},"nodeSelector":{},"securityContext":{},"serviceAccount":{"annotations":{},"create":false},"tolerations":[],"volumes":[]}` | The pod template for datanode |
| datanode.podTemplate.affinity | object | `{}` | The pod affinity |
| datanode.podTemplate.annotations | object | `{}` | The annotations to be created to the pod. |
| datanode.podTemplate.labels | object | `{}` | The labels to be created to the pod. |
| datanode.podTemplate.main | object | `{"args":[],"command":[],"env":[],"extraArgs":[],"image":"","livenessProbe":{},"readinessProbe":{},"resources":{},"securityContext":{},"startupProbe":{},"volumeMounts":[]}` | The spec of main container |
| datanode.podTemplate.main.args | list | `[]` | The arguments to be passed to the command |
| datanode.podTemplate.main.command | list | `[]` | The command to be executed in the container |
| datanode.podTemplate.main.env | list | `[]` | The environment variables for the container |
| datanode.podTemplate.main.extraArgs | list | `[]` | The ExtraArgs specifies additional command-line arguments for the container entrypoint |
| datanode.podTemplate.main.image | string | `""` | The datanode image. |
| datanode.podTemplate.main.livenessProbe | object | `{}` | The config for liveness probe of the main container |
| datanode.podTemplate.main.readinessProbe | object | `{}` | The config for readiness probe of the main container |
| datanode.podTemplate.main.securityContext | object | `{}` | The configurations for datanode security context. |
| datanode.podTemplate.main.startupProbe | object | `{}` | The config for startup probe of the main container |
| datanode.podTemplate.main.volumeMounts | list | `[]` | The pod volumeMounts |
| datanode.podTemplate.nodeSelector | object | `{}` | The pod node selector |
| datanode.podTemplate.securityContext | object | `{}` | The configurations for datanode security context. |
| datanode.podTemplate.serviceAccount.annotations | object | `{}` | The annotations for datanode serviceaccount |
| datanode.podTemplate.serviceAccount.create | bool | `false` | Create a service account |
| datanode.podTemplate.tolerations | list | `[]` | The pod tolerations |
| datanode.podTemplate.volumes | list | `[]` | The pod volumes |
| datanode.replicas | int | `1` | Datanode replicas |
| datanode.storage.annotations | object | `{}` | The annotations for the PVC that will be created |
| datanode.storage.dataHome | string | `"/data/greptimedb"` | The dataHome directory, default is "/data/greptimedb/" |
| datanode.storage.labels | object | `{}` | The labels for the PVC that will be created |
| datanode.storage.mountPath | string | `"/data/greptimedb"` | The data directory of the storage, default is "/data/greptimedb" |
| datanode.storage.storageClassName | string | `nil` | Storage class for datanode persistent volume |
| datanode.storage.storageRetainPolicy | string | `"Retain"` | Storage retain policy for datanode persistent volume |
| datanode.storage.storageSize | string | `"20Gi"` | Storage size for datanode persistent volume |
| datanode.storage.useEmptyDir | bool | `false` | The useEmptyDir is a flag to indicate whether to use an empty dir. If true, the PVC will not be created and the whole storage of datanode will be cleaned up when the datanode restarts. |
| datanode.tracing | object | `{"enabled":false,"endpoint":"http://mycluster-monitor-standalone.default:4000/v1/otlp/v1/traces","sampleRatio":"1.0"}` | Tracing configuration for datanode, if not set, it will use the global logging configuration. |
| datanode.tracing.enabled | bool | `false` | Enable tracing. |
| datanode.tracing.endpoint | string | `"http://mycluster-monitor-standalone.default:4000/v1/otlp/v1/traces"` | The OTLP tracing endpoint. |
| datanode.tracing.sampleRatio | string | `"1.0"` | SampleRatio is the percentage of tracing will be sampled and exported. Valid range `[0, 1]`, 1 means all traces are sampled, 0 means all traces are not sampled, the default value is 1. |
| datanodeGroups | list | `[]` | datanode instance groups configure, 'spec.datanode' and 'spec.datanodeGroups' cannot be set at the same time. |
| debugPod | object | `{"enabled":false,"image":{"registry":"docker.io","repository":"greptime/greptime-tool","tag":"20250606-04e3c7d"},"resources":{"limits":{"cpu":"200m","memory":"256Mi"},"requests":{"cpu":"50m","memory":"64Mi"}}}` | Configure to the debug pod |
| debugPod.enabled | bool | `false` | Enable debug pod, for more information see: "../../docker/debug-pod/README.md". |
| debugPod.image | object | `{"registry":"docker.io","repository":"greptime/greptime-tool","tag":"20250606-04e3c7d"}` | The debug pod image |
| debugPod.resources | object | `{"limits":{"cpu":"200m","memory":"256Mi"},"requests":{"cpu":"50m","memory":"64Mi"}}` | The debug pod resource |
| dedicatedWAL | object | `{"enabled":false,"raftEngine":{"fs":{"mountPath":"/wal","name":"wal","storageClassName":null,"storageSize":"20Gi"}}}` | Configure to dedicated wal |
| dedicatedWAL.enabled | bool | `false` | Enable dedicated wal |
| dedicatedWAL.raftEngine | object | `{"fs":{"mountPath":"/wal","name":"wal","storageClassName":null,"storageSize":"20Gi"}}` | Configure to raft engine |
| dedicatedWAL.raftEngine.fs | object | `{"mountPath":"/wal","name":"wal","storageClassName":null,"storageSize":"20Gi"}` | Configure to fs |
| dedicatedWAL.raftEngine.fs.mountPath | string | `"/wal"` | The mount path |
| dedicatedWAL.raftEngine.fs.name | string | `"wal"` | The name of the wal |
| dedicatedWAL.raftEngine.fs.storageClassName | string | `nil` | The storage class name |
| dedicatedWAL.raftEngine.fs.storageSize | string | `"20Gi"` | The storage size |
| flownode | object | `{"configData":"","configFile":"","enabled":true,"logging":{},"podTemplate":{"affinity":{},"annotations":{},"labels":{},"main":{"args":[],"command":[],"env":[],"extraArgs":[],"image":"","livenessProbe":{},"readinessProbe":{},"resources":{},"securityContext":{},"startupProbe":{},"volumeMounts":[]},"nodeSelector":{},"securityContext":{},"serviceAccount":{"annotations":{},"create":false},"tolerations":[],"volumes":[]},"replicas":1,"tracing":{"enabled":false,"endpoint":"http://mycluster-monitor-standalone.default:4000/v1/otlp/v1/traces","sampleRatio":"1.0"}}` | Flownode configure. |
| flownode.configData | string | `""` | Extra raw toml config data of flownode. Skip if the `configFile` is used. |
| flownode.configFile | string | `""` | Extra toml file of flownode. |
| flownode.enabled | bool | `true` | Enable flownode |
| flownode.logging | object | `{}` | Logging configuration for flownode, if not set, it will use the global logging configuration. |
| flownode.podTemplate | object | `{"affinity":{},"annotations":{},"labels":{},"main":{"args":[],"command":[],"env":[],"extraArgs":[],"image":"","livenessProbe":{},"readinessProbe":{},"resources":{},"securityContext":{},"startupProbe":{},"volumeMounts":[]},"nodeSelector":{},"securityContext":{},"serviceAccount":{"annotations":{},"create":false},"tolerations":[],"volumes":[]}` | The pod template for frontend |
| flownode.podTemplate.affinity | object | `{}` | The pod affinity |
| flownode.podTemplate.annotations | object | `{}` | The annotations to be created to the pod. |
| flownode.podTemplate.labels | object | `{}` | The labels to be created to the pod. |
| flownode.podTemplate.main | object | `{"args":[],"command":[],"env":[],"extraArgs":[],"image":"","livenessProbe":{},"readinessProbe":{},"resources":{},"securityContext":{},"startupProbe":{},"volumeMounts":[]}` | The spec of main container |
| flownode.podTemplate.main.args | list | `[]` | The arguments to be passed to the command |
| flownode.podTemplate.main.command | list | `[]` | The command to be executed in the container |
| flownode.podTemplate.main.env | list | `[]` | The environment variables for the container |
| flownode.podTemplate.main.extraArgs | list | `[]` | The ExtraArgs specifies additional command-line arguments for the container entrypoint |
| flownode.podTemplate.main.image | string | `""` | The flownode image. |
| flownode.podTemplate.main.livenessProbe | object | `{}` | The config for liveness probe of the main container |
| flownode.podTemplate.main.readinessProbe | object | `{}` | The config for readiness probe of the main container |
| flownode.podTemplate.main.securityContext | object | `{}` | The configurations for flownode security context. |
| flownode.podTemplate.main.startupProbe | object | `{}` | The config for startup probe of the main container |
| flownode.podTemplate.main.volumeMounts | list | `[]` | The pod volumeMounts |
| flownode.podTemplate.nodeSelector | object | `{}` | The pod node selector |
| flownode.podTemplate.securityContext | object | `{}` | The configurations for flownode security context. |
| flownode.podTemplate.serviceAccount.annotations | object | `{}` | The annotations for flownode serviceaccount |
| flownode.podTemplate.serviceAccount.create | bool | `false` | Create a service account |
| flownode.podTemplate.tolerations | list | `[]` | The pod tolerations |
| flownode.podTemplate.volumes | list | `[]` | The pod volumes |
| flownode.replicas | int | `1` | Flownode replicas |
| flownode.tracing | object | `{"enabled":false,"endpoint":"http://mycluster-monitor-standalone.default:4000/v1/otlp/v1/traces","sampleRatio":"1.0"}` | Tracing configuration for flownode, if not set, it will use the global logging configuration. |
| flownode.tracing.enabled | bool | `false` | Enable tracing. |
| flownode.tracing.endpoint | string | `"http://mycluster-monitor-standalone.default:4000/v1/otlp/v1/traces"` | The OTLP tracing endpoint. |
| flownode.tracing.sampleRatio | string | `"1.0"` | SampleRatio is the percentage of tracing will be sampled and exported. Valid range `[0, 1]`, 1 means all traces are sampled, 0 means all traces are not sampled, the default value is 1. |
| frontend | object | `{"configData":"","configFile":"","enableObjectStorage":false,"enabled":true,"logging":{},"podTemplate":{"affinity":{},"annotations":{},"labels":{},"main":{"args":[],"command":[],"env":[],"extraArgs":[],"image":"","livenessProbe":{},"readinessProbe":{},"resources":{},"securityContext":{},"startupProbe":{},"volumeMounts":[]},"nodeSelector":{},"securityContext":{},"serviceAccount":{"annotations":{},"create":false},"tolerations":[],"volumes":[]},"replicas":1,"service":{},"tls":{},"tracing":{"enabled":false,"endpoint":"http://mycluster-monitor-standalone.default:4000/v1/otlp/v1/traces","sampleRatio":"1.0"}}` | Frontend configure |
| frontend.configData | string | `""` | Extra raw toml config data of frontend. Skip if the `configFile` is used. |
| frontend.configFile | string | `""` | Extra toml file of frontend. |
| frontend.enableObjectStorage | bool | `false` | Whether to enable object storage on frontend. |
| frontend.logging | object | `{}` | Logging configuration for frontend, if not set, it will use the global logging configuration. |
| frontend.podTemplate | object | `{"affinity":{},"annotations":{},"labels":{},"main":{"args":[],"command":[],"env":[],"extraArgs":[],"image":"","livenessProbe":{},"readinessProbe":{},"resources":{},"securityContext":{},"startupProbe":{},"volumeMounts":[]},"nodeSelector":{},"securityContext":{},"serviceAccount":{"annotations":{},"create":false},"tolerations":[],"volumes":[]}` | The pod template for frontend |
| frontend.podTemplate.affinity | object | `{}` | The pod affinity |
| frontend.podTemplate.annotations | object | `{}` | The annotations to be created to the pod. |
| frontend.podTemplate.labels | object | `{}` | The labels to be created to the pod. |
| frontend.podTemplate.main | object | `{"args":[],"command":[],"env":[],"extraArgs":[],"image":"","livenessProbe":{},"readinessProbe":{},"resources":{},"securityContext":{},"startupProbe":{},"volumeMounts":[]}` | The spec of main container |
| frontend.podTemplate.main.args | list | `[]` | The arguments to be passed to the command |
| frontend.podTemplate.main.command | list | `[]` | The command to be executed in the container |
| frontend.podTemplate.main.env | list | `[]` | The environment variables for the container |
| frontend.podTemplate.main.extraArgs | list | `[]` | The ExtraArgs specifies additional command-line arguments for the container entrypoint |
| frontend.podTemplate.main.image | string | `""` | The frontend image. |
| frontend.podTemplate.main.livenessProbe | object | `{}` | The config for liveness probe of the main container |
| frontend.podTemplate.main.readinessProbe | object | `{}` | The config for readiness probe of the main container |
| frontend.podTemplate.main.securityContext | object | `{}` | The configurations for frontend container. |
| frontend.podTemplate.main.startupProbe | object | `{}` | The config for startup probe of the main container |
| frontend.podTemplate.main.volumeMounts | list | `[]` | The pod volumeMounts |
| frontend.podTemplate.nodeSelector | object | `{}` | The pod node selector |
| frontend.podTemplate.securityContext | object | `{}` | The configurations for frontend security context. |
| frontend.podTemplate.serviceAccount.annotations | object | `{}` | The annotations for frontend serviceaccount |
| frontend.podTemplate.serviceAccount.create | bool | `false` | Create a service account |
| frontend.podTemplate.tolerations | list | `[]` | The pod tolerations |
| frontend.podTemplate.volumes | list | `[]` | The pod volumes |
| frontend.replicas | int | `1` | Frontend replicas |
| frontend.service | object | `{}` | Frontend service |
| frontend.tls | object | `{}` | Frontend tls configure |
| frontend.tracing | object | `{"enabled":false,"endpoint":"http://mycluster-monitor-standalone.default:4000/v1/otlp/v1/traces","sampleRatio":"1.0"}` | Tracing configuration for frontend, if not set, it will use the global logging configuration. |
| frontend.tracing.enabled | bool | `false` | Enable tracing. |
| frontend.tracing.endpoint | string | `"http://mycluster-monitor-standalone.default:4000/v1/otlp/v1/traces"` | The OTLP tracing endpoint. |
| frontend.tracing.sampleRatio | string | `"1.0"` | SampleRatio is the percentage of tracing will be sampled and exported. Valid range `[0, 1]`, 1 means all traces are sampled, 0 means all traces are not sampled, the default value is 1. |
| frontendGroups | list | `[]` | Frontend instance groups configure |
| grafana.adminPassword | string | `"gt-operator"` | The default admin password for grafana. |
| grafana.adminUser | string | `"admin"` | The default admin username for grafana. |
| grafana.datasources | object | `{"datasources.yaml":{"datasources":[{"access":"proxy","isDefault":true,"name":"metrics","type":"prometheus","url":"http://mycluster-monitor-standalone.default.svc.cluster.local:4000/v1/prometheus"},{"access":"proxy","isDefault":true,"name":"traces","type":"jaeger","url":"http://mycluster-monitor-standalone.default.svc.cluster.local:4000/v1/jaeger"},{"access":"proxy","database":"public","name":"logs","type":"mysql","url":"mycluster-monitor-standalone.default.svc.cluster.local:4002"},{"access":"proxy","database":"information_schema","name":"information_schema","type":"mysql","url":"mycluster-frontend.default.svc.cluster.local:4002"}]}}` | The grafana datasources. |
| grafana.enabled | bool | `false` | Enable grafana deployment. It needs to enable monitoring `monitoring.enabled: true` first. |
| grafana.image | object | `{"registry":"docker.io","repository":"grafana/grafana","tag":"11.6.0"}` | The grafana image. |
| grafana.image.registry | string | `"docker.io"` | The grafana image registry. |
| grafana.image.repository | string | `"grafana/grafana"` | The grafana image repository. |
| grafana.image.tag | string | `"11.6.0"` | The grafana image tag. |
| grafana.initChownData | object | `{"enabled":false}` | Init chown data for grafana. |
| grafana.initChownData.enabled | bool | `false` | Enable init chown data for grafana. |
| grafana.persistence | object | `{"accessModes":["ReadWriteOnce"],"enabled":true,"size":"10Gi","storageClassName":null}` | The grafana persistence configuration. |
| grafana.persistence.accessModes | list | `["ReadWriteOnce"]` | The access modes for the grafana persistence. |
| grafana.persistence.enabled | bool | `true` | Whether to enable the persistence for grafana. |
| grafana.persistence.size | string | `"10Gi"` | The storage size for the grafana persistence. |
| grafana.persistence.storageClassName | string | `nil` | The storageClassName for the grafana persistence. |
| grafana.service | object | `{"annotations":{},"enabled":true,"port":80,"type":"ClusterIP"}` | The grafana service configuration. |
| grafana.service.annotations | object | `{}` | The annotations for the grafana service. |
| grafana.service.enabled | bool | `true` | Whether to create the service for grafana. |
| grafana.service.port | int | `80` | The grafana service port. |
| grafana.service.type | string | `"ClusterIP"` | The type of the service. |
| grafana.sidecar | object | `{"dashboards":{"enabled":true,"provider":{"allowUiUpdates":true},"searchNamespace":"ALL"}}` | The grafana sidecar settings to import dashboards |
| greptimedb-enterprise-dashboard.affinity | object | `{}` |  |
| greptimedb-enterprise-dashboard.args[0] | string | `"--config=/etc/dashboard-apiserver/config.yaml"` |  |
| greptimedb-enterprise-dashboard.config | string | `"servicePort: 19095\nlogLevel: info\nprovisionedInstances:\n- name: mycluster\n  namespace: default\n  type: cluster\n  url: http://mycluster-frontend.default.svc.cluster.local:4000\n  monitoring:\n    greptimedb:\n      url: http://mycluster-monitor-standalone.default.svc.cluster.local:4000\n"` |  |
| greptimedb-enterprise-dashboard.enabled | bool | `false` | Enable greptimedb-enterprise-dashboard deployment. |
| greptimedb-enterprise-dashboard.fullnameOverride | string | `""` |  |
| greptimedb-enterprise-dashboard.image.pullPolicy | string | `"IfNotPresent"` |  |
| greptimedb-enterprise-dashboard.image.repository | string | `"Please set the image repository"` |  |
| greptimedb-enterprise-dashboard.image.tag | string | `"Please set the image repository"` |  |
| greptimedb-enterprise-dashboard.imagePullSecrets | list | `[]` |  |
| greptimedb-enterprise-dashboard.nameOverride | string | `""` |  |
| greptimedb-enterprise-dashboard.nodeSelector | object | `{}` |  |
| greptimedb-enterprise-dashboard.podAnnotations | object | `{}` |  |
| greptimedb-enterprise-dashboard.podSecurityContext | object | `{}` |  |
| greptimedb-enterprise-dashboard.replicaCount | int | `1` |  |
| greptimedb-enterprise-dashboard.resources | object | `{}` |  |
| greptimedb-enterprise-dashboard.securityContext | object | `{}` |  |
| greptimedb-enterprise-dashboard.service.annotations | object | `{}` |  |
| greptimedb-enterprise-dashboard.service.port | int | `19095` |  |
| greptimedb-enterprise-dashboard.service.type | string | `"ClusterIP"` |  |
| greptimedb-enterprise-dashboard.serviceAccount.annotations | object | `{}` |  |
| greptimedb-enterprise-dashboard.serviceAccount.create | bool | `true` |  |
| greptimedb-enterprise-dashboard.serviceAccount.name | string | `""` |  |
| greptimedb-enterprise-dashboard.servicePort | int | `19095` |  |
| greptimedb-enterprise-dashboard.tolerations | list | `[]` |  |
| greptimedb-remote-compaction.compactor | object | `{"affinity":{},"args":[],"command":[],"extraConfigData":"","heartbeatInterval":"5s","image":{"pullPolicy":"IfNotPresent","pullSecret":[],"registry":"Please set the registry","repository":"Please set the repository","tag":"Please set the tag"},"logging":{"format":"text","level":"info"},"maxBackgroundJobs":4,"nodeSelector":{},"objectStorage":{"azblob":{},"gcs":{},"oss":{},"s3":{}},"podAnnotations":{},"podLabels":{},"replicas":1,"resources":{"limits":{"cpu":"4","memory":"8Gi"},"requests":{"cpu":"500m","memory":"256Mi"}},"serviceAccount":{"annotations":{},"create":true},"tolerations":[]}` | The compactor configuration. |
| greptimedb-remote-compaction.compactor.affinity | object | `{}` | The compactor affinity. |
| greptimedb-remote-compaction.compactor.args | list | `[]` | The compactor args. It's used to override the default args. |
| greptimedb-remote-compaction.compactor.command | list | `[]` | The compactor command. It's used to override the default command. |
| greptimedb-remote-compaction.compactor.extraConfigData | string | `""` | The compactor config data. |
| greptimedb-remote-compaction.compactor.heartbeatInterval | string | `"5s"` | The compactor heartbeat interval. |
| greptimedb-remote-compaction.compactor.image | object | `{"pullPolicy":"IfNotPresent","pullSecret":[],"registry":"Please set the registry","repository":"Please set the repository","tag":"Please set the tag"}` | The compactor image. |
| greptimedb-remote-compaction.compactor.image.pullPolicy | string | `"IfNotPresent"` | The compactor image pull policy. |
| greptimedb-remote-compaction.compactor.image.pullSecret | list | `[]` | The compactor image pull secret. |
| greptimedb-remote-compaction.compactor.image.registry | string | `"Please set the registry"` | The compactor image registry. |
| greptimedb-remote-compaction.compactor.image.repository | string | `"Please set the repository"` | The compactor image repository. |
| greptimedb-remote-compaction.compactor.image.tag | string | `"Please set the tag"` | The compactor image tag. |
| greptimedb-remote-compaction.compactor.maxBackgroundJobs | int | `4` | The compactor max background jobs. |
| greptimedb-remote-compaction.compactor.nodeSelector | object | `{}` | The compactor node selector. |
| greptimedb-remote-compaction.compactor.objectStorage | object | `{"azblob":{},"gcs":{},"oss":{},"s3":{}}` | Configure to object storage |
| greptimedb-remote-compaction.compactor.podAnnotations | object | `{}` | The compactor pod annotations. |
| greptimedb-remote-compaction.compactor.podLabels | object | `{}` | The compactor pod labels. |
| greptimedb-remote-compaction.compactor.replicas | int | `1` | The compactor replicas. |
| greptimedb-remote-compaction.compactor.resources | object | `{"limits":{"cpu":"4","memory":"8Gi"},"requests":{"cpu":"500m","memory":"256Mi"}}` | The compactor resources. |
| greptimedb-remote-compaction.compactor.serviceAccount | object | `{"annotations":{},"create":true}` | The compactor service account. |
| greptimedb-remote-compaction.compactor.serviceAccount.annotations | object | `{}` | The annotations for compactor service account |
| greptimedb-remote-compaction.compactor.serviceAccount.create | bool | `true` | Create a service account for compactor |
| greptimedb-remote-compaction.compactor.tolerations | list | `[]` | The compactor tolerations. |
| greptimedb-remote-compaction.enabled | bool | `false` | Enable remote compaction. |
| greptimedb-remote-compaction.scheduler.affinity | object | `{}` | The scheduler affinity. |
| greptimedb-remote-compaction.scheduler.args | list | `[]` | The scheduler args. It's used to override the default args. |
| greptimedb-remote-compaction.scheduler.command | list | `[]` | The scheduler command. It's used to override the default command. |
| greptimedb-remote-compaction.scheduler.extraConfigData | string | `"executorManager:\n  removeInactiveExecutorsInterval: \"2s\"\n  expiration: \"5s\"\n"` | The scheduler extra config data. |
| greptimedb-remote-compaction.scheduler.image | object | `{"pullPolicy":"IfNotPresent","pullSecret":[],"registry":"Please set the registry","repository":"Please set the repository","tag":"Please set the tag"}` | The scheduler image. |
| greptimedb-remote-compaction.scheduler.image.pullPolicy | string | `"IfNotPresent"` | The scheduler image pull policy. |
| greptimedb-remote-compaction.scheduler.image.pullSecret | list | `[]` | The scheduler image pull secret. |
| greptimedb-remote-compaction.scheduler.image.registry | string | `"Please set the registry"` | The scheduler image registry. |
| greptimedb-remote-compaction.scheduler.image.repository | string | `"Please set the repository"` | The scheduler image repository. |
| greptimedb-remote-compaction.scheduler.image.tag | string | `"Please set the tag"` | The scheduler image tag. |
| greptimedb-remote-compaction.scheduler.logLevel | string | `"info"` | The scheduler log level. |
| greptimedb-remote-compaction.scheduler.nodeSelector | object | `{}` | The scheduler node selector. |
| greptimedb-remote-compaction.scheduler.podAnnotations | object | `{}` | The scheduler pod annotations. |
| greptimedb-remote-compaction.scheduler.podLabels | object | `{}` | The scheduler pod labels. |
| greptimedb-remote-compaction.scheduler.replicas | int | `1` | The scheduler replicas. |
| greptimedb-remote-compaction.scheduler.resources | object | `{"limits":{"cpu":"4","memory":"8Gi"},"requests":{"cpu":"500m","memory":"256Mi"}}` | The scheduler resources. |
| greptimedb-remote-compaction.scheduler.serviceAccount | object | `{"annotations":{},"create":true}` | The scheduler service account. |
| greptimedb-remote-compaction.scheduler.serviceAccount.annotations | object | `{}` | The annotations for scheduler service account |
| greptimedb-remote-compaction.scheduler.serviceAccount.create | bool | `true` | Create a service account for scheduler |
| greptimedb-remote-compaction.scheduler.servicePort | int | `10099` | The scheduler service port. |
| greptimedb-remote-compaction.scheduler.tolerations | list | `[]` | The scheduler tolerations. |
| grpcServicePort | int | `4001` | GreptimeDB grpc service port |
| httpServicePort | int | `4000` | GreptimeDB http service port |
| image.pullSecrets | list | `[]` | The image pull secrets |
| image.registry | string | `"docker.io"` | The image registry |
| image.repository | string | `"greptime/greptimedb"` | The image repository |
| image.tag | string | `"v1.0.0-beta.1"` | The image tag |
| ingress | object | `{}` | Configure to frontend ingress |
| initializer.registry | string | `"docker.io"` | Initializer image registry |
| initializer.repository | string | `"greptime/greptimedb-initializer"` | Initializer image repository |
| initializer.tag | string | `"v0.5.3"` | Initializer image tag |
| jaeger-all-in-one.enableHttpOpenTelemetryCollector | bool | `true` | Enable the opentelemetry collector for jaeger-all-in-one and listen on port 4317. |
| jaeger-all-in-one.enableHttpZipkinCollector | bool | `true` | Enable the zipkin collector for jaeger-all-in-one and listen on port 9411. |
| jaeger-all-in-one.enabled | bool | `false` | Enable jaeger-all-in-one deployment. |
| jaeger-all-in-one.image | object | `{"pullPolicy":"IfNotPresent","repository":"jaegertracing/all-in-one","versionOverride":"latest"}` | The jaeger-all-in-one image configuration. |
| jaeger-all-in-one.image.pullPolicy | string | `"IfNotPresent"` | The jaeger-all-in-one image pull policy. |
| jaeger-all-in-one.image.repository | string | `"jaegertracing/all-in-one"` | The jaeger-all-in-one image repository. |
| jaeger-all-in-one.image.versionOverride | string | `"latest"` | The jaeger-all-in-one image tag. |
| jaeger-all-in-one.resources | object | `{}` | The resources configurations for the jaeger-all-in-one. |
| jaeger-all-in-one.service | object | `{"annotations":{},"port":16686,"type":"ClusterIP"}` | The jaeger-all-in-one service configuration. |
| jaeger-all-in-one.service.annotations | object | `{}` | The annotations for the service. |
| jaeger-all-in-one.service.port | int | `16686` | The service port. |
| jaeger-all-in-one.service.type | string | `"ClusterIP"` | The type of the service. |
| jaeger-all-in-one.volume | object | `{"className":"","enabled":true,"size":"3Gi"}` | The jaeger-all-in-one persistence configuration. |
| jaeger-all-in-one.volume.className | string | `""` | The storageclass for the jaeger-all-in-one. |
| jaeger-all-in-one.volume.enabled | bool | `true` | Whether to enable the persistence for jaeger-all-in-one. |
| jaeger-all-in-one.volume.size | string | `"3Gi"` | The storage size for the jaeger-all-in-one. |
| license.data | string | `""` | The license data. You can use `--set-file license.data=./license.txt` to set the license data. |
| license.enabled | bool | `false` | Enable enterprise features. |
| license.existingSecretName | string | `""` | The existing secret name to get the license. |
| license.mountFileName | string | `"current"` | The license file name. |
| license.mountPath | string | `"/etc/greptimedb/license"` | The license file path to store the license info. |
| license.secretName | string | `""` | The secret name to store the license. If not set, it will use the ${release-name}-license. |
| logging | object | `{"filters":[],"format":"text","level":"info","logsDir":"/data/greptimedb/logs","onlyLogToStdout":false,"persistentWithData":false}` | Global logging configuration |
| logging.filters | list | `[]` | The log filters, use the syntax of `target[span\{field=value\}]=level` to filter the logs. |
| logging.format | string | `"text"` | The log format for greptimedb, only support "json" and "text" |
| logging.level | string | `"info"` | The log level for greptimedb, only support "debug", "info", "warn", "debug" |
| logging.logsDir | string | `"/data/greptimedb/logs"` | The logs directory for greptimedb |
| logging.onlyLogToStdout | bool | `false` | Whether to log to stdout only |
| logging.persistentWithData | bool | `false` | indicates whether to persist the log with the datanode data storage. It **ONLY** works for the datanode component. |
| meta | object | `{"backendStorage":{"etcd":{},"mysql":{},"postgresql":{}},"configData":"","configFile":"","enableRegionFailover":false,"logging":{},"podTemplate":{"affinity":{},"annotations":{},"labels":{},"main":{"args":[],"command":[],"env":[],"extraArgs":[],"image":"","livenessProbe":{},"readinessProbe":{},"resources":{},"securityContext":{},"startupProbe":{},"volumeMounts":[]},"nodeSelector":{},"securityContext":{},"serviceAccount":{"annotations":{},"create":false},"tolerations":[],"volumes":[]},"replicas":1,"tracing":{"enabled":false,"endpoint":"http://mycluster-monitor-standalone.default:4000/v1/otlp/v1/traces","sampleRatio":"1.0"}}` | Meta configure |
| meta.backendStorage | object | `{"etcd":{},"mysql":{},"postgresql":{}}` | Meta Backend storage configuration |
| meta.backendStorage.etcd | object | `{}` | Etcd backend storage configuration |
| meta.backendStorage.mysql | object | `{}` | MySQL backend storage configuration |
| meta.backendStorage.postgresql | object | `{}` | PostgreSQL backend storage configuration |
| meta.configData | string | `""` | Extra raw toml config data of meta. Skip if the `configFile` is used. |
| meta.configFile | string | `""` | Extra toml file of meta. |
| meta.enableRegionFailover | bool | `false` | Whether to enable region failover |
| meta.logging | object | `{}` | Logging configuration for meta, if not set, it will use the global logging configuration. |
| meta.podTemplate | object | `{"affinity":{},"annotations":{},"labels":{},"main":{"args":[],"command":[],"env":[],"extraArgs":[],"image":"","livenessProbe":{},"readinessProbe":{},"resources":{},"securityContext":{},"startupProbe":{},"volumeMounts":[]},"nodeSelector":{},"securityContext":{},"serviceAccount":{"annotations":{},"create":false},"tolerations":[],"volumes":[]}` | The pod template for meta |
| meta.podTemplate.affinity | object | `{}` | The pod affinity |
| meta.podTemplate.annotations | object | `{}` | The annotations to be created to the pod. |
| meta.podTemplate.labels | object | `{}` | The labels to be created to the pod. |
| meta.podTemplate.main | object | `{"args":[],"command":[],"env":[],"extraArgs":[],"image":"","livenessProbe":{},"readinessProbe":{},"resources":{},"securityContext":{},"startupProbe":{},"volumeMounts":[]}` | The spec of main container |
| meta.podTemplate.main.args | list | `[]` | The arguments to be passed to the command |
| meta.podTemplate.main.command | list | `[]` | The command to be executed in the container |
| meta.podTemplate.main.env | list | `[]` | The environment variables for the container |
| meta.podTemplate.main.extraArgs | list | `[]` | The ExtraArgs specifies additional command-line arguments for the container entrypoint |
| meta.podTemplate.main.image | string | `""` | The meta image. |
| meta.podTemplate.main.livenessProbe | object | `{}` | The config for liveness probe of the main container |
| meta.podTemplate.main.readinessProbe | object | `{}` | The config for readiness probe of the main container |
| meta.podTemplate.main.securityContext | object | `{}` | The configurations for meta security context. |
| meta.podTemplate.main.startupProbe | object | `{}` | The config for startup probe of the main container |
| meta.podTemplate.main.volumeMounts | list | `[]` | The pod volumeMounts |
| meta.podTemplate.nodeSelector | object | `{}` | The pod node selector |
| meta.podTemplate.securityContext | object | `{}` | The configurations for meta security context. |
| meta.podTemplate.serviceAccount.annotations | object | `{}` | The annotations for meta serviceaccount |
| meta.podTemplate.serviceAccount.create | bool | `false` | Create a service account |
| meta.podTemplate.tolerations | list | `[]` | The pod tolerations |
| meta.podTemplate.volumes | list | `[]` | The pod volumes |
| meta.replicas | int | `1` | Meta replicas |
| meta.tracing | object | `{"enabled":false,"endpoint":"http://mycluster-monitor-standalone.default:4000/v1/otlp/v1/traces","sampleRatio":"1.0"}` | Tracing configuration for meta, if not set, it will use the global logging configuration. |
| meta.tracing.enabled | bool | `false` | Enable tracing. |
| meta.tracing.endpoint | string | `"http://mycluster-monitor-standalone.default:4000/v1/otlp/v1/traces"` | The OTLP tracing endpoint. |
| meta.tracing.sampleRatio | string | `"1.0"` | SampleRatio is the percentage of tracing will be sampled and exported. Valid range `[0, 1]`, 1 means all traces are sampled, 0 means all traces are not sampled, the default value is 1. |
| monitoring | object | `{"enabled":false,"logsCollection":{"pipeline":{"data":""}},"standalone":{},"vector":{"registry":"docker.io","repository":"timberio/vector","resources":{"limits":{"cpu":"500m","memory":"256Mi"},"requests":{"cpu":"500m","memory":"256Mi"}},"tag":"0.46.1-debian"}}` | The monitoring bootstrap configuration |
| monitoring.enabled | bool | `false` | Enable monitoring |
| monitoring.logsCollection | object | `{"pipeline":{"data":""}}` | Configure the logs collection |
| monitoring.logsCollection.pipeline | object | `{"data":""}` | The greptimedb pipeline for logs collection |
| monitoring.standalone | object | `{}` | Configure the standalone instance for storing monitoring data |
| monitoring.vector | object | `{"registry":"docker.io","repository":"timberio/vector","resources":{"limits":{"cpu":"500m","memory":"256Mi"},"requests":{"cpu":"500m","memory":"256Mi"}},"tag":"0.46.1-debian"}` | Configure vector for logs and metrics collection. |
| monitoring.vector.registry | string | `"docker.io"` | vector image registry |
| monitoring.vector.repository | string | `"timberio/vector"` | vector image repository |
| monitoring.vector.resources | object | `{"limits":{"cpu":"500m","memory":"256Mi"},"requests":{"cpu":"500m","memory":"256Mi"}}` | vector resource |
| monitoring.vector.tag | string | `"0.46.1-debian"` | vector image tag |
| mysqlServicePort | int | `4002` | GreptimeDB mysql service port |
| objectStorage | object | `{"azblob":{},"cache":{},"gcs":{},"oss":{},"s3":{}}` | Configure to object storage |
| postgresServicePort | int | `4003` | GreptimeDB postgres service port |
| preCheck | object | `{"case":{"disk":{"enabled":false,"size":"20Gi","storageClass":null},"kafka":{"enabled":false,"endpoint":"your-kafka-endpoint"},"s3":{"accessKeyID":"your-access-key-id","bucket":"bucket-name","enabled":false,"region":"s3-region","secretAccessKey":"your-secret-access-key"}},"enabled":false,"env":{},"image":{"registry":"docker.io","repository":"greptime/greptime-tool","tag":"20250421-94c4b8d"}}` | Configure to the pre-check runner |
| preCheck.enabled | bool | `false` | Enable the pre-check runner |
| preCheck.env | object | `{}` | Environment variables |
| preCheck.image | object | `{"registry":"docker.io","repository":"greptime/greptime-tool","tag":"20250421-94c4b8d"}` | The pre-check runner image |
| prometheusMonitor | object | `{"enabled":false,"interval":"30s","labels":{"release":"prometheus"}}` | Configure to prometheus PodMonitor |
| prometheusMonitor.enabled | bool | `false` | Create PodMonitor resource for scraping metrics using PrometheusOperator |
| prometheusMonitor.interval | string | `"30s"` | Interval at which metrics should be scraped |
| prometheusMonitor.labels | object | `{"release":"prometheus"}` | Add labels to the PodMonitor |
| prometheusRule | object | `{"annotations":{},"enabled":false,"labels":{},"namespace":"","rules":[]}` | Configure to PrometheusRule |
| prometheusRule.annotations | object | `{}` | Additional annotations for the rules PrometheusRule resource |
| prometheusRule.enabled | bool | `false` | If enabled, create PrometheusRule resource |
| prometheusRule.labels | object | `{}` | Additional labels for the rules PrometheusRule resource |
| prometheusRule.namespace | string | `""` | The namespace of prometheus rules |
| prometheusRule.rules | list | `[]` | The prometheus rules |
| remoteWal | object | `{"enabled":false,"kafka":{"brokerEndpoints":[]}}` | Configure to remote wal |
| remoteWal.enabled | bool | `false` | Enable remote wal |
| remoteWal.kafka | object | `{"brokerEndpoints":[]}` | The remote wal type, only support kafka now. |
| remoteWal.kafka.brokerEndpoints | list | `[]` | The kafka broker endpoints |
| slowQuery | object | `{"enabled":true,"recordType":"system_table","sampleRatio":"1.0","threshold":"30s","ttl":"30d"}` | The slow query log configuration. |
| slowQuery.enabled | bool | `true` | Enable slow query log. |
| slowQuery.recordType | string | `"system_table"` | The record type of slow query log. |
| slowQuery.sampleRatio | string | `"1.0"` | Sample ratio of slow query log. |
| slowQuery.threshold | string | `"30s"` | The threshold of slow query log in seconds. |
| slowQuery.ttl | string | `"30d"` | The TTL of slow query system table. |
| tracing | object | `{"enabled":false,"endpoint":"http://mycluster-monitor-standalone.default:4000/v1/otlp/v1/traces","sampleRatio":"1.0"}` | Global tracing configuration |
| tracing.enabled | bool | `false` | Enable tracing. |
| tracing.endpoint | string | `"http://mycluster-monitor-standalone.default:4000/v1/otlp/v1/traces"` | The OTLP tracing endpoint. |
| tracing.sampleRatio | string | `"1.0"` | SampleRatio is the percentage of tracing will be sampled and exported. Valid range `[0, 1]`, 1 means all traces are sampled, 0 means all traces are not sampled, the default value is 1. |
