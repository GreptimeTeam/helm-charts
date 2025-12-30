# greptimedb-operator

The greptimedb-operator Helm chart for Kubernetes.

![Version: 0.5.6](https://img.shields.io/badge/Version-0.5.6-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.5.3](https://img.shields.io/badge/AppVersion-0.5.3-informational?style=flat-square)

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
| VolumeMounts | list | `[]` | Volume mounts to add to the pod |
| Volumes | list | `[]` | Volumes to add to the pod |
| additionalLabels | object | `{}` | additional labels to add to all resources |
| admissionWebhook | object | `{"annotations":{},"caBundle":"","certDir":"/etc/webhook-tls","certManager":{"admissionCert":{"duration":""},"enabled":false,"rootCert":{"duration":""}},"enabled":false,"failurePolicy":"Fail","port":8082}` | The configuration for the admission webhook |
| admissionWebhook.annotations | object | `{}` | Additional annotations to the admission webhooks |
| admissionWebhook.caBundle | string | `""` | A PEM encoded CA bundle which will be used to validate the webhook's server certificate. If certManager.enabled is true, you can get it like this: kubectl get secret webhook-server-tls -n ${namespace} -o jsonpath='{.data.ca\.crt}' |
| admissionWebhook.certDir | string | `"/etc/webhook-tls"` | The directory that contains the certificate |
| admissionWebhook.certManager | object | `{"admissionCert":{"duration":""},"enabled":false,"rootCert":{"duration":""}}` | Use certmanager to generate webhook certs |
| admissionWebhook.certManager.admissionCert | object | `{"duration":""}` | self-signed webhook certificate |
| admissionWebhook.certManager.rootCert | object | `{"duration":""}` | self-signed root certificate |
| admissionWebhook.enabled | bool | `false` | Whether to enable the admission webhook |
| admissionWebhook.failurePolicy | string | `"Fail"` | Valid values: Fail, Ignore, IgnoreOnInstallOnly |
| admissionWebhook.port | int | `8082` | The port for the admission webhook |
| affinity | object | `{}` | The pod affinity |
| crds.additionalLabels | object | `{}` | Addtional labels to be added to all CRDs |
| crds.annotations | object | `{}` | Annotations to be added to all CRDs |
| crds.install | bool | `true` | Install and upgrade CRDs |
| crds.keep | bool | `true` | Keep CRDs on chart uninstall |
| env | list | `[]` | [Environment variables](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/) for the container. |
| envFrom | list | `[]` | Environment variables from secrets or configmaps to add to the container. |
| extraArgs | list | `[]` | The ExtraArgs specifies additional command-line arguments for the container entrypoint |
| fullnameOverride | string | `""` | Provide a name to substitute for the full names of resources |
| image.imagePullPolicy | string | `"IfNotPresent"` | The image pull policy for the controller |
| image.pullSecrets | list | `[]` | The image pull secrets |
| image.registry | string | `"docker.io"` | The image registry |
| image.repository | string | `"greptime/greptimedb-operator"` | The image repository |
| image.tag | string | `"v0.5.3"` | The image tag |
| leaderElection | object | `{"enabled":true}` | Enable leader election for greptimedb operator. |
| livenessProbe | object | `{"enabled":true,"failureThreshold":5,"initialDelaySeconds":15,"periodSeconds":30,"successThreshold":1,"timeoutSeconds":5}` | Configure options for liveness probe |
| nameOverride | string | `""` | String to partially override release template name |
| nodeSelector | object | `{}` | The operator node selector |
| rbac.create | bool | `true` | Install role based access control |
| readinessProbe | object | `{"enabled":true,"failureThreshold":5,"initialDelaySeconds":5,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5}` | Configure options for readiness probe |
| replicas | int | `1` | Number of replicas for the greptimedb operator |
| resources | object | `{}` | Default resources for greptimedb operator |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| startupProbe | object | `{"enabled":true,"failureThreshold":30,"initialDelaySeconds":0,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5}` | Configure options for startup probe |
| tolerations | list | `[]` | The pod tolerations |
