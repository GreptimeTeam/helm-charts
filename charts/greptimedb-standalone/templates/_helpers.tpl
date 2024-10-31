{{/*
Expand the name of the chart.
*/}}
{{- define "greptimedb-standalone.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "greptimedb-standalone.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "greptimedb-standalone.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "greptimedb-standalone.labels" -}}
helm.sh/chart: {{ include "greptimedb-standalone.chart" . }}
{{ include "greptimedb-standalone.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "greptimedb-standalone.selectorLabels" -}}
app.kubernetes.io/name: {{ include "greptimedb-standalone.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "greptimedb-standalone.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "greptimedb-standalone.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "greptimedb-standalone.objectStorageConfig" -}}
{{- if or .Values.objectStorage.s3 .Values.objectStorage.oss .Values.objectStorage.gcs }}
{{- $provider := "" }}
{{- $bucket := "" }}
{{- $root := "" }}
{{- $cache_path := "" }}

{{- if .Values.objectStorage.s3 }}
  {{- $provider = "S3" }}
  {{- $bucket = .Values.objectStorage.s3.bucket }}
  {{- $root = .Values.objectStorage.s3.root }}
  {{- $cache_path = .Values.objectStorage.s3.cache_path }}
{{- else if .Values.objectStorage.oss }}
  {{- $provider = "Oss" }}
  {{- $bucket = .Values.objectStorage.oss.bucket }}
  {{- $root = .Values.objectStorage.oss.root }}
  {{- $cache_path = .Values.objectStorage.oss.cache_path }}
{{- else if .Values.objectStorage.gcs }}
  {{- $provider = "Gcs" }}
  {{- $bucket = .Values.objectStorage.gcs.bucket }}
  {{- $root = .Values.objectStorage.gcs.root }}
  {{- $cache_path = .Values.objectStorage.gcs.cache_path }}
{{- end }}

{{- if and $provider $bucket }}
[storage]
  # Storage provider type: S3, Oss, or Gcs
  type = "{{ $provider }}"

  # Bucket name in the storage provider
  bucket = "{{ $bucket }}"

  # Root path within the bucket
  root = "{{ $root }}"

  # Cache path configuration
  {{- if $cache_path }}
  cache_path = "{{ $cache_path }}"
  {{- end }}

{{- if .Values.objectStorage.s3 }}
  endpoint = "{{ .Values.objectStorage.s3.endpoint }}"
  region = "{{ .Values.objectStorage.s3.region }}"
{{- else if .Values.objectStorage.oss }}
  endpoint = "{{ .Values.objectStorage.oss.endpoint }}"
  region = "{{ .Values.objectStorage.oss.region }}"
{{- else if .Values.objectStorage.gcs }}
  endpoint = "{{ .Values.objectStorage.gcs.endpoint }}"
  scope = "{{ .Values.objectStorage.gcs.scope }}"
{{- end }}
{{- end }}
{{- end }}
{{- end }}
