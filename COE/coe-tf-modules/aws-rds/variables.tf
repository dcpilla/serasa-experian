################################################
## General
################################################
variable "env" {
  description = "Environment sbx|dev|tst|uat|stg|prd"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "sa-east-1"
}

variable "application_name" {
  description = "Name of the application that will cosume this Database"
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Name of project"
  type        = string
  default     = ""
}

variable "bu" {
  description = "BU name ex. CS/CI, CS/BI, DA, PME, ECS, eI, M, Datalab, Agro, Data Strategy, Finanças, Vendas, TI, Jurídico, Marketing"
  type        = string
}

variable "category_asset" {
  description = "Asset category for data hosted in this RDS, options are: Model Developing, Logs , Cache , Metadata, Backup, N/A"
  type        = string
}

variable "type_data" {
  description = "Type of the data, options are: PP (physical person), LP (legal person), PP/LP, N/D"
  type        = string
}

variable "category_data" {
  description = "Data category,options are: Register, Behavioral, Negative, Positive, Transactional, Finance, N/D"
  type        = string
}

variable "cost_string" {
  description = "This value can be used for tag-based cost reports, budgets, cost-tracking, etc.. Please consult with the finance contact for your Cost String to see if tag based cost reporting is being used. Ex.: 1111.CC.222.3333333"
  type        = string
}

variable "app_id" {
  description = "The new Experian standard cloud resources tag “AppID” (also known as a GEARR “App ID” ) is a unique global identification number assigned to each business application registered in APM. Ex.: 12345"
  type        = string
}

################################################
## RDS
################################################
variable "db_engine" {
  description = "The database engine to use. For supported values, see the Engine parameter in API action CreateDBInstance. Cannot be specified for a replica. Note that for Amazon Aurora instances the engine must match the DB cluster's engine'."
  type        = string
}

variable "db_engine_version" {
  description = "The engine version to use. If auto_minor_version_upgrade is enabled, you can provide a prefix of the version such as 5.7 (for 5.7.10). The actual engine version used is returned in the attribute engine_version_actual"
  type        = string
}

variable "db_instance_class" {
  description = "The RDS instance class."
  type        = string
}

variable "db_port" {
  description = "The port on which the DB accepts connections."
  type        = number
}

variable "db_name" {
  description = "The database name."
  type        = string
}

variable "db_username" {
  description = "Username for the master DB user. Cannot be specified for a replica."
  type        = string
}

variable "db_password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  type        = string
}

variable "db_maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = ""
}

variable "db_max_allocated_storage" {
  description = "When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance. Configuring this will automatically ignore differences to allocated_storage. Must be greater than or equal to allocated_storage or 0 to disable Storage Autoscaling"
  type        = number
  default     = 0
}

variable "db_multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "db_allocated_storage" {
  description = "When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance. Configuring this will automatically ignore differences to allocated_storage. Must be greater than or equal to allocated_storage or 0 to disable Storage Autoscaling"
  type        = number
}

variable "db_backup_retention_period" {
  description = "The days to retain backups for. Must be between 0 and 35. Must be greater than 0 if the database is used as a source for a Read Replica"
  type        = number
  default     = 0
}

variable "db_backup_window" {
  type    = string
  default = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: 09:46-10:16. Must not overlap with maintenance_window."
}

variable "db_security_group_ids" {
  description = "Id of de Security Group to be associate to new RDS"
  type        = list(any)
}

variable "db_allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible."
  type        = bool
  default     = false
}
variable "db_auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  type        = bool
  default     = true
}

variable "db_deletion_protection" {
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to true"
  type        = bool
  default     = false

}
variable "db_monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60."
  type        = number
  default     = 0

}

variable "db_skip_final_snapshot" {
  description = " Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  type        = bool
  default     = true
}

variable "db_apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = true
}
variable "db_iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of io1."
  type        = number
  default     = 0
}
variable "db_performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled."
  type        = bool
  default     = false
}

variable "db_performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data. When specifying db_performance_insights_kms_key_id, db_performance_insights_enabled needs to be set to true. Once KMS key is set, it can never be changed."
  type        = string
  default     = ""
}

variable "db_performance_insights_retention_period" {
  description = "The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years). When specifying db_performance_insights_retention_period, db_performance_insights_enabled needs to be set to true"
  type        = number
  default     = 0
}

variable "db_storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'gp2' if not."
  type        = string
  default     = "gp2"
}

variable "db_iam_database_authentication_enabled" {
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled."
  type        = bool
  default     = true
}

variable "db_availability_zone" {
  description = "The AZ for the RDS instance"
  type        = string
  default     = ""
}

variable "db_tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

################################################
## KMS
################################################
variable "kms_alias" {
  description = "KMS alias to be used by RDS. By default this module will create new KMS for used if you let this values to blank"
  type        = string
  default     = ""
}

variable "kms_deletion_window_in_days" {
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive. If you do not specify a value, it defaults to 30. If the KMS key is a multi-Region primary key with replicas, the waiting period begins when the last of its replica keys is deleted. Otherwise, the waiting period begins immediately."
  type        = string
  default     = "10"
}



################################################
## VPC
################################################
variable "vpc_tag_for_select" {
  description = "Tag for select the VPC"
  type        = map(string)
  default = {
    AWS_Solutions = "LandingZoneStackSet"
  }
}

variable "vpc_tag_for_select_subnets" {
  description = "Tag for select the Subnets"
  type        = map(string)
  default = {
    Network = "Private"
  }
}
