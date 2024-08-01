terraform {
  backend "s3" {
    key = "sa-east-1/s3/experian-sre-emr-bootstrap-662860092544/terraform.tfstate"
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

module "experian-sre-emr-bootstrap-662860092544" {
 source = "git::https://code.br.experian.local/scm/nikesre/terraform-s3.git?ref=v1.6.4"

  env         = local.common_tags.Environment
  bucket_name = "experian-sre-emr-bootstrap-662860092544"
  payer       = "Requester" 
  bucket_policy_created = true
  bucket_policy         = file("bucket_policy.json")  
}
