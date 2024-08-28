
output "s3_tf_state" {
  description = "Name of S3 to store TF state"
  value       = module.aws_coe_base.s3_tf_state
}

output "s3_default_logs" {
  description = "Name of S3 to store TF state"
  value       = module.aws_coe_base.s3_default_logs
}
output "key_name" {
  description = "AWS Key pair name"
  value       = module.aws_coe_base.key_name
}

output "aws_autoscaling_group_role_arn" {
  description = "Auto Scaling Group ARN Role"
  value       = module.aws_coe_base.aws_autoscaling_group_role_arn
}

output "BURoleForDevelopersAccess_arn" {
  description = "ARN for BURoleForDevelopersAccess"
  value       = try(module.aws_coe_base.BURoleForDevelopersAccess_arn, "none")
}

output "BURoleForSRE_arn" {
  description = "ARN for BURoleForSRE - Grant cross account access from infra account"
  value       = module.aws_coe_base.BURoleForSRE_arn
}

output "BURoleForBillingAccess_arn" {
  description = "ARN for BURoleForBillingAccess - Grant access to Finance BU Team"
  value       = module.aws_coe_base.BURoleForBillingAccess_arn
}
output "BURoleForSNSLog_arn" {
  description = "ARN for BURoleForSNSLog - IAM role for successful and failed deliveries"
  value       = module.aws_coe_base.BURoleForSNSLog_arn
}
