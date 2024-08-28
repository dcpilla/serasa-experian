################################################
## SECRETS MANAGER
################################################

output "sm_id" {
  description = "ARN of the secret"
  value       = try(aws_secretsmanager_secret.this.id, "")
}

output "sm_arn" {
  description = "ARN of the secret"
  value       = try(aws_secretsmanager_secret.this.arn, "")
}

output "sm_rotation_enabled" {
  description = "Whether automatic rotation is enabled for this secret."
  value       = try(aws_secretsmanager_secret.this.rotation_enabled, "")
}

output "sm_replica" {
  description = "Replica Status"
  value       = try(aws_secretsmanager_secret.this.replica, "")
}

################################################
## SECRETS MANAGER VERSION
################################################

output "smv_arn" {
  description = "The ARN of the secret."
  value       = try(aws_secretsmanager_secret_version.this.arn, "")
}
output "smv_id" {
  description = "A pipe delimited combination of secret ID and version ID."
  value       = try(aws_secretsmanager_secret_version.this.id, "")
}
output "smv_version_id" {
  description = "The unique identifier of the version of the secret."
  value       = try(aws_secretsmanager_secret_version.this.version_id, "")
}

