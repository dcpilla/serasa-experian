terraform {
  backend "s3" {
    key = "sa-east-1/s3/experian-datahub-negativos-silver-prod/terraform.tfstate"
    profile = "dsprod"
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
    "Asset_Category" = "Productive data"
    "AppID"          = "19558"
    "CostString"     = "1800.BR.100.404506"
    "cost-map-by-layer" = "DcF_layer_silver_by_type"
    "cost_map_segregated_dataset_all_services" = "DcF_negativos"
    "cost_map_segregated_dataset" = "s3_DcF_negativos"
    "cost-map-nike-layer" = "s3_DcF_silver"
    "cost-map-nike-unit" = "s3_DcF_experian-datahub-negativos-silver-prod"
    "cost_map_segregated_layer_dataset" = "s3_DcF_silver_negativos"
    "Squad" = "DcF"
    "cost-map-nike-team" = "DcF"
    "CreateBy"       = "Terraform"
    "Data_Category"  = "Negative"
    "Data_Type"      = "PP/LP"
    "Environment"    = "prd"
    "map-migrated"   = "d-server-02n52mmgua5hr6"
    "Project"        = "nike"
    "Service"        = "latam_nike"
    "wiz_cig"        = "true"
  }
}

module "experian_datahub_negativos_silver_prod" {
  source = "git::https://code.experian.local/scm/nikesre/terraform-s3.git?ref=v1.2.8"

  env         = local.common_tags.Environment
  bucket_name = "experian-datahub-negativos-silver-prod"
}
