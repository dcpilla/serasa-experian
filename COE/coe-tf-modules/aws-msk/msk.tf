#
# Create an MSK cluster.
#
resource "aws_msk_cluster" "cluster" {
  cluster_name           = "${var.project_name}-${var.application_name}-${var.name}-${var.env}"
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_brokers
  storage_mode           = var.storage_mode
  enhanced_monitoring    = var.enhanced_monitoring

  configuration_info {
    arn      = aws_msk_configuration.kafka.arn
    revision = aws_msk_configuration.kafka.latest_revision
  }

  broker_node_group_info {
    instance_type   = var.instance_type
    client_subnets  = data.aws_subnets.experian.ids
    security_groups = [aws_security_group.msk.id]
    az_distribution = "DEFAULT"
    storage_info {
      ebs_storage_info {
        volume_size = var.storage_info_ebs_storage_info_volume_size
        dynamic "provisioned_throughput" {
          for_each = var.storage_info_ebs_storage_info_provisioned_throughput_enabled ? [1] : []
          content {
            enabled           = var.storage_info_ebs_storage_info_provisioned_throughput_enabled
            volume_throughput = var.storage_info_ebs_storage_info_provisioned_throughput_throughput
          }
        }
      }
    }
  }


  #
  # Can't get a clean terraform apply without specifying encryption at rest + KMS key:
  #
  #     https://github.com/terraform-providers/terraform-provider-aws/issues/10523
  #
  encryption_info {
    encryption_at_rest_kms_key_arn = var.create_kms_key ? aws_kms_key.encryption_at_rest[0].arn : data.aws_kms_key.kafka.arn

    encryption_in_transit {
      client_broker = var.client_broker_encryption
      in_cluster    = true
    }
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = true
      }
      node_exporter {
        enabled_in_broker = true
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = var.enable_cloudwatch_log_delivery
        log_group = var.enable_cloudwatch_log_delivery ? aws_cloudwatch_log_group.this[0].name : null
      }
      s3 {
        enabled = var.enable_s3_log_delivery
        bucket  = var.enable_s3_log_bucket
        prefix  = "${var.project_name}-${var.application_name}-${var.name}-${var.env}/msk-"
      }
    }
  }

  dynamic "client_authentication" {
    for_each = var.client_unauthenticated || var.client_tls_auth_enabled || var.client_sasl_scram_enabled || var.client_sasl_iam_enabled ? [1] : []
    content {
      unauthenticated = var.client_unauthenticated
      dynamic "tls" {
        for_each = var.client_tls_auth_enabled ? [1] : []
        content {
          certificate_authority_arns = var.certificate_authority_arns
        }
      }
      dynamic "sasl" {
        for_each = var.client_sasl_scram_enabled || var.client_sasl_iam_enabled ? [1] : []
        content {
          scram = var.client_sasl_scram_enabled
          iam   = var.client_sasl_iam_enabled
        }
      }
    }
  }
  tags = local.default_tags

  lifecycle {
    ignore_changes = [
      broker_node_group_info[0].storage_info[0].ebs_storage_info[0].volume_size # to account for when the disk has autoscaled up
    ]
  }
}


# NOTE: when updating kafka config, the version number needs to be bumped
resource "aws_msk_configuration" "kafka" {
  kafka_versions    = [var.kafka_version]
  name              = "${local.full_name}-v${var.config_version}" # <- bump on change
  server_properties = var.config

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_cloudwatch_log_group" "this" {
  count = var.enable_cloudwatch_log_delivery ? 1 : 0
  name  = var.name
}

# NOTE: When the service detects that your Maximum Disk Utilization metric
# is equal to or greater than the Storage Utilization Target setting,
# it will increase your storage capacity automatically.
# Amazon MSK first expands your cluster storage by an amount equal to the
# larger of two numbers: 10 GiB and 10% of current storage.
# For example, if you have 1000 GiB, that amount is 100 GiB.
# Further scaling operations increase storage by a greater amount.
# The service checks your storage utilization every minute.

resource "aws_appautoscaling_target" "kafka_storage" {
  count              = var.enable_storage_autoscaling ? 1 : 0
  max_capacity       = var.scaling_max_capacity
  min_capacity       = 1 # Min capacity doesn't matter because we cannot scale down
  resource_id        = aws_msk_cluster.cluster.arn
  scalable_dimension = "kafka:broker-storage:VolumeSize"
  service_namespace  = "kafka"
}

resource "aws_appautoscaling_policy" "kafka_broker_scaling_policy" {
  count              = var.enable_storage_autoscaling ? 1 : 0
  name               = "${var.env}-${var.name}-broker-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_msk_cluster.cluster.arn
  scalable_dimension = aws_appautoscaling_target.kafka_storage[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.kafka_storage[count.index].service_namespace

  target_tracking_scaling_policy_configuration {
    disable_scale_in = true

    predefined_metric_specification {
      predefined_metric_type = "KafkaBrokerStorageUtilization"
    }

    target_value = var.scaling_target_value
  }
}

resource "aws_msk_scram_secret_association" "kafka_scram_secret_association" {
  count = var.client_sasl_scram_enabled ? 1 : 0

  cluster_arn     = aws_msk_cluster.cluster.arn
  secret_arn_list = var.client_sasl_scram_secret_association_arns
}
