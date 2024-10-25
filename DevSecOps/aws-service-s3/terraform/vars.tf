#####Tags####
variable "env" {
  description = "Tag Envirolment"
  default = "{{ env }}"
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `prod`, `dev`, `staging`, `infra`)"
  default     = "{{ env }}"
}
variable "name" {
  type        = string
  description = "Name  (e.g. `app` or `cluster`)"
#  default      = "{{ prefix_stack_hostname }}s3{{ prefix_stack_name }}{{ env }}"
}
####Account Variable######
variable "aws_account_id" {
  description = "AWS Id Account"
  default = "{{ aws_account_id }}"
}
variable "region" {
  description = "Region that will be used in AWS"
  default = "{{ aws_region }}"
}

variable "aws_region" {
  default = "{{ aws_region }}"
}


variable "force_destroy" {
  type        = bool
  description = "A boolean string that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable"
#  default     = "@@FORCE_DESTROY@@"
}
