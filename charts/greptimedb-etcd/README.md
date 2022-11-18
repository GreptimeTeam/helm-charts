# Overview

This chart bootstraps an etcd cluster on [Kubernetes](http://kubernetes.io) cluster that using for [GreptimDB](../greptimedb/README.md).

**Note**: This chart is not production ready, only for testing purpose now.

## How to install

```console
# Add charts repo.
helm repo add greptime https://greptimeteam.github.io/helm-charts/
helm repo update

# Deploy greptimedb-etcd in default namespace.
helm install gt greptime/greptimedb-etcd -n default --devel
```

You can use the following commands to access etcd cluster:

```console
# Create the diagnostic pod.
kubectl run etcd-client --image greptime/etcd:v3.5.5 --command sleep infinity

# List the members of etcd cluster.
kubectl exec etcd-client -- etcdctl --endpoints=gt-etcd-svc.default:2379 member list

# Get etcd endpoints status.
kubectl exec etcd-client -- etcdctl --endpoints=gt-etcd-0.gt-etcd-svc:2379,gt-etcd-1.gt-etcd-svc:2379,gt-etcd-2.gt-etcd-svc:2379 endpoint status -w table
```

## How to uninstall

```console
helm uninstall gt
```
