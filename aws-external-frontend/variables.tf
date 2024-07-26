locals {
  env = var.environment == "prod" ? "prd" : var.environment
  domain = var.domain_name != "" ? var.domain_name : "${var.app_name}-${var.environment}${var.certificate_domain}"
}

variable "aws_assume_role_arn" {
  description = "Assume Role ARN"
  default     = "arn:aws:iam::@@AWS_ACCOUNT_ID@@:role/BURoleForDevSecOpsCockpitService"
}

variable "aws_account_id" {
  type    = string
  default = "@@AWS_ACCOUNT_ID@@"
}

variable "environment" {
  type    = string
  default = "@@ENVIRONMENT@@"
}

variable "business_unit" {
  type    = string
  default = "@@BUSINESS_UNIT@@"
}

variable "app_gearr_id" {
  type    = string
  default = "@@APP_GEARR_ID@@"
}

variable "app_name" {
  type    = string
  default = "@@APP_NAME@@"
}

variable "app_type" {
  type    = string
  default = "@@APP_TYPE@@"
}

variable "certificate_domain" {
  type    = string
  default = "@@CERTIFICATE_DOMAIN@@"
}

variable "certificate_arn" {
  type    = string
  default = "@@CERTIFICATE_ARN@@"
}

variable "domain_name" {
  type    = string
  default = "@@DOMAIN_NAME@@"
}

variable "cost_center" {
  type    = string
  default = "@@COST_CENTER@@"
}

variable "project_name" {
  type    = string
  default = "@@PROJECT_NAME@@"
}
