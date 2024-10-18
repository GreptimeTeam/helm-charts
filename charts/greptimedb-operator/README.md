# greptimedb-operator

The greptimedb-operator Helm chart for Kubernetes.

![Version: 0.2.7](https://img.shields.io/badge/Version-0.2.7-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.2](https://img.shields.io/badge/AppVersion-0.1.2-informational?style=flat-square)

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

## How to Uninstall

```console
helm uninstall greptimedb-operator -n greptimedb-admin
```

## CRDs Management

### Installation and Upgrade of the CRDs

Helm cannot upgrade custom resource definitions in the `<chart>/crds` folder [by design](https://helm.sh/docs/chart_best_practices/custom_resource_definitions/#some-caveats-and-explanations).

For deployment convenience, we have decided to manage the CRDs using the Helm chart since **v0.2.1**. By default, the chart will automatically install or upgrade the CRDs. You can disable the behavior by using `--set crds.install=false` when installing the chart. When you uninstall the release, **it will not delete the CRDs by default** unless you use `--set crds.keep=false`.

If you installed the CRD using a chart version before v0.2.1 and  want to let the chart manage CRDs, you can add some necessary metadata for the original CRDs:

```console
# Add the following labels to the CRDs.
kubectl patch crds greptimedbclusters.greptime.io -p '{"metadata":{"labels":{"app.kubernetes.io/managed-by":"Helm"}}}'
kubectl patch crds greptimedbstandalones.greptime.io -p '{"metadata":{"labels":{"app.kubernetes.io/managed-by":"Helm"}}}'

# Add the following annotations to the CRDs. The values of the annotations are the name and namespace of the release.
kubectl patch crds greptimedbclusters.greptime.io -p '{"metadata":{"annotations":{"meta.helm.sh/release-name":<your-release-name>, "meta.helm.sh/release-namespace":<your-namespace>>}}}'
kubectl patch crds greptimedbstandalones.greptime.io -p '{"metadata":{"annotations":{"meta.helm.sh/release-name":<your-release-name>, "meta.helm.sh/release-namespace":<your-namespace>>}}}'
```

If you want to upgrade CRDs manually, you can use the following steps (**ensure the version of the operator and CRDs are aligned**):

- If your `helm-charts` repository is already up-to-date, you can upgrade the CRDs by the following command:

  ```console
  make upgrade-crds
  ```

- If you want to upgrade the CRDs to the latest released version:

  ```console
  make upgrade-crds CRDS_VERSION=latest
  ```

### How to Update the CRDs in the Chart

If you want to update the CRDs in the chart, you can use the following steps:

1. Update the `appVersion` in the `Chart.yaml` file.

2. Execute the following command:

   ```console
   make update-crds
   ```

## Requirements

Kubernetes: `>=1.18.0-0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | The pod affinity |
| apiServer | object | `{"enabled":false,"port":8081}` | The configuration for the operator API server |
| apiServer.enabled | bool | `false` | Whether to enable the API server |
| apiServer.port | int | `8081` | The port for the API server |
| crds.additionalLabels | object | `{}` | Addtional labels to be added to all CRDs |
| crds.annotations | object | `{}` | Annotations to be added to all CRDs |
| crds.install | bool | `true` | Install and upgrade CRDs |
| crds.keep | bool | `true` | Keep CRDs on chart uninstall |
| fullnameOverride | string | `""` | Provide a name to substitute for the full names of resources |
| image.imagePullPolicy | string | `"IfNotPresent"` | The image pull policy for the controller |
| image.pullSecrets | list | `[]` | The image pull secrets |
| image.registry | string | `"docker.io"` | The image registry |
| image.repository | string | `"greptime/greptimedb-operator"` | The image repository |
| image.tag | string | `"v0.1.1"` | The image tag |
| nameOverride | string | `""` | String to partially override release template name |
| nodeSelector | object | `{}` | The operator node selector |
| rbac.create | bool | `true` | Install role based access control |
| replicas | int | `1` | Number of replicas for the greptimedb operator |
| resources | object | `{"limits":{"cpu":"200m","memory":"256Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | Default resources for greptimedb operator |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | The pod tolerations |
