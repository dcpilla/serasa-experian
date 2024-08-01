terraform {
  backend "s3" {
    key = "sa-east-1/ecr/knnoa_docker_ecr/terraform.tfstate"
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
    "Asset_Category" = "Production"
    "AppID" = "25135"
    "CostString" = "1800.BR.134.602018"
    "CreateBy" = "Terraform"
    #      "Data_Category"  = "N/A"
    #      "Data_Type"      = "N/A"
    "Environment" = "prd"
    "Flow" = "operador"
    "map-migrated" = "d-server-02n52mmgua5hr6"
    "Name" = "knnoa_docker_ecr"
    "Project" = "datahub"
    "Service" = "latam_nike"
    "Solution" = "lambda_knnoa"
    "Squad" = "cadastral"
    "Sustain" = "true"
    "wiz_cig" = "true"
  }
}


module "knnoa_docker_ecr" {
  source = "git::https://code.experian.local/scm/nikesre/terraform-ecr.git?ref=v1.0.3"

  name = "knnoa_docker_ecr"
  env = local.common_tags.Environment
}
