variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "sa-east-1"
}

variable "account_id" {
  type        = string
  description = "AWS Account id"
}

variable "ami" {
    default = null
}

variable "userdata" {
    type = string
    default = ""
}

variable "project_name" {
  type        = string 
  description = "Project Name"
}

variable "instance_type" {
  description = "AWS Instance type"
}

variable "subnet" {
  type = map
}

variable "keypair_name" {
  type = string
  description = "Name of the KeyPair used for all nodes"
}

# variable security_group_ids {
#   type = list(string)
# }

variable "BU" {
  type = string
}

variable "tags" {
    type    = map
    default = {}
}

variable "volume_tags" {
    type    = map
    default = {}
}

variable "env" {
    type        = string
    description = "Name of environment"
}

variable "number_of_cassandra_nodes_az_a" {
  description = "Total number of cassandra nodes in az_a"
}

variable "number_of_cassandra_nodes_az_b" {
  description = "Total number of cassandra nodes in az_b"
}

#variable "number_of_cassandra_nodes_az_c" {
#  description = "Total number of cassandra nodes in az_c"
#}

variable "hosted_zone_id" {
  type = string
}

variable "volume_ids_az_a" {
  type = list(string)
  default = []
}

variable "volume_ids_az_b" {
  type = list(string)
  default = []
}

#variable "volume_ids_az_c" {
#  type = list(string)
#  default = []
#}

variable "aws_route53_record_name" {
  type = map

  default = {
    a = "seed-az_a"
    b = "seed-az_b"
#    c = "seed-az_c"
  }
}

variable "disk_size" {
  type = number
}

variable "iops" {
  type = number
}

variable "disk_type" {
  type = string
  default = "gp3"
}

variable "throughput" {
  type = number
}

variable "lb_ports" {
  type    = map(object({
    name     = string
    protocol = string
    port     = number
  }))
  
  default = {
    "http"  = {
      name      = "http"
      protocol  = "TCP"
      port      = 80
    }
    "https" = {
      name      = "https"
      protocol  = "TLS"
      port      = 443
    }
  }
}

variable "lb_ssl_arn" {
  default = null
}
variable "lb_log_enabled" {
  default = true
}

variable "lb_bucket" {
  type = string
}

variable "lb_bucket_prefix" {
  type = string
}

variable "lb_name" {
  type = string
  default = null
}

variable "lb_internal" {
  default = false
}

variable "lb_access_logs" {
  description = "An access logs block"
  type        = map(string)
  default     = {}
}

variable "resource_name" {
  type    = string
  default = null
}

variable "metadata_options" {
  description = "Customize the metadata options of the instance"
  type        = map(string)
  default     = {}
}
