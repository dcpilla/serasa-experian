variable "env" {
  description = "Environment (SANDBOX|DEV|UAT|PROD)"
  type        = string
  default     = "Dev"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "sa-east-1"
}

variable "application_name" {
  description = "Name of the aplication"
  type        = string
}

variable "project_name" {
  description = "Name of your project"
  type        = string
  default     = "mlcoe"
}

variable "assume_role_account_id" {
  description = "AWS Account ID that will assume role BURoleForSRE in this account"
  type        = string
  default     = "218245340339"
}

variable "bu_name" {
  description = "Name of the BU"
  type        = string
}


variable "tags" {
  description = "Tags to put use for all resources"
  type        = any
  default     = {}
}

variable "endpoint_allowed_ip" {
  description = "List of ips allowed to conect with private endpoints"
  type        = list(any)
  default     = []
}
#=~=~=~=~=~=~=~=~=~
# Documentation Cluster
#=~=~=~=~=~=~=~=~=~

variable "path_documentation_file" {
  description = "Path to create doc file path_documentation_file/docs/ENV.md, if empty the doc do not will be created"
  type        = string
  default     = ""
}

variable "documention" {
  description = "Aditional documentation to be joined with the default create by this moduele"
  type        = string
  default     = ""
}


#=~=~=~=~=~=~=~=~=~
# VPC
#=~=~=~=~=~=~=~=~=~
variable "vpc_tag_for_select" {
  description = "Tag for select the VPC"
  type        = map(string)
  default = {
    AWS_Solutions = "LandingZoneStackSet"
  }
}

#=~=~=~=~=~=~=~=~=~
# ENDPOINTS
#=~=~=~=~=~=~=~=~=~
variable "aws_endpoints_urls_enabled" {
  description = "Create or not the endpoints set up in aws_endpoints_urls, Default true."
  type = bool
  default = true
}

variable "aws_endpoints_urls" {
  description = "List of endpoints to be created in Aws account"
  type        = list(any)
  default = [
    "com.amazonaws.sa-east-1.ecr.api",
    "com.amazonaws.sa-east-1.ecr.dkr",
    "com.amazonaws.sa-east-1.ec2",
    "com.amazonaws.sa-east-1.logs"
  ]
}


#=~=~=~=~=~=~=~=~=~
# S3
#=~=~=~=~=~=~=~=~=~

variable "bucket_tf_state_end_name" {
  description = "For compatibilities purpose we introduced this new one variable to define end name for tf-state bucket name"
  type        = string
  default     = "tf"
}

variable "s3_logs_expiration_days" {
  description = "How long stored the data before delete it, in DAYs format."
  default     = 1825
  type        = number
}

variable "s3_logs_transition_days" {
  description = "After X days move the data to Glacier."
  default     = 150
  type        = number
}

#=~=~=~=~=~=~=~=~=~
# KEYPAIR
#=~=~=~=~=~=~=~=~=~
variable "key_pair_create" {
  description = "Create or not a new Key pair"
  type        = bool
  default     = true
}

variable "key_pair_name" {
  description = "Name for key pair name"
  type        = string
  default     = "mlcoe"
}

#=~=~=~=~=~=~=~=~=~
# SECURITY GROUP
#=~=~=~=~=~=~=~=~=~
variable "aws_security_group_description" {
  description = "Description for SG enpoints"
  type        = string
  default     = "Managed by Terraform"

}

#=~=~=~=~=~=~=~=~=~
# SERVICE CATALOG ROUTE53
#=~=~=~=~=~=~=~=~=~

variable "product_id" {
  description = "The product ID to provisions private Route53 Sub domain"
  type        = string
  default     = "prod-tnkdpfmuz7ajq"
}

variable "provisioning_artifact_id" {
  description = "The artifac ID to provisions private Route53 Sub domain"
  type        = string
  default     = "pa-w5km2xb67iprg"
}

variable "sub_domain" {
  description = "Sub domain name"
  type        = string
  default     = "null"
}

#=~=~=~=~=~=~=~=~=~
# Additional policy for developers
#=~=~=~=~=~=~=~=~=~
variable "additional_Developers_policy" {
  description = "Additional BURoleForDevelopersAccess Policy"
  type        = map(any)
  default     = {}
}

