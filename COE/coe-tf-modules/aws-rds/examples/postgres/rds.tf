data "aws_caller_identity" "current" {}


resource "random_password" "password" {
  length  = 16
  special = false
}


#Example for use production environment
module "experian_rds" {
  source = "git::https://code.experian.local/scm/esbt/coe-tf-modules.git//aws-rds?ref=aws-rds-v1.0.4"

  db_allocated_storage = var.db_allocated_storage
  # When the db_max_allocated_storage is higher than db_allocated_storage the 
  # storage autoscaling is enable
  db_max_allocated_storage   = var.db_max_allocated_storage
  db_iops                    = var.db_iops
  db_multi_az                = var.db_multi_az
  db_availability_zone       = format("%sa", var.aws_region)
  db_backup_retention_period = var.db_backup_retention_period
  db_backup_window           = var.db_backup_window
  db_engine                  = "postgres"
  db_engine_version          = "14.7"
  db_instance_class          = var.db_instance_class
  db_maintenance_window      = var.db_maintenance_window
  db_name                    = "amundsen"
  db_password                = random_password.password.result
  db_username                = "svc_amundsen"
  db_port                    = 5432
  db_security_group_ids      = [aws_security_group.one.id]
  application_name           = var.application_name
  kms_alias                  = "alias/aws/rds"
  aws_region                 = var.aws_region
  bu                         = "EITS"
  category_asset             = "Metadata"
  type_data                  = "PP"
  category_data              = "Behavioral"
  cost_string                = "1111.CC.222.3333333"
  app_id                     = "12345"  
}
