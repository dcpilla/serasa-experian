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
