variable "kafka_brokers" {
  description = "Kafka bootstrap broker URLs"
  type        = list(string)
}

variable "secret_id" {
  description = "Secret id used for communicating with the MSK cluster"
  type        = string
}

variable "topics" {
  description = "Topic name, generation, and properties"
  type = set(object({
    name               = string
    partitions         = number
    replication_factor = number
  }))
}