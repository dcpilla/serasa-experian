
locals {
  kms_rds   = try(aws_kms_key.rds_kms[0].arn, data.aws_kms_alias.kms_rds.target_key_arn)
  kms_alias = var.kms_alias == "" ? "alias/aws/rds" : var.kms_alias
}

data "aws_kms_alias" "kms_rds" {
  name = local.kms_alias
}

resource "aws_kms_key" "rds_kms" {
  description             = "${upper(var.project_name)}-RDS"
  deletion_window_in_days = var.kms_deletion_window_in_days
  enable_key_rotation     = true
  tags = {
    "typeUse" = "RDS"
  }
  policy = <<EOF
{
    "Id": "${var.project_name}-eks-policy-1",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
                ],
                "Service": "rds.amazonaws.com"
            },
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
}
EOF
  count  = var.kms_alias == "" ? 1 : 0
}
