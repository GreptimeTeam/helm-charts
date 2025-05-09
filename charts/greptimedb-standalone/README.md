# greptimedb-standalone

A Helm chart for deploying standalone greptimedb

![Version: 0.1.52](https://img.shields.io/badge/Version-0.1.52-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.14.3](https://img.shields.io/badge/AppVersion-0.14.3-informational?style=flat-square)

## Source Code
- https://github.com/GreptimeTeam/greptimedb

## How to install

```console
# Add charts repo.
helm repo add greptime https://greptimeteam.github.io/helm-charts/
helm repo update

# Install greptimedb standalone in default namespace.
helm upgrade --install greptimedb-standalone greptime/greptimedb-standalone -n default
```

**Use AWS S3 as backend storage**
```console
helm upgrade --install greptimedb-standalone greptime/greptimedb-standalone \
  --set objectStorage.credentials.accessKeyId="your-access-key-id" \
  --set objectStorage.credentials.secretAccessKey="your-secret-access-key" \
  --set objectStorage.s3.bucket="your-bucket-name" \
  --set objectStorage.s3.region="region-of-bucket" \
  --set objectStorage.s3.endpoint="s3-endpoint" \
  --set objectStorage.s3.root="root-directory-of-data" \
  -n default
```

## Connection

```console
# You can use the MySQL client to connect the greptimedb, for example: 'mysql -h 127.0.0.1 -P 4002'.
kubectl port-forward -n default svc/greptimedb-standalone 4002:4002

# You can use the PostgreSQL client to connect the greptimedb, for example: 'psql -h 127.0.0.1 -p 4003 -d public'.
kubectl port-forward -n default svc/greptimedb-standalone 4003:4003
```

## How to uninstall

```console
helm uninstall greptimedb-standalone -n default
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalLabels | object | `{}` | additional labels to add to all resources |
| affinity | object | `{}` | Affinity configuration for pod |
| annotations | object | `{}` | The annotations |
| args | list | `[]` | The container args |
| auth | object | `{"enabled":false,"fileName":"passwd","mountPath":"/etc/greptimedb/auth","users":[{"password":"admin","username":"admin"}]}` | The static auth for greptimedb, only support one user now(https://docs.greptime.com/user-guide/deployments/authentication/static). |
| auth.enabled | bool | `false` | Enable static auth |
| auth.fileName | string | `"passwd"` | The auth file name, the full path is `${mountPath}/${fileName}` |
| auth.mountPath | string | `"/etc/greptimedb/auth"` | The auth file path to store the auth info |
| auth.users | list | `[{"password":"admin","username":"admin"}]` | The users to be created in the auth file |
| command | list | `[]` | The container command |
| configToml | string | `"mode = 'standalone'\n"` | The extra configuration for greptimedb |
| dataHome | string | `"/data/greptimedb/"` | Storage root directory |
| env | object | `{}` | Environment variables |
| extraVolumeMounts | list | `[]` | Volume mounts to add to the pods |
| extraVolumes | list | `[]` | Volumes to add to the pods |
| fullnameOverride | string | `""` | Provide a name to substitute for the full names of resources |
| grpcServicePort | int | `4001` | GreptimeDB grpc service port |
| httpServicePort | int | `4000` | GreptimeDB http service port |
| image.pullPolicy | string | `"IfNotPresent"` | The image pull policy for the controller |
| image.pullSecrets | list | `[]` | The image pull secrets. |
| image.registry | string | `"docker.io"` | The image registry |
| image.repository | string | `"greptime/greptimedb"` | The image repository |
| image.tag | string | `"v0.14.3"` | The image tag |
| monitoring.annotations | object | `{}` | PodMonitor annotations |
| monitoring.enabled | bool | `false` | Enable prometheus podmonitor |
| monitoring.interval | string | `"30s"` | PodMonitor scrape interval |
| monitoring.labels | object | `{}` | PodMonitor labels |
| mysqlServicePort | int | `4002` | GreptimeDB mysql service port |
| nameOverride | string | `""` | Overrides the chart's name |
| nodeSelector | object | `{}` | NodeSelector to apply pod |
| objectStorage | object | `{"azblob":{},"gcs":{},"oss":{},"s3":{}}` | Configure to object storage |
| persistence.enableStatefulSetAutoDeletePVC | bool | `false` | Enable StatefulSetAutoDeletePVC feature |
| persistence.enabled | bool | `true` | Enable persistent disk |
| persistence.mountPath | string | `"/data/greptimedb"` | Mount path of persistent disk. |
| persistence.selector | string | `nil` | Selector for persistent disk |
| persistence.size | string | `"20Gi"` | Size of persistent disk |
| persistence.storageClass | string | `nil` | Storage class name |
| persistentVolumeClaimRetentionPolicy | object | `{"whenDeleted":"Retain","whenScaled":"Retain"}` | PersistentVolumeClaimRetentionPolicyType is a string enumeration of the policies that will determine, when volumes from the VolumeClaimTemplates will be deleted when the controlling StatefulSet is deleted or scaled down. |
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
