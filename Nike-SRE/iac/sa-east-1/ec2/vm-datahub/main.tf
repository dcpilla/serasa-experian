terraform {
  backend "s3" {
    key = "sa-east-1/ec2/vm-datahub/terraform.tfstate"
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
    "Project"        = "datahub"
    "Service"        = "latam_nike"
    "wiz_cig"        = "true"
  }
}

module "VM-DATAHUB" {
  source = "git::https://code.experian.local/scm/nikesre/terraform-ec2.git?ref=v1.1.3"

  env = local.common_tags.Environment
  
  instances = [
    {
      name                   = "VM-DATAHUB"
      ami_type               = "winsrv2022"
      instance_type          = "t3.xlarge"
      subnet_id              = "subnet-0702c5cd6296c292b"
      vpc_security_group_ids = ["sg-09ca15e82d010251b"]
      key_name               = "ds-prod-emr"
    }
  ]
}