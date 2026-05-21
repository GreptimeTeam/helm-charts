# greptimedb-infra-test

The Helm chart for deploying GreptimeDB infra test.

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

## Overview

The GreptimeDB infra test is a testing tool used to verify the performance and connectivity of GreptimeDB underlying infrastructure.

## Requirements

Kubernetes: `>=1.18.0-0`

## How to install
```console
helm upgrade \
  --install greptimedb-infra-test \
  greptime/greptimedb-infra-test \
  -n default
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| case | object | `{"cpu":{"enabled":true},"disk":{"enabled":true,"size":"20Gi","storageClass":null},"kafka":{"enabled":true,"endpoint":"your-kafka-endpoint"},"rds":{"database":"test","enabled":true,"host":"your-rds-host","password":"your-rds-password","port":3306,"username":"your-rds-username"},"s3":{"accessKeyID":"your-access-key-id","bucket":"bucket-name","enabled":true,"region":"s3-region","secretAccessKey":"your-secret-access-key"}}` | Configure to the tests |
| env | object | `{}` | Environment variables |
| fullnameOverride | string | `""` |  |
| image.pullSecrets | list | `[]` | The image pull secrets |
| image.registry | string | `"docker.io"` | The image registry |
| image.repository | string | `"greptime/greptime-tool"` | The image repository |
| image.tag | string | `"20250606-04e3c7d"` | The image tag |
| nameOverride | string | `""` |  |
