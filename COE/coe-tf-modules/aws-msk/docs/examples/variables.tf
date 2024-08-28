variable "region" {
  description = "AWS region."
  type        = string
  default     = "sa-east-1"
}

variable "env" {
  description = "Environment name "
  type        = string
}
variable "application_name" {
  description = "Your application name"
  type        = string
  default     = "msk"
}

variable "project_name" {
  description = "The project name"
  type        = string
  default     = "data-platform"
}
