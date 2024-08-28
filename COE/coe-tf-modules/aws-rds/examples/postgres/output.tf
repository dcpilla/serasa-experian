output "rds_endpoint" {
  description = "The connection endpoint in address:port format."
  value       = module.experian_rds.rds_endpoint
}

output "rds_db_name" {
  description = "The database name."
  value       = try(module.experian_rds.rds_db_name, "")
}

output "rds_username" {
  description = "The master username for the database."
  value       = try(module.experian_rds.rds_username, "")
}

output "aws_secretsmanager_secret_version_arn" {
  description = "You can get the RDS password at this AWS Secret Manage ARN"
  value       = aws_secretsmanager_secret_version.sversion.arn
}
