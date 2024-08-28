# Creating a AWS secret manager to store database master account
resource "aws_secretsmanager_secret" "rds_secret" {
  name        = "secretManager-${var.application_name}-${var.env}-${module.experian_rds.rds_engine}"
  description = "Secret Manager to store credentials for access RDS"
  tags = {
    ManagedBy    = "Terraform",
    DatabaseName = module.experian_rds.rds_db_name,
    Project      = var.project_name
  }
}

resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = <<EOF
   {
    "username": "${module.experian_rds.rds_username}",
    "password": "${random_password.password.result}",
    "host": "${module.experian_rds.rds_endpoint}",
    "database": "${module.experian_rds.rds_db_name}",
    "port": "${module.experian_rds.rds_port}"
   }
EOF
}
