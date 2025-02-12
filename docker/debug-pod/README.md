# Debug Pod

This docker image is designed for debugging purposes and includes a variety of useful tools(such as `mysql-client` and `kubectl`, etc.).

## Building the Image

The debug pod is constructed using the Dockerfile located in [here](./Dockerfile).

## Features

- **Tools Included**:
    - `mysql-client`
    - `postgresql-client`
    - `kubectl`
    - `etcdctl`
    - `AWS CLI`
    - `AliCloud CLI`
    - `Google Cloud CLI`

## Enabling the Debug Pod

To enable the debug pod, set the configuration option `greptimedb-cluster.debugPod.enabled` to `true`. This will allow you to access the debug pod for troubleshooting and debugging tasks.

## Accessing the Debug Pod

Once the debug pod is enabled, you can access it using the following command:

```bash
kubectl exec -it $(kubectl get pods -l app={{ .Release.Name }}-debug-pod -o jsonpath='{.items[0].metadata.name}') -- /bin/bash
```

This command will open an interactive shell inside the debug pod, allowing you to run various commands and tools for debugging.

## Example Deployment YAML

You can deploy the debug pod using the following YAML configuration:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: debug
  namespace: default
  labels:
    app: debug
spec:
  replicas: 1
  selector:
    matchLabels:
      app: debug
  template:
    metadata:
      labels:
        app: debug
    spec:
      containers:
        - image: greptime/greptime-tool:${tag} # Replace ${tag} with the desired image tag, which you can find here: https://hub.docker.com/repository/docker/greptime/greptime-tool/tags
          name: debug
```
