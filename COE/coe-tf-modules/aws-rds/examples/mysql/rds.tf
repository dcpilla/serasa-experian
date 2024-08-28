data "aws_caller_identity" "current" {}


resource "random_password" "password" {
  length  = 16
  special = false
}

module "experian_rds" {
  source = "git::https://code.experian.local/scm/esbt/coe-tf-modules.git//aws-rds?ref=aws-rds-v1.0.0"

  db_allocated_storage       = 40
  db_max_allocated_storage   = 60
  db_backup_retention_period = 7
  db_availability_zone       = "sa-east-1b"
  db_backup_window           = "22:00-23:00"
  db_engine                  = "mysql"
  db_engine_version          = "8.0"
  db_instance_class          = "db.m5.large"
  db_maintenance_window      = "Sun:00:00-Sun:02:00"
  db_name                    = "amundsen"
  db_password                = random_password.password.result
  db_username                = "svc_amundsen"
  db_port                    = 3306
  db_security_group_ids      = [aws_security_group.one.id]
  application_name           = var.application_name
  # When we comment the below line the module will create a new KMS for us
  #kms_alias                  = "alias/aws/rds"
  aws_region     = var.aws_region
  bu             = "EITS"
  category_asset = "Metadata"
  type_data      = "PP"
  category_data  = "Behavioral"
}
