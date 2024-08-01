terraform {
  backend "s3" {
    key = "sa-east-1/secrets-manager/sm_sftp_cerc_operador/terraform.tfstate"
  }
}

provider "aws" {
  region = "sa-east-1"
  profile = "dsprod"
  default_tags {
    tags = local.common_tags
  }
}

locals {
  common_tags = {
    "Asset_Category" = "Production"
    "AppID"          = "19558"
    "CostString"     = "1800.BR.100.404506"
    "Squad"          = "cross"
    "CreateBy"       = "Terraform"
    "Data_Category"  = "N/A"
    "Data_Type"      = "N/A"
    "Environment"    = "prod"
    "map-migrated"   = "d-server-02n52mmgua5hr6"
    "Project"        = "datahub"
    "Service"        = "latam_nike"
    "wiz_cig"        = "true"
  }
}

module "sm_sftp_cerc_operador" {
  source = "git::https://code.experian.local/scm/nikesre/terraform-secrets-manager.git?ref=v1.0.5"

  env                     = local.common_tags.Environment
  name                    = "sm_sftp_cerc_operador"
  secret_string           = "sZbY575@"
  role_arns               = ["662860092544"]
}