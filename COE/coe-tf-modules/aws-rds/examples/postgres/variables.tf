variable "env" {
  type    = string
  default = "dev"
}

variable "aws_region" {
  type    = string
  default = "sa-east-1"
}

variable "application_name" {
  description = "application_name"
  type        = string
}

variable "project_name" {
  description = "project_name"
  type        = string
  default     = ""
}

#=~=~=~=~=~=~=~=~=~=
# RDS
#=~=~=~=~=~=~=~=~=~=

variable "db_instance_class" {
  type    = string
  default = "db.t4g.small"
}

variable "db_maintenance_window" {
  type    = string
  default = "Sun:00:00-Sun:04:00"
}

variable "db_max_allocated_storage" {
  type    = number
  default = 500
}

variable "db_allocated_storage" {
  type    = number
  default = 100
}

variable "db_iops" {
  type    = string
  default = 3000
}

variable "db_multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "db_backup_retention_period" {
  type    = number
  default = 7
}

variable "db_backup_window" {
  type    = string
  default = "22:00-23:00"
}