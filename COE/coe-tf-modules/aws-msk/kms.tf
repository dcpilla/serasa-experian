
#
# KMS key for encrypting the data at rest on the Kafka brokers.
#
resource "aws_kms_key" "encryption_at_rest" {
  count = var.create_kms_key ? 1 : 0

  description             = "KMS key for encrypting data stored on Kafka brokers."
  deletion_window_in_days = 30
  policy                  = var.kms_policy == "" ? data.aws_iam_policy_document.kms.json : var.kms_policy
  tags                    = local.default_tags
}

resource "aws_kms_alias" "msk_cluster" {
  count = var.create_kms_key ? 1 : 0

  name          = "alias/${var.project_name}-${var.application_name}-${var.name}-${var.env}-msk"
  target_key_id = aws_kms_key.encryption_at_rest[0].key_id
}
