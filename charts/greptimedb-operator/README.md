# Overview

Helm chart for [greptimedb-operator](https://github.com/GreptimeTeam/greptimedb-operator).

## How to install

```console
# Add charts repo.
helm repo add greptime https://greptimeteam.github.io/helm-charts/

# Update charts repo.
helm repo update

# Search charts repo.
helm search repo greptime -l --devel 

# Deploy greptimedb-operator in default namespace.
helm install greptimedb-operator greptime/greptimedb-operator -n default --devel

# Specifiy the chart version.
helm install greptimedb-operator greptime/greptimedb-operator -n default --version <chart-version>
```

## How to uninstall

```console
helm uninstall greptimedb-operator -n default
```

## Parameters

### Common parameters

| Name                         | Description                                     | Value                          |
|------------------------------|-------------------------------------------------|--------------------------------|
| `image.registry`             | GreptimeDB operator image registry              | `docker.io`                    |
| `image.repository`           | GreptimeDB operator image name                  | `greptime/greptimedb-operator` |
| `image.tag`                  | GreptimeDB operator image tag                   | `0.1.0-alpha.17`               |
| `image.imagePullPolicy`      | GreptimeDB operator image pull policy           | `IfNotPresent`                 |
| `image.pullSecrets`          | Docker registry secret names as an array        | `[]`                           |
| `resources.limits`           | The resources limits for the container          | `{}`                           |
| `resources.requests`         | The requested resources for the container       | `{}`                           |
| `replicas`                   | GreptimeDB operator replicas                    | `1`                            |
| `serviceAccount.create`      | Create greptimedb operator service account      | `true`                         |
| `serviceAccount.annotations` | GreptimeDB operator service account annotations | `{}`                           |
| `serviceAccount.name`        | GreptimeDB operator service account name        | `""`                           |
| `rbac.create`                | Create rbac                                     | `true`                         |
| `nodeSelector`               | GreptimeDB operator node selector               | `{}`                           |

