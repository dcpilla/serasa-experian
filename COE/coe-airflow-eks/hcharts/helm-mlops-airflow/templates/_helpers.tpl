{{/*
Construct the `labels.app` for used by all resources in this chart.
*/}}
{{- define "airflow.labels.app" -}}
{{- printf "%s" .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Construct the `labels.chart` for used by all resources in this chart.
*/}}
{{- define "airflow.labels.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "airflow.labels" -}}
app: {{ include "airflow.labels.app" . }}
component: configmap
chart: {{ include "airflow.labels.chart" . }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
version: {{ .Chart.Version }}
Environment: {{ .Values.env }}
{{- end }}


{{/*
Create the secrets provider objectName
based on the secretManager criation in the Terraform code
*/}}

{{- define "cluster.name" -}}
  {{- printf "%s-%s" .Values.cluster_informations.name .Values.env }}
{{- end }}

{{- define "secretmanager.datasource" -}}
  {{- default .Values.secretmanager.datasource (printf "%s-%s-%s/db-datasource-%s" .Values.application_name .Values.project_name .Values.cluster_informations.name .Values.env) }}
{{- end }}

{{- define "secretmanager.websecretkey" -}}
  {{- default .Values.secretmanager.websecretkey (printf "%s-%s-%s/webserver_secretkey-%s" .Values.application_name .Values.project_name .Values.cluster_informations.name .Values.env) }}
{{- end }}

{{- define "secretmanager.fernetkey" -}}
  {{- default .Values.secretmanager.fernetkey (printf "%s-%s-%s/airflow_fernetkey-%s" .Values.application_name .Values.project_name .Values.cluster_informations.name .Values.env) }}
{{- end }}

{{- define "secretmanager.gitsshprivkey" -}}
  {{- default .Values.secretmanager.gitsshprivkey (printf "%s-%s-%s/git_ssh_priv_key-%s" .Values.application_name .Values.project_name .Values.cluster_informations.name .Values.env) }}
{{- end }}

{{- define "secretmanager.webserverconfig" -}}
  {{- default .Values.secretmanager.webserverconfig (printf "%s-%s-%s/webserver_config-%s" .Values.application_name .Values.project_name .Values.cluster_informations.name .Values.env) }}
{{- end }}

{{- define "secretmanager.extravars" -}}
  {{- default .Values.secretmanager.extravars (printf "%s-%s-%s/extra-vars-%s" .Values.application_name .Values.project_name .Values.cluster_informations.name .Values.env) }}
{{- end }}



{{- define "host.by.cluster.informations" -}}
    {{- if .Values.cluster_informations -}}
        {{- if and (.Values.cluster_informations.name) (.Values.cluster_informations.domain) -}}
                {{- printf "%s-%s.%s" .Values.application_name  .Values.cluster_informations.name .Values.cluster_informations.domain -}}
        {{- end -}}
    {{- end -}}
{{- end -}}


{{- define "default.host" -}}
    {{- if  (include "host.by.cluster.informations" .) -}}
        {{- printf "%s" (include "host.by.cluster.informations" .) -}}
    {{- else if .Values.host  -}}
         {{- printf "%s" .Values.host -}}
    {{- else -}}
        {{- printf "%s" .Values.application_name -}}
    {{- end -}}
{{- end -}}

