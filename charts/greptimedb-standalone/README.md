# greptimedb-standalone

A Helm chart for deploying standalone greptimedb

![Version: 0.1.6](https://img.shields.io/badge/Version-0.1.6-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.4.4](https://img.shields.io/badge/AppVersion-0.4.4-informational?style=flat-square)

## Source Code
- https://github.com/GreptimeTeam/greptimedb

## How to install

```console
# Add charts repo.
helm repo add greptime https://greptimeteam.github.io/helm-charts/
helm repo update

# Install greptimedb standalone in default namespace.
helm install greptimedb-standalone greptime/greptimedb-standalone -n default
```

## How to uninstall

```console
helm uninstall greptimedb-standalone -n default
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity configuration for pod |
| annotations | object | `{}` | The annotations |
| args | list | `[]` | The container args |
| command | list | `[]` | The container command |
| configToml | string | `"mode = 'standalone'\n"` | The extra configuration for greptimedb |
| dataHome | string | `"/data/greptimedb/"` | Storage root directory |
| env | object | `{"GREPTIMEDB_STANDALONE__HTTP__ADDR":"0.0.0.0:4000","GREPTIMEDB_STANDALONE__STORAGE__ACCESS_KEY_ID":"aws_access_key_id","GREPTIMEDB_STANDALONE__STORAGE__BUCKET":"aws_s3_name","GREPTIMEDB_STANDALONE__STORAGE__CACHE__CACHE_PATH":"/data/greptimedb/s3cache","GREPTIMEDB_STANDALONE__STORAGE__REGION":"aws_s3_region","GREPTIMEDB_STANDALONE__STORAGE__ROOT":"/data","GREPTIMEDB_STANDALONE__STORAGE__SECRET_ACCESS_KEY":"aws_secret_access_key","GREPTIMEDB_STANDALONE__STORAGE__TYPE":"S3"}` | Environment variables |
| envFrom | object | `{}` | Maps all the keys on a configmap or secret as environment variables |
| fullnameOverride | string | `""` | Provide a name to substitute for the full names of resources |
| grpcServicePort | int | `4001` | GreptimeDB grpc service port |
| httpServicePort | int | `4000` | GreptimeDB http service port |
| image.pullPolicy | string | `"IfNotPresent"` | The image pull policy for the controller |
| image.pullSecrets | list | `[]` | The image pull secrets. |
| image.registry | string | `"docker.io"` | The image registry |
| image.repository | string | `"greptime/greptimedb"` | The image repository |
| image.tag | string | `"v0.4.4"` | The image tag |
| monitoring.annotations | object | `{}` | PodMonitor annotations |
| monitoring.enabled | bool | `false` | Enable prometheus podmonitor |
| monitoring.interval | string | `"30s"` | PodMonitor scrape interval |
| monitoring.labels | object | `{}` | PodMonitor labels |
| mysqlServicePort | int | `4002` | GreptimeDB mysql service port |
| nameOverride | string | `""` | Overrides the chart's name |
| nodeSelector | object | `{}` | NodeSelector to apply pod |
| opentsdbServicePort | int | `4242` | GreptimeDB opentsdb service port |
| persistence.enableStatefulSetAutoDeletePVC | bool | `false` | Enable StatefulSetAutoDeletePVC feature |
| persistence.enabled | bool | `true` | Enable persistent disk |
| persistence.mountPath | string | `"/data/greptimedb"` | Mount path of persistent disk. |
| persistence.selector | string | `nil` | Selector for persistent disk |
| persistence.size | string | `"10Gi"` | Size of persistent disk |
| persistence.storageClass | string | `nil` | Storage class name |
| podAnnotations | object | `{}` | Extra pod annotations to add |
| podLabels | object | `{}` | Extra pod labels to add |
| podSecurityContext | object | `{}` | Security context to apply to the pod |
| postgresServicePort | int | `4003` | GreptimeDB postgres service port |
| resources | object | `{}` | Resource requests and limits for the container |
| securityContext | object | `{}` | Security context to apply to the container |
| service.annotations | object | `{}` | Annotations for service |
| service.type | string | `"ClusterIP"` | Service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | Service account name |
| terminationGracePeriodSeconds | int | `30` | Grace period to allow the single binary to shut down before it is killed |
| tolerations | object | `{}` | Tolerations to apply pod |
