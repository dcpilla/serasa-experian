terraform {
  backend "s3" {
    key = "sa-east-1/ECR/experian-cp-juridico-acesso-api/terraform.tfstate"
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
    "CreateBy"       = "Terraform"
    "Data_Category"  = "N/A"
    "Data_Type"      = "N/A"
    "Environment"    = "prod"
    "map-migrated"   = "d-server-02n52mmgua5hr6"
    "Project"        = "nike"
    "Service"        = "latam_nike"
    "wiz_cig"        = "true"
  }
}

module "experian-cp-juridico-acesso-api" {
  source = "git::https://code.experian.local/scm/nikesre/terraform-ecr.git?ref=v1.0.3"
 
  env    = local.common_tags.Environment
  name   = "experian-cp-juridico-acesso-api"
}