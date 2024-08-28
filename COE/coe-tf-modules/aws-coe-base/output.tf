
output "s3_tf_state" {
  description = "Name of S3 to store TF state"
  value       = aws_s3_bucket.tf_state.bucket
}

output "s3_default_logs" {
  description = "Name of S3 to store Logs"
  value       = aws_s3_bucket.logs_bucket.bucket
}

output "key_name" {
  description = "AWS Key pair name"
  value       = try(aws_key_pair.mlcoe[0].key_name, "")
}

output "aws_autoscaling_group_role_arn" {
  description = "Auto Scaling Group ARN Role"
  value       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
}

output "BURoleForDevelopersAccess_arn" {
  description = "ARN for BURoleForDevelopersAccess"
  value       = try(aws_iam_role.BURoleForDevelopersAccess[0].arn, "none")
}

output "BURoleForSRE_arn" {
  description = "ARN for BURoleForSRE - Grant cross account access from infra account"
  value       = aws_iam_role.BURoleForSRE.arn
}

output "BURoleForBillingAccess_arn" {
  description = "ARN for BURoleForBillingAccess - Grant access to Finance BU Team"
  value       = aws_iam_role.BURoleForBillingAccess.arn
}
output "BURoleForSNSLog_arn" {
  description = "ARN for BURoleForSNSLog - IAM role for successful and failed deliveries"
  value       = aws_iam_role.BURoleForSNSLog.arn
}
