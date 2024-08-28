
################################################################################
# IAM
################################################################################

output "iam_arn" {
  description = "ARN of the studio"
  value       = module.emr_studio_iam.arn
}

output "iam_url" {
  description = "The unique access URL of the Amazon EMR Studio"
  value       = module.emr_studio_iam.url
}

output "iam_service_iam_role_name" {
  description = "Service IAM role name"
  value       = module.emr_studio_iam.service_iam_role_name
}

output "iam_service_iam_role_arn" {
  description = "Service IAM role ARN"
  value       = module.emr_studio_iam.service_iam_role_arn
}

output "iam_service_iam_role_unique_id" {
  description = "Stable and unique string identifying the service IAM role"
  value       = module.emr_studio_iam.service_iam_role_unique_id
}

output "iam_service_iam_role_policy_arn" {
  description = "Service IAM role policy ARN"
  value       = module.emr_studio_iam.service_iam_role_policy_arn
}

output "iam_service_iam_role_policy_id" {
  description = "Service IAM role policy ID"
  value       = module.emr_studio_iam.service_iam_role_policy_id
}

output "iam_service_iam_role_policy_name" {
  description = "The name of the service role policy"
  value       = module.emr_studio_iam.service_iam_role_policy_name
}

output "iam_user_iam_role_name" {
  description = "User IAM role name"
  value       = module.emr_studio_iam.user_iam_role_name
}

output "iam_user_iam_role_arn" {
  description = "User IAM role ARN"
  value       = module.emr_studio_iam.user_iam_role_arn
}

output "iam_user_iam_role_unique_id" {
  description = "Stable and unique string identifying the user IAM role"
  value       = module.emr_studio_iam.user_iam_role_unique_id
}

output "iam_user_iam_role_policy_arn" {
  description = "User IAM role policy ARN"
  value       = module.emr_studio_iam.user_iam_role_policy_arn
}

output "iam_user_iam_role_policy_id" {
  description = "User IAM role policy ID"
  value       = module.emr_studio_iam.user_iam_role_policy_id
}

output "iam_user_iam_role_policy_name" {
  description = "The name of the user role policy"
  value       = module.emr_studio_iam.user_iam_role_policy_name
}

output "iam_engine_security_group_arn" {
  description = "Amazon Resource Name (ARN) of the engine security group"
  value       = module.emr_studio_iam.engine_security_group_arn
}

output "iam_engine_security_group_id" {
  description = "ID of the engine security group"
  value       = module.emr_studio_iam.engine_security_group_id
}

output "iam_workspace_security_group_arn" {
  description = "Amazon Resource Name (ARN) of the workspace security group"
  value       = module.emr_studio_iam.workspace_security_group_arn
}

output "iam_workspace_security_group_id" {
  description = "ID of the workspace security group"
  value       = module.emr_studio_iam.workspace_security_group_id
}
