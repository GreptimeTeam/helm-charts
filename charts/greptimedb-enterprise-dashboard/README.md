# greptimedb-enterprise-dashboard

The Helm chart for deploying GreptimeDB Enterprise Dashboard.

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

## Overview

The GreptimeDB Enterprise Dashboard is a web-based dashboard for managing GreptimeDB instances.

## Requirements

Kubernetes: `>=1.18.0-0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| args[0] | string | `"--config=/etc/dashboard-apiserver/config.yaml"` |  |
| config | string | `"servicePort: 19095\nlogLevel: info\nprovisionedInstances:\n- name: mycluster\n  namespace: default\n  type: cluster\n  url: http://mycluster-frontend.default.svc.cluster.local:4000\n  monitoring:\n    greptimedb:\n      url: http://mycluster-monitor-standalone.default.svc.cluster.local:4000\n"` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"Please set the image repository"` |  |
| image.tag | string | `"Please set the image repository"` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.annotations | object | `{}` |  |
| service.port | int | `19095` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| servicePort | int | `19095` |  |
| tolerations | list | `[]` |  |
