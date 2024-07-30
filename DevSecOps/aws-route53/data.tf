# TERRAFORM CONFIG 
#
terraform {
  required_version = ">= 1.0.1"

  backend "s3" {
    encrypt  = true
    bucket   = "devsecdevops-terraform-prd-tfstates"
    region   = "sa-east-1"
    key      = "jenkins/@@OM@@.tfstate"
    role_arn = "arn:aws:iam::707064604759:role/BURoleForDevSecOpsCockpitService"
  }
}

# AWS DATA
# 
provider "aws" {
  region = var.aws_region

  endpoints {
    sts = "https://sts.sa-east-1.amazonaws.com"
  }

  dynamic "assume_role" {
    for_each = toset(var.assume_role_arn != null ? ["fake"] : [])
    content {
      role_arn = var.assume_role_arn
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
