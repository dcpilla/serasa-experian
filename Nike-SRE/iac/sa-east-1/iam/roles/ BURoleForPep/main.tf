terraform {
  backend "s3" {
    key = "sa-east-1/iam/roles/BURoleForPep/terraform.tfstate"
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
    "AppID" = "N/A"
    "CostString" = "1800.BR.134.602018"
    "CreateBy" = "Terraform"
    "Data_Category" = "N/A"
    "Data_Type" = "N/A"
    "Environment" = "prod"
    "map-migrated" = "d-server-02n52mmgua5hr6"
    "Project" = "datahub"
    "Service" = "latam_nike"
    "wiz_cig" = "true"
  }
}

module "policy_access" {
  source = "git::https://code.experian.local/scm/nikesre/terraform-iam-policy.git?ref=v1.0.3"

  env = local.common_tags.Environment
  name = "BUPolicyForPepCross"
  policy = file("policy.json")
}

module "BURoleForConsentimentAcess" {
  source = "git::https://code.experian.local/scm/nikesre/terraform-iam-role.git?ref=v1.0.4"

  env = local.common_tags.Environment
  name = "PEPAcess"
  assume_role_policy = file("role.json")
  policy_arns = [
    {
      arn = "${module.policy_access.iam_policy_id}"
    }
  ]

  depends_on = [
    module.policy_access]
}
