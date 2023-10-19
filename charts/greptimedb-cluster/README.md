# Overview

Helm chart for [GreptimeDB](https://github.com/GreptimeTeam/greptimedb) cluster.

## How to install

**Note**: Make sure you already install the [greptimedb-operator](../greptimedb-operator/README.md).

```console
# Add charts repo.
helm repo add greptime https://greptimeteam.github.io/helm-charts/
helm repo update

# Optional: Install etcd cluster.
# You also can use your own etcd cluster.
helm install etcd oci://registry-1.docker.io/bitnamicharts/etcd \
    --set replicaCount=3 \
    --set auth.rbac.create=false \
    --set auth.rbac.token.enabled=false \
    -n default

# Install greptimedb in default namespace.
helm install greptimedb-cluster greptime/greptimedb-cluster -n default --devel
```

## How to uninstall

```console
helm uninstall greptimedb-cluster -n default
```

## Parameters

### Common parameters

| Name                               | Description                                                 | Value                             |
|------------------------------------|-------------------------------------------------------------|-----------------------------------|
| `image.registry`                   | GreptimeDB image registry                                   | `docker.io`                       |
| `image.repository`                 | GreptimeDB image name                                       | `greptime/greptimedb`             |
| `image.tag`                        | GreptimeDB image tag                                        | `v0.4.1`                          |
| `image.pullSecrets`                | Docker registry secret names as an array                    | `[]`                              |
| `resources.limits`                 | The resources limits for the container                      | `{}`                              |
| `resources.requests`               | The requested resources for the container                   | `{}`                              |
| `initializer.registry`             | Initializer image registry                                  | `docker.io`                       |
| `initializer.repository`           | Initializer image repository                                | `greptime/greptimedb-initializer` |
| `initializer.tag`                  | Initializer image tag                                       | `0.1.0-alpha.17`                  |
| `httpServicePort`                  | GreptimeDB http port                                        | `4000`                            |
| `grpcServicePort`                  | GreptimeDB grpc port                                        | `4001`                            |
| `mysqlServicePort`                 | GreptimeDB mysql port                                       | `4002`                            |
| `postgresServicePort`              | GreptimeDB postgres port                                    | `4003`                            |
| `openTSDBServicePort`              | GreptimeDB opentsdb port                                    | `4242`                            |


### Frontend parameters

| Name                                                        | Description                              | Value   |
|-------------------------------------------------------------|------------------------------------------|---------|
| `frontend.replicas`                                         | Frontend replicas                        | `1`     |
| `frontend.service`                                          | Frontend service                         | `{}`    |
| `frontend.componentSpec`                                    | Frontend componentSpec                   | `{}`    |
| `frontend.tls.certificates.secretName`                      | Frontend tls certificates secret name    | `""`    |
| `frontend.tls.certificates.secretCreation.enabled`          | Create frontend tls certificates secret  | `true`  |
| `frontend.tls.certificates.secretCreation.enableEncryption` | Encrypt frontend tls certificates secret | `false` |
| `frontend.tls.certificates.secretCreation.data.ca.crt`      | Frontend tls certificates ca.crt         | `""`    |
| `frontend.tls.certificates.secretCreation.data.tls.crt`     | Frontend tls certificates tls.crt        | `""`    |
| `frontend.tls.certificates.secretCreation.data.tls.key`     | Frontend tls certificates tls.key        | `""`    |

### Meta parameters

| Name                 | Description         | Value                                    |
|----------------------|---------------------|------------------------------------------|
| `meta.replicas`      | Meta replicas       | `1`                                      |
| `meta.etcdEndpoints` | Meta etcd endpoints | `etcd.default.svc.cluster.local:2379`    |
| `meta.componentSpec` | Meta componentSpec  | `{}`                                     |

### Datanode parameters

| Name                            | Description                                          | Value    |
|---------------------------------|------------------------------------------------------|----------|
| `datanode.replicas`             | Datanode replicas                                    | `1`      |
| `datanode.componentSpec`        | Datanode componentSpec                               | `{}`     |
| `datanode.storageClassName`     | Storage class for datanode persistent volume         | `null`   |
| `datanode.storageSize`          | Storage size for datanode persistent volume          | `10Gi`   |
| `datanode.storageRetainPolicy`  | Storage retain policy for datanode persistent volume | `Retain` |

### Storage parameters

| Name                                                        | Description                              | Value             |
|-------------------------------------------------------------|------------------------------------------|-------------------|
| `storage.credentials.secretName`                            | Storage credentials secret name          | `credentials`     |
| `storage.credentials.secretCreation.enabled`                | Create frontend tls certificates secret  | `true`            |
| `storage.credentials.secretCreation.enableEncryption`       | Encrypt frontend tls certificates secret | `false`           |
| `storage.credentials.secretCreation.data.access-key-id`     | Storage credentials access key id        | `""`              |
| `storage.credentials.secretCreation.data.secret-access-key` | Storage credentials secret access key    | `""`              |
| `storage.local.directory`                                   | Local storage directory                  | `/tmp/greptimedb` |
| `storage.s3.bucket`                                         | S3 storage bucket name                   | `""`              |
| `storage.s3.region`                                         | S3 storage bucket region                 | `""`              |
| `storage.s3.root`                                           | S3 storage bucket root                   | `""`              |
| `storage.s3.endpoint`                                       | S3 storage bucket endpoint               | `""`              |
| `storage.s3.secretName`                                     | S3 storage credentials secret            | `""`              |
| `storage.oss.bucket`                                        | OSS storage bucket name                  | `""`              |
| `storage.oss.region`                                        | OSS storage bucket region                | `""`              |
| `storage.oss.root`                                          | OSS storage bucket root                  | `""`              |
| `storage.oss.endpoint`                                      | OSS storage bucket endpoint              | `""`              |
| `storage.oss.secretName`                                    | OSS storage bucket credentials secret    | `""`              |

### Metrics parameters

| Name                               | Description                                                 | Value      |
|------------------------------------|-------------------------------------------------------------|------------|
| `prometheusMonitor.enabled`        | Enable prometheus podmonitor                                | `false`    |
| `prometheusMonitor.path`           | HTTP path to scrape for metrics                             | `/metrics` |
| `prometheusMonitor.port`           | Target metrics port                                         | `http`     |
| `prometheusMonitor.interval`       | Scraped interval                                            | `30s`      |
| `prometheusMonitor.honorLabels`    | Chooses the metrics labels on collisions with target labels | `true`     |
| `prometheusMonitor.labelsSelector` | Prometheus podmonitor labels                                | `{}`       |
