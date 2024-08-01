variable "ebs_instance_count" {
  type = number
}

variable "instances" {
    type = list(string)
}

variable "volume_ids" {
    type = list(string)
}

variable "device_name" {
    type = string
    default = "/dev/xvdb"
}
