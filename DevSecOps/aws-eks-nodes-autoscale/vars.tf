variable "aws_account_id" {
  description = "AWS Account id"
  type        = string
  default     = "@@AWS_ACCOUNT_ID@@"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "@@AWS_REGION@@"
}

variable "env" {
  description = "Name of environment"
  type        = string
  default     = "@@ENV@@"
}

variable "bu_name" {
  description   = "BU Name"
  type          = string
  default       = "@@BU@@"
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string
  default     = "@@EKS_CLUSTER_NAME@@"
}

variable "bucket" {
  description = "Bucket name"
  type        = string
  default     = "cockpit-devsecops-states-@@AWS_ACCOUNT_ID@@"
}

variable "bucket_folder" {
  description = "Bucket folder name"
  type        = string
  default     = "aws-eks-nodes-autoscale"
}

variable "tags" {
  description = "Aditional Tags"
  type        = map
  default     = {
    Terraform = "true"
  }
}

variable "env_map" {
  type    = map(string)

  default = {
    staging = "stg"
    dev     = "dev"
    uat     = "uat"
    test    = "tst"
    sandbox = "sbx"
    prod    = "prd"
  }
}

variable "cron_up" {
  description = "Expression Cron"
  type        = string
  default     = "@@CRON_UP@@"
}

variable "cron_down" {
  description = "Expression Cron"
  type        = string
  default     = "@@CRON_DOWN@@"
}

variable "state" {
  description = "Rule state"
  type        = string
  default     = "@@STATE@@"
}
