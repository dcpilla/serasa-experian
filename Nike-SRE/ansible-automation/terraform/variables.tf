variable "region" {
  description = "AWS region"
}

variable "environment" {
  description = "Name of environment (dev|uat|prod|sandbox)"
  type        = string
}

variable "stack_name" {
  description = "Name of the stack (used as prefix)"
  type        = string
}

variable "instance_type_logstash" {
  # description = ""
  type        = string
  default     = "t3a.small"
}

variable "instance_termination_protection" {
  description = "FOR USAGE ON TERRAFORMING - plan/apply/destroy with false to remove instance"
  type    = bool
  default = true
}

variable "logstash_allowed_cidrs" {
  description = "Allowed CIDR blocks to talk to Logstash"
  type = list(string)
  default = ["10.0.0.0/8"]
}

variable "instance_key_logstash" {
  # description = "(optional) describe your variable"
  type = string
}

variable "opensearch_master_username" {
  description = "Username for master user on Elastic/OpenSearch"
  type = string
  default = "administrator"
}

variable "opensearch_allowed_cidrs" {
  description = "Allowed CIDR blocks to talk to Elastic/OpenSearch"
  type = list(string)
  default = ["10.0.0.0/8"]
}

variable "opensearch_custom_endpoint" {
  description = "FQDN to alias the OpenSearch domain"
  type        = string
  default     = ""
}

variable "opensearch_custom_endpoint_arn" {
  description = "Certificate ARN to be used to serve the OpenSearch domain"
  type        = string
  default     = ""
}

variable "opensearch_master_instance_type" {
  description = "OpenSearch master nodes instance type"
  type        = string
  default     = "c6g.search.large"
}

variable "opensearch_master_instance_count" {
  description = "OpenSearch master nodes instance count (must be 0, 3 or 5)"
  type        = number
  default     = 3

  validation {
    condition = var.opensearch_master_instance_count == 0 || var.opensearch_master_instance_count == 3 || var.opensearch_master_instance_count == 5
    error_message = "Value must be either 0, 3 or 5"
  }
}

variable "opensearch_data_instance_type" {
  description = "OpenSearch data nodes instance type"
  type        = string
  default     = "m6g.search.large"
}

variable "opensearch_data_instance_count" {
  description = "OpenSearch data nodes instance count"
  type        = number
  default     = 5
}

variable "opensearch_data_storage_size" {
  description = "OpenSearch data nodes storage size"
  type        = number
  default     = 60
}

variable "kafka_storage_size" {
  description = "Kafka storage size (in GB)"
  type = number
  default = 20
}

variable "kafka_port_plain" {
  description = "Default Kafka port (plain)"
  type = number
  default = 9092
}

# variable "kafka_port_tls" {
#   description = "Default Kafka port (TLS)"
#   type = number
#   default = 9094
# }

variable "zookeeper_port_plain" {
  description = "Default Zookeeper port (plain)"
  type = number
  default = 2181
}

# variable "zookeeper_port_tls" {
#   description = "Default Zookeeper port (TLS)"
#   type = number
#   default = 2182
# }

variable "kafka_allowed_cidrs" {
  description = "Allowed CIDR blocks to talk to Kafka and Zookeeper"
  type = list(string)
  default = ["10.0.0.0/8", "100.64.0.0/16"]
}

