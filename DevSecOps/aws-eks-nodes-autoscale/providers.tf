provider "aws" {
  region  = var.aws_region

  endpoints {
    sts = "https://sts.@@AWS_REGION@@.amazonaws.com"
  }

  assume_role {
    role_arn = "arn:aws:iam::@@AWS_ACCOUNT_ID@@:role/BURoleForDevSecOpsCockpitService"
  }
}

terraform {
  required_version = ">= 1.0.1"

  backend "s3" {
    encrypt  = true
    bucket   = "cockpit-devsecops-states-@@AWS_ACCOUNT_ID@@"
    region   = "@@AWS_REGION@@"
    role_arn = "arn:aws:iam::@@AWS_ACCOUNT_ID@@:role/BURoleForDevSecOpsCockpitService"
    key      = "aws-eks-nodes-autoscale/@@EKS_CLUSTER_NAME@@.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.59.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.5.0"
    }
  }
}
