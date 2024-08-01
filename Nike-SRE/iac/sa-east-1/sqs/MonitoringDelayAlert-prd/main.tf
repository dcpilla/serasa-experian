terraform {
  backend "s3" {
    key = "sa-east-1/sqs/MonitoringDelayAlert-prd/terraform.tfstate"
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

module "MonitoringDelayAlert_prd" {
  source = "git::https://code.experian.local/scm/nikesre/terraform-sqs.git?ref=v1.2.2"
  
  env  = local.common_tags.Environment
  name = "MonitoringDelayAlert-prd"
}