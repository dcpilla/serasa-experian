variable "env" {
  description = "Name of environment (dev|uat|sandbox)"
  type        = string

}
variable "eks_cluster_name" {
  description = "Name of EKS cluster"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "eks_cluster_id" {
  description = "EKS cluster ID"
  type        = any
}

variable "tags" {
  description = "Default Tags to put in all resources"
  type        = map(any)
  default     = {}
}

variable "oidc_provider_arn" {
  description = "OIDC EKS provider"
  type        = string
}
#=~=~=~=~=~=~=~=~=~
# AWS LOAD BALANCER CONTROLLER
#=~=~=~=~=~=~=~=~=~

variable "eec_boundary_policy" {
  description = "ARN EEC boundary policy"
  type        = string
}

variable "eks_namespace" {
  description = "Namespace to install coe-argocd"
  type        = string
  default     = "kube-system"
}

variable "helm_version" {
  description = "Version of the Helm Coe Argo"
  type        = string
  default     = "1.7.1"
}

variable "resources_aws_account" {
  description = "AWS Account with the basic resources"
  type        = string
  default     = "837714169011"
}

#=~=~=~=~=~=~=~=~=~
# Mandatory TAGS
#=~=~=~=~=~=~=~=~=~
variable "coststring" {
  description = "Cost Center (CostString) of your project"
  type        = string
}
variable "appid" {
  description = "AppID of your project"
  type        = string
}
