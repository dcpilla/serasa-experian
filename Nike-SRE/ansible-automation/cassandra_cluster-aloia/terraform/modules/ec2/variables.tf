variable "subnet_name" {
    description = "Subnet for launch the instances"
    type        = string
}

variable "use_placement_group" {
    description = "Flag for enable or disable placement group"
    type        = bool
    default     = false
}

variable "placement_group_name" {
    description = "Name of the placement group"
    type        = string
    default     = ""
}

variable "env" {
    type = string
}

variable "instance_count" {
    description = "Number of instances to launch"
    type        = number
    default     = 1
}

variable "ami" {
    description = "AMI ID"
    type        = string
}

variable "instance_type" {
    type = string
}

variable "project_name" {
    type = string
}

variable "keypair_name" {
    type = string
}

variable "userdata" {
    type = string
    default = ""
}


variable "iam_instance_profile" {
    type = string
    default = ""
}

variable "security_group_ids" {
    type = list(string)
}

variable "vpc_id" {
  description = "AWS VPC id"
  type = string
}

variable "account_id" {
  type = string
}

variable "BU" {
  type = string
}

variable "volume_tags" {
    type    = map
    default = {}
}

variable "tags" {
  type    = map
  default = {}
}

variable "metadata_options" {
  description = "Customize the metadata options of the instance"
  type        = map(string)
  default     = {}
}

variable "resource_name" {
  type    = string
  default = ""
}
