# Overview

Helm chart for [GreptimeDB](https://github.com/GreptimeTeam/greptimedb) standalone mode.

## How to install

```console
# Add charts repo.
helm repo add greptime https://greptimeteam.github.io/helm-charts/
helm repo update

# Install greptimedb standalone in default namespace.
helm install greptimedb-standalone greptime/greptimedb-standalone -n default --devel
```

## How to uninstall

```console
helm uninstall greptimedb-standalone -n default
```

## Parameters

### Common parameters
| Name                            | Description                                                         | Value                 |
|---------------------------------|---------------------------------------------------------------------|-----------------------|
| `nameOverride`                  | String to partially override release template name                  | `""`                  |
| `fullnameOverride`              | String to fully override release template name                      | `""`                  |      
| `image.registry`                | Image registry                                                      | `docker.io`           |
| `image.repository`              | Image name                                                          | `greptime/greptimedb` |
| `image.tag`                     | Image tag                                                           | `v0.4.1`              |
| `image.pullPolicy`              | Image pull policy                                                   | `IfNotPresent`        |
| `image.pullSecrets`             | Docker registry secret names as an array                            | `[]`                  |
| `resources.limits`              | The resources limits for the container                              | `{}`                  |
| `resources.requests`            | The requested resources for the container                           | `{}`                  |
| `serviceAccount.create`         | Create service account                                              | `true`                |
| `serviceAccount.annotations`    | Service account annotations                                         | `{}`                  |
| `serviceAccount.name`           | Service account name                                                | `""`                  |
| `command`                       | Container command                                                   | `[]`                  |
| `args`                          | Container args                                                      | `[]`                  |
| `env`                           | Environment variables                                               | `[]`                  |
| `envFrom`                       | Maps all the keys on a configmap or secret as environment variables | `{}`                  |
| `podAnnotations`                | Extra pod annotations to add                                        | `{}`                  |
| `podLabels`                     | Extra pod labels to add                                             | `{}`                  |
| `podSecurityContext`            | Security context to apply to the pod                                | `{}`                  |
| `annotations`                   | Container args                                                      | `{}`                  |
| `securityContext`               | Security context to apply to the container                          | `{}`                  |
| `nodeSelector`                  | NodeSelector to apply pod                                           | `{}`                  |
| `tolerations`                   | Tolerations to apply pod                                            | `{}`                  |
| `affinity`                      | Affinity configuration for pod                                      | `{}`                  |
| `dnsConfig`                     | DNS configuration for pod                                           | `{}`                  |
| `terminationGracePeriodSeconds` | Amount of time given to the pod to shutdown normally                | `30`                  |
| `httpPort`                      | GreptimeDB http port                                                | `4000`                |
| `grpcPort`                      | GreptimeDB grpc port                                                | `4001`                |
| `mysqlPort`                     | GreptimeDB mysql port                                               | `4002`                |
| `postgresPort`                  | GreptimeDB postgres port                                            | `4003`                |
| `service.type`                  | Service type                                                        | `ClusterIP`           |
| `service.annotations`           | Service annotations                                                 | `{}`                  |

### Volume parameters

| Name                                         | Description                                                                      | Value   |
|----------------------------------------------|----------------------------------------------------------------------------------|---------|
| `persistence.enabled`                        | Create persistent volume claim                                                   | `true`  |
| `persistence.enableStatefulSetAutoDeletePVC` | Whether to enable automatic deletion of stale PVCs due to a scale down operation | `false` |
| `persistence.size`                           | PVC storage Request for data volume                                              | `10Gi`  |
| `persistence.storageClass`                   | Persistent volume storage class                                                  | `null`  |
| `persistence.selector`                       | Selector to match an existing persistent volume                                  | `null`  |

### Metrics parameters
| Name                          | Description                     | Value   |
|-------------------------------|---------------------------------|---------|
| `monitoring.enabled`          | Enable prometheus podmonitor    | `false` |
| `monitoring.annotations`      | HTTP path to scrape for metrics | `{}`    |
| `monitoring.labels`           | Prometheus podmonitor labels    | `{}`    |
| `monitoring.interval`         | Scraped interval                | `30s`   |
