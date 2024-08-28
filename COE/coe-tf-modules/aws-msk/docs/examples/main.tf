

data "aws_kms_key" "kafka" {
  key_id = "alias/aws/kafka"
}

