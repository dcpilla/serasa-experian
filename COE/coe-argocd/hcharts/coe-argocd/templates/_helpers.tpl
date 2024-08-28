

{{/* vim: set filetype=mustache: */}}
{{/*
Create the secrets provider objectName
based on the secretManager criation in the Terraform code
*/}}

{{- define "secretmanager.argocd" -}}
  {{- printf "%s/%s/argocd_%s-repositories" .Values.coe_argocd.project_name .Values.coe_argocd.eks_cluster_name .Values.coe_argocd.env -}}
{{- end -}}

{{- define "secretmanager.dex" -}}
  {{- printf "%s/%s/dex_%s-settings" .Values.coe_argocd.project_name .Values.coe_argocd.eks_cluster_name .Values.coe_argocd.env -}}
{{- end -}}

{{/*
Domain settings
*/}}

{{- define "argocd.url" -}}
  {{- printf "deploy-%s-%s.%s" .Values.coe_argocd.eks_cluster_name .Values.coe_argocd.env .Values.coe_argocd.domain -}}
{{- end -}}


{{/*
Istio settings
*/}}
{{- define "istio.gw.name" -}}
    {{- printf "kube-deploy-stack-gw" -}}
{{- end -}}

{{- define "istio.vs.name" -}}
    {{- printf "kube-deploy-stack-argo-vs" -}}
{{- end -}}


{{/*
Default applications settings
*/}}

{{- define "default.applications.target.revision" -}}
    {{- $gitBranchs := dict "dev" "develop" "uat" "homolog" "prod" "main" -}}
    {{- .Values.coe_argocd.defaut_applications.source.targetRevision | default  (get $gitBranchs .Values.coe_argocd.env) -}}
{{- end -}}

{{- define "default.applications.helm.values.file" -}}
    {{- printf "value-%s.yaml" .Values.coe_argocd.env -}}
{{- end -}}

{{- define "argo_cd.fullname" -}}
{{- index .Values "argo-cd" "fullnameOverride" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "argo_cd.server.fullname" -}}
    {{- printf "%s-server" (include "argo_cd.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}