################################################
## General
################################################
variable "env" {
  description = "Environment sandbox|dev|uat|prod"
  type        = string
  default     = "Dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "sa-east-1"
}

variable "application_name" {
  description = "Name of the application that will cosume this Secrets Manager"
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Name of project"
  type        = string
  default     = ""
}


################################################
## SECRETS MANAGER
################################################

variable "sm_description" {
  description = "(Optional) Description of the secret."
  type        = string
  default     = ""
}
variable "sm_kms_key_id" {
  description = "(Optional) ARN or Id of the AWS KMS key to be used to encrypt the secret values in the versions stored in this secret. If you don't specify this value, then Secrets Manager defaults to using the AWS account's default KMS key (the one named aws/secretsmanager). If the default KMS key with that name doesn't yet exist, then AWS Secrets Manager creates it for you automatically the first time."
  type        = string
  default     = null
}
variable "sm_name_prefix" {
  description = "(Optional) Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null
}

variable "sm_policy" {
  description = "(Optional) Valid JSON document representing a resource policy. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide. Removing policy from your configuration or setting policy to null or an empty string (i.e., policy = \"\") will not delete the policy since it could have been set by aws_secretsmanager_secret_policy."
  type        = string
  default     = null
}
variable "sm_recovery_window_in_days" {
  description = "(Optional) Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days."
  type        = number
  default     = 30
}
variable "sm_replica" {
  description = "(Optional) Configuration block to support secret replication."
  type        = string
  default     = null
}
variable "sm_force_overwrite_replica_secret" {
  description = "(Optional) Accepts boolean value to specify whether to overwrite a secret with the same name in the destination Region."
  type        = bool
  default     = false
}

variable "default_tags" {
  description = "(Optional) Key-value map of user-defined tags that are attached to all reource created with this module. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(any)
  default     = {}
}

################################################
## SECRETS MANAGER VERSION
################################################

variable "smv_secret_string" {
  description = "(Optional) Specifies text data that you want to encrypt and store in this version of the secret. This is required if smv_secret_binary is not set."
  type        = string
  default     = null
}
variable "smv_secret_binary" {
  description = "(Optional) Specifies binary data that you want to encrypt and store in this version of the secret. This is required if smv_secret_string is not set. Needs to be encoded to base64."
  type        = string
  default     = null
}
variable "smv_version_stages" {
  description = "(Optional) Specifies a list of staging labels that are attached to this version of the secret. A staging label must be unique to a single version of the secret. If you specify a staging label that's already associated with a different version of the same secret then that staging label is automatically removed from the other version and attached to this version. If you do not specify a value, then AWS Secrets Manager automatically moves the staging label AWSCURRENT to this new version on creation."
  type        = list(any)
  default     = []
}
