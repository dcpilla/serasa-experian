{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "app.name" -}}
{{- default .Chart.Name| trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart.name" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "rbac.name.system.account" -}}
{{- printf "%s-%s"  .Chart.Name "system-account"| trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "rbac.name.role" -}}
{{- printf "%s-%s"  .Chart.Name "role"| trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "rbac.name.role.binding" -}}
{{- printf "%s-%s"  .Chart.Name "role-binding"| trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "job.name" -}}
{{- printf "%s-%s"  .Chart.Name "job"| trunc 63 | trimSuffix "-" }}
{{- end }}