variable "env" {
  type    = string
  default = "Dev"
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

#=~=~=~=~=~=~=~=~=~
# SERVICE CATALOG ROUTE53
#=~=~=~=~=~=~=~=~=~
variable "sub_domain" {
  description = "Sub domain name"
  type        = string
  default     = "null"
}

variable "s3_logs_expiration_days" {
  description = "How long stored the data before delete it, in DAYs format."
  type        = number
  default     = 1825
}

variable "s3_logs_transition_days" {
  description = "After X days move the data to Glacier."
  type        = number
  default     = 150
}

