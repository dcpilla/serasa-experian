variable "topics" {
  type = map(object({
    name = string
    replication_factor = optional(number)
    partitions = optional(number)
    config = optional(map(string))
  }))
}

variable "default_replication_factor" {
  default = 2
}
variable "default_partitions" {
  default = 1
}
variable "default_config" {
  default = {
    "retention.ms"          = "-1"
    "cleanup.policy"        = "compact"
    "max.compaction.lag.ms" = "86400000"
  }
} 