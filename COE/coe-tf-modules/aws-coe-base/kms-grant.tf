resource "aws_kms_grant" "grant_auto_scaling_group" {
  name              = "create-grant-auto-scaling-group"
  key_id            = local.eec_kms[var.aws_region]
  grantee_principal = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
  operations = [
    "Encrypt", "Decrypt", "ReEncryptFrom", "ReEncryptTo", "GenerateDataKey", "GenerateDataKeyWithoutPlaintext", "DescribeKey", "CreateGrant"
  ]
  depends_on = [
    aws_autoscaling_group.aws-base
  ]
}
