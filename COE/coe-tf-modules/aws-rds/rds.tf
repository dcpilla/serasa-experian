data "aws_caller_identity" "current" {}

locals {
  db_storage_type      = var.db_iops != 0 ? "io1" : var.db_storage_type
  db_availability_zone = var.db_multi_az ? "" : var.db_availability_zone != "" ? var.db_availability_zone : "${var.aws_region}-1a"
}

resource "aws_db_subnet_group" "rds_db_subnet_group" {
  name        = "subnet-group-${var.application_name}-${var.project_name}-${var.db_engine}"
  description = "DB subnet group for ${var.application_name}-${var.project_name}-${var.db_engine}"
  subnet_ids  = data.aws_subnets.subnets_rds.ids
}

resource "aws_db_instance" "rds_db" {
  allocated_storage                     = var.db_allocated_storage
  allow_major_version_upgrade           = var.db_allow_major_version_upgrade
  auto_minor_version_upgrade            = var.db_auto_minor_version_upgrade
  apply_immediately                     = var.db_apply_immediately
  backup_retention_period               = var.db_backup_retention_period
  backup_window                         = var.db_backup_window
  db_subnet_group_name                  = aws_db_subnet_group.rds_db_subnet_group.id
  deletion_protection                   = var.db_deletion_protection
  copy_tags_to_snapshot                 = true
  engine                                = var.db_engine
  engine_version                        = var.db_engine_version
  identifier                            = "${var.application_name}${var.project_name}-${var.db_engine}"
  instance_class                        = var.db_instance_class
  kms_key_id                            = local.kms_rds
  maintenance_window                    = var.db_maintenance_window
  max_allocated_storage                 = var.db_max_allocated_storage
  multi_az                              = var.db_multi_az
  availability_zone                     = local.db_availability_zone
  monitoring_interval                   = var.db_monitoring_interval
  db_name                               = var.db_name
  password                              = var.db_password
  username                              = var.db_username
  port                                  = var.db_port
  publicly_accessible                   = false
  storage_encrypted                     = true
  storage_type                          = local.db_storage_type
  skip_final_snapshot                   = var.db_skip_final_snapshot
  iops                                  = var.db_iops
  performance_insights_enabled          = var.db_performance_insights_enabled
  performance_insights_kms_key_id       = var.db_performance_insights_kms_key_id
  performance_insights_retention_period = var.db_performance_insights_retention_period
  iam_database_authentication_enabled   = var.db_iam_database_authentication_enabled
  tags = merge(var.db_tags,
    {
      BU             = var.bu,
      CategoryAsset  = var.category_asset,
      Asset_Category = var.category_asset,
      TypeData       = var.type_data
      Data_Type      = var.type_data
      CategoryData   = var.category_data
      Data_Category  = var.category_data
    }
  )

  vpc_security_group_ids = compact(flatten(var.db_security_group_ids))
}
