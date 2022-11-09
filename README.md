# Greptime Helm Charts

## Overview

This is the repository that contains [Greptime](https://greptime.com/) Helm charts.

## Prerequisites

- [Helm v3](https://helm.sh/docs/intro/install/)

## Getting Started

### Add chart repository

You can add the chart repository with the following commands:

```
$ helm repo add gt https://greptimeteam.github.io/helm-charts/
$ helm repo update
```

### Install the greptimedb chart

If you want to deploy GreptimeDB cluster, you can use the following command:

1. Deploy GreptimeDB operator

   ```
   # Deploy greptimedb-operator in new namespace.
   $ helm install gtcloud greptimedb-operator --namespace greptimedb-operator-system --create-namespace
   ```

2. Deploy GreptimeDB cluster

   ```
   $ helm install mydb greptimedb -n default
   ```
   
3. Use kubectl port-forward to access GreptimeDB cluster

   ```
   $ kubectl port-forward svc/mydb-frontend 3306:3306
   ```

You also can list the current releases by `helm` command:

```
$ helm list --all-namespaces
```

If you want to terminate the GreptimeDB cluster, you can use the following command:

```
$ helm uninstall mydb
$ helm uninstall gtcloud -n greptimedb-operator-system
```

The CRDs of GreptimeDB are not deleted [by default](https://helm.sh/docs/topics/charts/#limitations-on-crds). You can delete them by the following command:

```
$ kubectl delete crds greptimedbclusters.greptime.io
```

## List of Charts

- [greptimedb](./charts/greptimedb/README.md)
- [greptimedb-operator](./charts/greptimedb-operator/README.md)
- [etcd](./charts/etcd/README.md)

