variable "env" {
  default = "dev"
  type    = string
}
variable "region" {
  default = "sa-east-1"
  type    = string
}
variable "gearr_id" {
  description = "Gearr ID"
  type        = string
}
variable "cost_string" {
  default = "1800.BR.402.406014"
  type    = string
}
variable "application_name" {
  default = "emr-studio"
  type    = string
}
variable "project_name" {
  default = "emr-studio-dataengineer"
  type    = string
}
variable "emr_studio_bucket_category" {
  default = "Metadata"
  type    = string
}
variable "emr-subnet" {
  description = "Subnet tag to be used on Studio"
  type        = string
  default     = "emr"
}

variable "team" {
  default = ""
  type    = string
}

variable "buckets_name_allow_emr_studio_role" {
  description = "List of buckets name to allow access from emr studio role"
  type        = list(string)
  default     = []
}

variable "buckets_name_deny_emr_studio_role" {
  description = "List of buckets name to deny access from emr studio role"
  type        = list(string)
  default     = []
}

variable "buckets_name_allow_emr_role" {
  description = "List of buckets name to allow access from emr role"
  type        = list(string)
  default     = []
}

variable "team_list" {
  description = "List of teams / s3 bucket"
  type        = list(string)
  default     = ["data-intelligence", "analytics-modelling", "analytics-fraud", "analytics-insights", "analytics-consultancy", "analytics-marketing", "data-strategy"]
}

variable "allowed_instance_types" {
  description = "Set here the allowed instance types for the EMR Studio"
  type        = list(string)
  default = ["m5.xlarge", "m5.2xlarge", "m5.4xlarge", "m5.8xlarge",
  "r5.xlarge", "r5.2xlarge", "r5.4xlarge", "r5.8xlarge"]
}

variable "maximum_capacity_units" {
  description = "Set maximum capacity units for autoscalling"
  type        = number
  default     = 8
}

variable "maximum_core_capacity_units" {
  description = "Set maximum core capacity units for autoscalling"
  type        = number
  default     = 8
}

variable "maximum_ondemand_capacity_units" {
  description = "Set maximum OnDemand capacity units for autoscalling"
  type        = number
  default     = 8
}

variable "minimum_capacity_units" {
  description = "Set minimum capacity units for autoscalling"
  type        = number
  default     = 1
}

variable "allowed_applications" {
  description = "Set here the allowed applications for the EMR Studio"
  type        = list(string)
  default     = ["Hadoop", "JupyterEnterpriseGateway", "Hue", "Spark", "JupyterHub"]
}


variable "emr_cluster_configurations" {
  description = "Configurations to use in a EMR Cluster"
  type        = list(string)
  default     = []
}

variable "bootstrap_script_path" {
  description = "Bootstrap script relative local path."
  type = string
  default = "bootstrap-scripts/bootstrap-script.sh"  
}

variable "additional_user_policy_control" {
  type = bool
  description = "External user policy control"
  default = false
}
