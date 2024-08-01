terraform {
  backend "s3" {
    key = "sa-east-1/sqs/datahub_data_contacts_pj/terraform.tfstate"
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
    "Data_Category" = "N/A"
    "Data_Type" = "N/A"
    "Environment" = "prod"
    "Flow" = "controlador"
    "map-migrated" = "d-server-02n52mmgua5hr6"
    "Name" = "datahub_data_contacts_pj"
    "Project" = "datahub"
    "Service" = "latam_nike"
    "Solution" = "mvp_contatos"
    "Squad" = "cadastral"
    "Sustain" = "true"
    "wiz_cig" = "true"
  }
}

module "datahub_data_contacts_pj" {
  source = "git::https://code.experian.local/scm/nikesre/terraform-sqs.git?ref=v1.1.5"

  env = local.common_tags.Environment
  name = "datahub_data_contacts_pj"
}