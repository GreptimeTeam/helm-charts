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

| Name                         | Description                               | Value                 |
|------------------------------|-------------------------------------------|-----------------------|
| `image.registry`             | GreptimeDB image registry                 | `docker.io`           |
| `image.repository`           | GreptimeDB image name                     | `greptime/greptimedb` |
| `image.tag`                  | GreptimeDB image tag                      | `v0.4.1`              |
| `image.pullPolicy`           | GreptimeDB image pull policy              | `IfNotPresent`        |
| `image.pullSecrets`          | Docker registry secret names as an array  | `[]`                  |
| `resources.limits`           | The resources limits for the container    | `{}`                  |
| `resources.requests`         | The requested resources for the container | `{}`                  |
| `serviceAccount.create`      | Create greptimedb service account         | `true`                |
| `serviceAccount.annotations` | GreptimeDB service account annotations    | `{}`                  |
| `serviceAccount.name`        | GreptimeDB service account name           | `""`                  |
|                              |                                           |                       |
|                              |                                           |                       |
|                              |                                           |                       |
|                              |                                           |                       |
|                              |                                           |                       |

### Volume parameters


### Metrics parameters

| Name                          | Description                     | Value   |
|-------------------------------|---------------------------------|---------|
| `monitoring.enabled`          | Enable prometheus podmonitor    | `false` |
| `monitoring.annotations`      | HTTP path to scrape for metrics | `{}`    |
| `monitoring.labels`           | Prometheus podmonitor labels    | `{}`    |
| `monitoring.interval`         | Scraped interval                | `30s`   |
