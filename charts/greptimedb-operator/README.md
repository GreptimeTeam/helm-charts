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

| Name                         | Description                                        | Value                           |
|------------------------------|----------------------------------------------------|---------------------------------|
| `nameOverride`               | String to partially override release template name | `""`                            |
| `fullnameOverride`           | String to fully override release template name     | `""`                            | 
| `image.registry`             | Image registry                                     | `docker.io`                     |
| `image.repository`           | Image name                                         | `greptime/greptimedb-operator`  |
| `image.tag`                  | Image tag                                          | `0.1.0-alpha.17`                |
| `image.imagePullPolicy`      | Image pull policy                                  | `IfNotPresent`                  |
| `image.pullSecrets`          | Docker registry secret names as an array           | `[]`                            |
| `resources.limits`           | The resources limits for the container             | `{}`                            |
| `resources.requests`         | The requested resources for the container          | `{}`                            |
| `replicas`                   | The operator replicas                              | `1`                             |
| `serviceAccount.create`      | Create service account                             | `true`                          |
| `serviceAccount.annotations` | Service account annotations                        | `{}`                            |
| `serviceAccount.name`        | Service account name                               | `""`                            |
| `rbac.create`                | Create rbac                                        | `true`                          |
| `nodeSelector`               | The operator node selector                         | `{}`                            |

