
resource "aws_secretsmanager_secret" "this" {
  name                    = lower("secretManager-${var.application_name}-${var.env}")
  description             = var.sm_description
  kms_key_id              = var.sm_kms_key_id
  name_prefix             = var.sm_name_prefix
  policy                  = try(var.sm_policy, null)
  recovery_window_in_days = var.sm_recovery_window_in_days

  # Due Experian Restrition we can`t have multi region resources
  # replica {
  #   region     = var.aws_region
  #   kms_key_id = try(var.sm_kms_key_id, "aws/secretsmanager")
  # }

  force_overwrite_replica_secret = var.sm_force_overwrite_replica_secret

  tags = local.default_tags
}


resource "aws_secretsmanager_secret_version" "this" {
  secret_id      = aws_secretsmanager_secret.this.id
  secret_string  = var.smv_secret_string
  secret_binary  = var.smv_secret_binary
  version_stages = try(var.smv_version_stages, [])
}
