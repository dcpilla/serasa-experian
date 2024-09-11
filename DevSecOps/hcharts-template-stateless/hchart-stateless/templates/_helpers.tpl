{{/*
Expand the name of the chart.
*/}}
{{- define "stateless-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "stateless-app.fullname" -}}
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
{{- define "stateless-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "stateless-app.labels" -}}
chart: {{ include "stateless-app.chart" . }}
version: {{ default .Chart.Version .Values.deployment.production.image.tag }}
helm.sh/chart: {{ include "stateless-app.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: {{ include "stateless-app.name" . }}
app.kubernetes.io/version: {{ .Chart.Version }}
{{ include "stateless-app.selectorLabels" . }}
{{- toYaml .Values.app.labels | nindent 0 }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "stateless-app.selectorLabels" -}}
app: {{ include "stateless-app.name" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "stateless-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "stateless-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}