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
[storage]
type = "{{- if .Values.objectStorage.s3 }}S3{{- else if .Values.objectStorage.oss }}Oss{{- else if .Values.objectStorage.gcs }}Gcs{{- end }}"

bucket = "{{- if .Values.objectStorage.s3 }}{{ .Values.objectStorage.s3.bucket }}{{- else if .Values.objectStorage.oss }}{{ .Values.objectStorage.oss.bucket }}{{- else if .Values.objectStorage.gcs }}{{ .Values.objectStorage.gcs.bucket }}{{- end }}"

root = "{{- if .Values.objectStorage.s3 }}{{ .Values.objectStorage.s3.root }}{{- else if .Values.objectStorage.oss }}{{ .Values.objectStorage.oss.root }}{{- else if .Values.objectStorage.gcs }}{{ .Values.objectStorage.gcs.root }}{{- end }}"

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
