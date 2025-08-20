# greptimedb-remote-compaction

Remote compaction components (scheduler, compactor) for GreptimeDB Enterprise.

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

## Overview

This chart is used to deploy the remote compaction components (remote-job-scheduler and compactor) for [GreptimeDB Enterprise](https://greptime.com/product/enterprise).

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| compactor | object | `{"affinity":{},"args":[],"command":[],"extraConfigData":"# The storage options.\n[storage]\n# The object store type.\ntype = \"S3\"\n# The bucket of the object store.\nbucket = \"testbucket\"\n# The root of the object store.\nroot = \"testroot\"\n# The endpoint of the object store.\nendpoint = \"http://localhost:9000\"\n# The access key of the object store.\naccess_key_id = \"testkey\"\n# The secret key of the object store.\nsecret_access_key = \"testsecret\"\n# The region of the object store.\nregion = \"us-east-1\"\n\n# The logging options.\n[logging]\n# The directory of the log files.\ndir = \"\"\n# The level of the log.\nlevel = \"info\"\n# The format of the log.\nformat = \"text\"\n","heartbeatInterval":"5s","image":{"pullPolicy":"IfNotPresent","pullSecret":"","registry":"Please set the registry","repository":"Please set the repository","tag":"Please set the tag"},"maxBackgroundJobs":4,"nodeSelector":{},"podAnnotations":{},"podLabels":{},"replicas":1,"resources":{"limits":{"cpu":"4","memory":"8Gi"},"requests":{"cpu":"500m","memory":"256Mi"}},"serviceAccount":{"annotations":{},"create":true},"tolerations":[]}` | The compactor configuration. |
| compactor.affinity | object | `{}` | The compactor affinity. |
| compactor.args | list | `[]` | The compactor args. It's used to override the default args. |
| compactor.command | list | `[]` | The compactor command. It's used to override the default command. |
| compactor.extraConfigData | string | `"# The storage options.\n[storage]\n# The object store type.\ntype = \"S3\"\n# The bucket of the object store.\nbucket = \"testbucket\"\n# The root of the object store.\nroot = \"testroot\"\n# The endpoint of the object store.\nendpoint = \"http://localhost:9000\"\n# The access key of the object store.\naccess_key_id = \"testkey\"\n# The secret key of the object store.\nsecret_access_key = \"testsecret\"\n# The region of the object store.\nregion = \"us-east-1\"\n\n# The logging options.\n[logging]\n# The directory of the log files.\ndir = \"\"\n# The level of the log.\nlevel = \"info\"\n# The format of the log.\nformat = \"text\"\n"` | The compactor config data. |
| compactor.heartbeatInterval | string | `"5s"` | The compactor heartbeat interval. |
| compactor.image | object | `{"pullPolicy":"IfNotPresent","pullSecret":"","registry":"Please set the registry","repository":"Please set the repository","tag":"Please set the tag"}` | The compactor image. |
| compactor.image.pullPolicy | string | `"IfNotPresent"` | The compactor image pull policy. |
| compactor.image.pullSecret | string | `""` | The compactor image pull secret. |
| compactor.image.registry | string | `"Please set the registry"` | The compactor image registry. |
| compactor.image.repository | string | `"Please set the repository"` | The compactor image repository. |
| compactor.image.tag | string | `"Please set the tag"` | The compactor image tag. |
| compactor.maxBackgroundJobs | int | `4` | The compactor max background jobs. |
| compactor.nodeSelector | object | `{}` | The compactor node selector. |
| compactor.podAnnotations | object | `{}` | The compactor pod annotations. |
| compactor.podLabels | object | `{}` | The compactor pod labels. |
| compactor.replicas | int | `1` | The compactor replicas. |
| compactor.resources | object | `{"limits":{"cpu":"4","memory":"8Gi"},"requests":{"cpu":"500m","memory":"256Mi"}}` | The compactor resources. |
| compactor.serviceAccount | object | `{"annotations":{},"create":true}` | The compactor service account. |
| compactor.serviceAccount.annotations | object | `{}` | The annotations for compactor service account |
| compactor.serviceAccount.create | bool | `true` | Create a service account for compactor |
| compactor.tolerations | list | `[]` | The compactor tolerations. |
| scheduler.affinity | object | `{}` | The scheduler affinity. |
| scheduler.args | list | `[]` | The scheduler args. It's used to override the default args. |
| scheduler.command | list | `[]` | The scheduler command. It's used to override the default command. |
| scheduler.extraConfigData | string | `"executorManager:\n  removeInactiveExecutorsInterval: \"2s\"\n  expiration: \"5s\"\n"` | The scheduler extra config data. |
| scheduler.image | object | `{"pullPolicy":"IfNotPresent","pullSecret":"","registry":"Please set the registry","repository":"Please set the repository","tag":"Please set the tag"}` | The scheduler image. |
| scheduler.image.pullPolicy | string | `"IfNotPresent"` | The scheduler image pull policy. |
| scheduler.image.pullSecret | string | `""` | The scheduler image pull secret. |
| scheduler.image.registry | string | `"Please set the registry"` | The scheduler image registry. |
| scheduler.image.repository | string | `"Please set the repository"` | The scheduler image repository. |
| scheduler.image.tag | string | `"Please set the tag"` | The scheduler image tag. |
| scheduler.logLevel | string | `"info"` | The scheduler log level. |
| scheduler.nodeSelector | object | `{}` | The scheduler node selector. |
| scheduler.podAnnotations | object | `{}` | The scheduler pod annotations. |
| scheduler.podLabels | object | `{}` | The scheduler pod labels. |
| scheduler.replicas | int | `1` | The scheduler replicas. |
| scheduler.resources | object | `{"limits":{"cpu":"4","memory":"8Gi"},"requests":{"cpu":"500m","memory":"256Mi"}}` | The scheduler resources. |
| scheduler.serviceAccount | object | `{"annotations":{},"create":true}` | The scheduler service account. |
| scheduler.serviceAccount.annotations | object | `{}` | The annotations for scheduler service account |
| scheduler.serviceAccount.create | bool | `true` | Create a service account for scheduler |
| scheduler.servicePort | int | `10099` | The scheduler service port. |
| scheduler.tolerations | list | `[]` | The scheduler tolerations. |
