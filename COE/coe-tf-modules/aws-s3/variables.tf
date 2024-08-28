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

variable "bu_name" {
  description = "Name of the BU"
  type        = string
}


variable "tags" {
  description = "Tags to put use for all resources"
  type        = any
  default     = {}
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
# S3
#=~=~=~=~=~=~=~=~=~

# variable "bucket_name" {
#   description = "(Optional, Forces new resource) Name of the bucket. If omitted, Terraform will assign a random, unique name. Must be lowercase and less than or equal to 63 characters in length. A full list of bucket naming rules may be found here."
#   type        = string
# }

# variable "bucket_prefix " {
#   description = "(Optional, Forces new resource) Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket. Must be lowercase and less than or equal to 37 characters in length. A full list of bucket naming rules may be found here."
#   type        = string
# }

variable "bucket_experian_prefix " {
  description = "(Optional, Forces new resource) Creates a unique bucket name ending with the specified prefix. Conflicts with bucket and bucket_prefix. Must be lowercase and less than or equal to 37 characters in length. A full list of bucket naming rules may be found here. Ex:serasaexperian-var.project_name-var.env-var.bucket_experian_prefix"
  type        = string
}


variable "force_destroy " {
  description = " (Optional, Default:false) Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error. These objects are not recoverable. This only deletes objects when the bucket is destroyed, not when setting this parameter to true. Once this parameter is set to true, there must be a successful terraform apply run before a destroy is required to update this value in the resource state. Without a successful terraform apply after this parameter is set, this flag will have no effect. If setting this field in the same operation that would require replacing the bucket or destroying the bucket, this flag will not work. Additionally when importing a bucket, a successful terraform apply is required to set this value in state before it will take effect on a destroy operation."
  type        = bool
  default     = false
}

variable "object_lock_enabled " {
  description = " (Optional, Forces new resource) Indicates whether this bucket has an Object Lock configuration enabled. Valid values are true or false. This argument is not supported in all regions or partitions."
  type        = bool
  default     = false
}

variable "tags " {
  description = " (Optional) Map of tags to assign to the bucket. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider"
  type        = string
}

variable "log_expected_bucket_owner " {
  description = " (Optional, Forces new resource) Account ID of the expected bucket owner."
  type        = string
}
variable "log_target_bucket " {
  description = " (Required) Name of the bucket where you want Amazon S3 to store server access logs."
  type        = string
}
variable "log_target_prefix " {
  description = " (Required) Prefix for all log object keys."
  type        = string
}
variable "log_target_grant " {
  description = " (Optional) Set of configuration blocks with information for granting permissions. See below."
  type        = string
  default     = ""
}

variable "log_bucket_used_for_store_log" {
  description = "(Optional) Set if this bucket will be used to stored logs"
  type        = bool
  default     = false
}
#=~=~=~=~=~=~=~=~=~
# EAGLE - GOVERNANCE TAGS
#=~=~=~=~=~=~=~=~=~

variable "data_gov_tags" {
  description = "Tags defined by Data Governance #https://pages.experian.com/pages/viewpage.action?pageId=1001013241"
  type        = map(string)
  # default = {
  #   "Asset_Category" = "n/a"
  #   "Data_Category"  = "n/a"
  #   "Data_Type"      = "n/a"
  # }
}
