################################################
## RDS
################################################
output "rds_address" {
  description = "The hostname of the RDS instance. See also endpoint and port."
  value       = try(aws_db_instance.rds_db.address, "")
}
output "rds_arn" {
  description = "The ARN of the RDS instance."
  value       = try(aws_db_instance.rds_db.arn, "")
}
output "rds_allocated_storage" {
  description = "The amount of allocated storage."
  value       = try(aws_db_instance.rds_db.allocated_storage, "")
}
output "rds_availability_zone" {
  description = "The availability zone of the instance."
  value       = try(aws_db_instance.rds_db.availability_zone, "")
}
output "rds_backup_retention_period" {
  description = "The backup retention period."
  value       = try(aws_db_instance.rds_db.backup_retention_period, "")
}
output "rds_backup_window" {
  description = "The backup window."
  value       = try(aws_db_instance.rds_db.backup_window, "")
}
output "rds_ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance."
  value       = try(aws_db_instance.rds_db.ca_cert_identifier, "")
}
output "rds_db_name" {
  description = "The database name."
  value       = try(aws_db_instance.rds_db.db_name, "")
}
output "rds_domain" {
  description = "The ID of the Directory Service Active Directory domain the instance is joined to"
  value       = try(aws_db_instance.rds_db.domain, "")
}
output "rds_domain_iam_role_name" {
  description = "The name of the IAM role to be used when making API calls to the Directory Service."
  value       = try(aws_db_instance.rds_db.domain_iam_role_name, "")
}
output "rds_endpoint" {
  description = "The connection endpoint in address:port format."
  value       = try(aws_db_instance.rds_db.endpoint, "")
}
output "rds_engine" {
  description = "The database engine."
  value       = try(aws_db_instance.rds_db.engine, "")
}
output "rds_engine_version_actual" {
  description = "The running version of the database."
  value       = try(aws_db_instance.rds_db.engine_version_actual, "")
}
output "rds_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)."
  value       = try(aws_db_instance.rds_db.hosted_zone_id, "")
}
output "rds_id" {
  description = "The RDS instance ID."
  value       = try(aws_db_instance.rds_db.id, "")
}
output "rds_instance_class" {
  description = "The RDS instance class."
  value       = try(aws_db_instance.rds_db.instance_class, "")
}
output "rds_latest_restorable_time" {
  description = "The latest time, in UTC RFC3339 format, to which a database can be restored with point"
  value       = try(aws_db_instance.rds_db.latest_restorable_time, "")
}
output "rds_maintenance_window" {
  description = "The instance maintenance window."
  value       = try(aws_db_instance.rds_db.maintenance_window, "")
}
output "rds_multi_az" {
  description = "If the RDS instance is multi AZ enabled."
  value       = try(aws_db_instance.rds_db.multi_az, "")
}
output "rds_name" {
  description = "The database name."
  value       = try(aws_db_instance.rds_db.db_name, "")
}
output "rds_port" {
  description = "The database port."
  value       = try(aws_db_instance.rds_db.port, "")
}
output "rds_resource_id" {
  description = "The RDS Resource ID of this instance."
  value       = try(aws_db_instance.rds_db.resource_id, "")
}
output "rds_status" {
  description = "The RDS instance status."
  value       = try(aws_db_instance.rds_db.status, "")
}
output "rds_storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted."
  value       = try(aws_db_instance.rds_db.storage_encrypted, "")
}
output "rds_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = try(aws_db_instance.rds_db.tags_all, "")
}
output "rds_username" {
  description = "The master username for the database."
  value       = try(aws_db_instance.rds_db.username, "")
}
output "rds_character_set_name" {
  description = "The character set (collation) used on Oracle and Microsoft SQL instances."
  value       = try(aws_db_instance.rds_db.character_set_name, "")
}

################################################
## kms
################################################

output "kms_rds_arn" {
  description = "The Amazon Resource Name (ARN) of the key."
  value       = local.kms_rds
}


output "palantir_informations" {
  description = "Palantir Information"
  value       = "As part of Data governance, it is needed to create a user inside your database with read-only permission to Palantir get information about the data hosted in it, for this access we will use IAM role that already was created in your AWS Account, now you need run the below query against the RDS created to grant the right access."
}

output "palantir_postgres_query" {
  description = "Palantir Query to create Palantir user"
  value       = "psql -h ${aws_db_instance.rds_db.endpoint} -U ${aws_db_instance.rds_db.username} -d ${aws_db_instance.rds_db.db_name}\nCREATE USER user_palantir_view WITH LOGIN;\nGRANT rds_iam TO user_palantir_view;"
}
