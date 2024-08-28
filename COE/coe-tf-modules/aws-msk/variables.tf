#=~=~=~=~=~=~=~=~=~=
# DEFAULT
#=~=~=~=~=~=~=~=~=~=
variable "env" {
  description = "Environment name "
  type        = string
}

variable "region" {
  description = "AWS region."
  type        = string
  default     = "sa-east-1"
}

variable "application_name" {
  description = "Your application name"
  type        = string
  default     = "msk-kafka"
}

variable "project_name" {
  description = "The project name"
  type        = string
  default     = "data-platform"
}

#=~=~=~=~=~=~=~=~=~=
# MSK ClUSTER
#=~=~=~=~=~=~=~=~=~=
variable "name" {
  description = "Name of the MSK cluster, ex. projectName-applicationName-name-env"
  type        = string
}
variable "kafka_version" {
  description = "Specify the desired Kafka software version"
  type        = string

}
variable "number_of_brokers" {
  description = "The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets"
  type        = number
}

variable "enhanced_monitoring" {
  description = "Specify the desired enhanced MSK CloudWatch monitoring level. See https://docs.aws.amazon.com/msk/latest/developerguide/monitoring.html"
  type        = string
  default     = "PER_TOPIC_PER_BROKER"

}


variable "enable_s3_log_delivery" {
  description = "Set to true to enable log delivery to S3"
  type        = bool
  default     = false
}

variable "enable_s3_log_bucket" {
  description = "Name of bucket to send log"
  type        = string
  default     = ""
}

variable "enable_cloudwatch_log_delivery" {
  description = "Set to true to enable log delivery to CloudWatch"
  type        = bool
  default     = false
}

#=~=~=~=~=~=~=~=~=~=
# BROKER NODE INFO
#=~=~=~=~=~=~=~=~=~=

variable "instance_type" {
  description = "Specify the instance type to use for the kafka brokersE.g., kafka.m5.large"
  type        = string
}
variable "storage_info_ebs_storage_info_volume_size" {
  description = "he size in GiB of the EBS volume for the data drive on each broker node. Minimum value of 1 and maximum value of 16384"
  type        = number
  default     = 1024
}

variable "storage_info_ebs_storage_info_provisioned_throughput_enabled" {
  description = "Controls whether provisioned throughput is enabled or not. Default value: false"
  type        = bool
  default     = false
}

variable "storage_info_ebs_storage_info_provisioned_throughput_throughput" {
  description = "Throughput value of the EBS volumes for the data drive on each kafka broker node in MiB per second. The minimum value is 250. The maximum value varies between broker type."
  type        = number
  default     = 250
}

variable "ip_to_access_brokers" {
  description = "Ip allowed to access brokers"
  type        = any
  default     = ["10.0.0.0/8"]
}

#=~=~=~=~=~=~=~=~=~=
# KMS
#=~=~=~=~=~=~=~=~=~=

variable "create_kms_key" {
  description = "Set to true to create a KMS key for this cluster"
  type        = bool
  default     = false
}
variable "kms_policy" {
  description = "A valid policy JSON document. Although this is a key policy, not an IAM policy."
  type        = string
  default     = ""
}

variable "config" {
  description = "MSK cluster configuration, see Kafka server properties for valid options"
  type        = string
  default     = ""
}
variable "config_version" {
  description = "Bump this each time you modify the config or cluster version"
  type        = string
  default     = "7"
}

#=~=~=~=~=~=~=~=~=~=
# MSK CLUSTER ENCRYPTION INFO
#=~=~=~=~=~=~=~=~=~=


variable "client_broker_encryption" {
  description = "Encryption setting for data in transit between clients and brokers. Valid values: TLS, TLS_PLAINTEXT, and PLAINTEXT. Default value is TLS"
  type        = string
  default     = "TLS"
}



variable "enable_storage_autoscaling" {
  description = "Set to true to enable storage autoscaling"
  type        = bool
  default     = true
}
variable "scaling_max_capacity" {
  description = "Max allowed capacity in GiB of EBS Volume. This can be set up to 16 TiB per broker."
  type        = number
  default     = 5190
}

variable "scaling_target_value" {
  description = "Target value in percent for KafkaBrokerStorageUtilization metric to trigger storage scaling"
  type        = number
  default     = 60
}

# Tagging

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

variable "client_unauthenticated" {
  description = "Enables unauthenticated access."
  type        = bool
  default     = false
}

variable "certificate_authority_arns" {
  type        = list(string)
  default     = []
  description = "List of ACM Certificate Authority Amazon Resource Names (ARNs) to be used for TLS client authentication"
}

variable "client_sasl_scram_enabled" {
  description = "Enables SCRAM client authentication via AWS Secrets Manager (cannot be set to `true` at the same time as `client_tls_auth_enabled`)."
  type        = bool
  default     = false
}

variable "client_sasl_scram_secret_association_arns" {
  type        = list(string)
  default     = []
  description = "List of AWS Secrets Manager secret ARNs for scram authentication."
}

variable "client_sasl_iam_enabled" {
  description = "Enables client authentication via IAM policies (cannot be set to `true` at the same time as `client_sasl_scram_enabled`)."
  type        = bool
  default     = false
}

variable "client_tls_auth_enabled" {
  description = "Set `true` to enable the Client TLS Authentication"
  type        = bool
  default     = false
}

variable "allowed_ports" {
  type = map(number)
  default = {
    plain     = 9092
    tls       = 9094
    zookeeper = 2181
  }
  description = "A map of port numbers to allow on the cluster. If authentication is enabled this variable must be passed with the appropriate port numbers - Brokers = 9092 (plaintext), 9094 (TLS), 9096 (SASL/SCRAM), 9098 (IAM). Zookeeper = 2181 (plaintext), 2182 (TLS)"
}


variable "storage_mode" {
  description = "Set broker storage to be LOCAL or TIERED, requires kafka_version to have the .tiered suffix"
  type        = string
  default     = "TIERED"
}
