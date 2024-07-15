# greptimedb-operator

The greptimedb-operator Helm chart for Kubernetes.

![Version: 0.1.18](https://img.shields.io/badge/Version-0.1.18-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0-alpha.26](https://img.shields.io/badge/AppVersion-0.1.0--alpha.26-informational?style=flat-square)

## Source Code

- https://github.com/GreptimeTeam/greptimedb-operator

## How to Install

### Add Chart Repository

```console
helm repo add greptime https://greptimeteam.github.io/helm-charts/
helm repo update
```

### Install the GreptimeDB Operator

Install greptimedb-operator in the `greptimedb-admin` namespace:

```console
helm upgrade \
  --install \
  --create-namespace \
  greptimedb-operator greptime/greptimedb-operator \
  -n greptimedb-admin
```

If you want to specify the chart version, you can use `--version`:

```console
helm upgrade \
  --install \
  --create-namespace \
  greptimedb-operator greptime/greptimedb-operator \
  -n greptimedb-admin \
  --version <chart-version>
```

## Upgrade CRDs

Helm cannot upgrade custom resource definitions in the `<chart>/crds` folder [by design](https://helm.sh/docs/chart_best_practices/custom_resource_definitions/#some-caveats-and-explanations). When the CRDs are upgraded, you can upgrade CRDs by using `kubectl` manually:

```console
kubectl apply -f https://github.com/GreptimeTeam/greptimedb-operator/releases/download/latest/greptimedbclusters.yaml
kubectl apply -f https://github.com/GreptimeTeam/greptimedb-operator/releases/download/latest/greptimedbstandalones.yaml
```

## How to Uninstall

```console
helm uninstall greptimedb-operator -n greptimedb-admin
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
| image.tag | string | `"0.1.0-alpha.26"` | The image tag |
| nameOverride | string | `""` | String to partially override release template name |
| nodeSelector | object | `{}` | The operator node selector |
| rbac.create | bool | `true` | Install role based access control |
| replicas | int | `1` | Number of replicas for the greptimedb operator |
| resources | object | `{"limits":{"cpu":"200m","memory":"256Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | Default resources for greptimedb operator |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | The pod tolerations |
