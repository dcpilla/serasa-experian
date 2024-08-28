terraform {
  experiments = [module_variable_optional_attrs]
}

resource "kafka_topic" "this" {
  for_each           = var.topics

  name               = each.value.name
  replication_factor = coalesce(each.value.replication_factor, var.default_replication_factor)
  partitions         = coalesce(each.value.partitions, var.default_partitions)
  config = merge(var.default_config, lookup(each.value, "config", {}))
}
