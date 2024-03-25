# greptimedb-operator

The greptimedb-operator Helm chart for Kubernetes

![Version: 0.1.13](https://img.shields.io/badge/Version-0.1.13-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0-alpha.23](https://img.shields.io/badge/AppVersion-0.1.0--alpha.23-informational?style=flat-square)

## Source Code
- https://github.com/GreptimeTeam/greptimedb-operator

## How to install

```console
# Add charts repo.
helm repo add greptime https://greptimeteam.github.io/helm-charts/

# Update charts repo.
helm repo update

# Search charts repo.
helm search repo greptime -l --devel

# Deploy greptimedb-operator in default namespace.
helm upgrade --install greptimedb-operator greptime/greptimedb-operator -n default

# Specifiy the chart version.
helm upgrade --install greptimedb-operator greptime/greptimedb-operator -n default --version <chart-version>
```

## How to uninstall

```console
helm uninstall greptimedb-operator -n default
```

## Requirements

Kubernetes: `>=1.18.0-0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | The pod affinity |
| fullnameOverride | string | `""` | Provide a name to substitute for the full names of resources |
| image.imagePullPolicy | string | `"IfNotPresent"` | The image pull policy for the controller |
| image.pullSecrets | list | `[]` | The image pull secrets |
| image.registry | string | `"docker.io"` | The image registry |
| image.repository | string | `"greptime/greptimedb-operator"` | The image repository |
| image.tag | string | `"0.1.0-alpha.23"` | The image tag |
| nameOverride | string | `""` | String to partially override release template name |
| nodeSelector | object | `{}` | The operator node selector |
| rbac.create | bool | `true` | Install role based access control |
| replicas | int | `1` | Number of replicas for the greptimedb operator |
| resources | object | `{"limits":{"cpu":"200m","memory":"256Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | Default resources for greptimedb operator |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | The pod tolerations |
