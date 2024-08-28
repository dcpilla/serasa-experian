data "aws_secretsmanager_secret_version" "secret" {
  secret_id = var.secret_id
}

provider "kafka" {
  bootstrap_servers = var.kafka_brokers
  skip_tls_verify   = false
  tls_enabled       = true
  #sasl_username     = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["username"]
  #sasl_password     = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["password"]
  #sasl_mechanism    = "scram-sha512"
}

module "topics" {
  source = "git::https://code.experian.local/scm/esbt/coe-tf-modules.git//kafka-topics?ref=kafka-topics-v0.0.1"

  topics = merge([for topic in var.topics :
    merge({
      "${topic.name}" = {
        name               = "${topic.name}"
        partitions         = "${topic.partitions}"
        replication_factor = "${topic.replication_factor}"
      }
    })
  ]...)
}
