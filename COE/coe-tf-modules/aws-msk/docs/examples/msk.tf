module "coe-msk" {
  source                  = "../.."
  env                     = "dev"
  name                    = "chronos"
  kafka_version           = "2.8.1"
  number_of_brokers       = 3
  instance_type           = "kafka.m5.large"
  enable_s3_log_delivery  = true
  enable_s3_log_bucket    = "serasaexperian-coe-data-platform-dev-logs"
  client_sasl_iam_enabled = true
  tags                    = merge(local.default_tags, local.default_mutables_tags)
}
