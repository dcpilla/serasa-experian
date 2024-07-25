# Define o provider de implementação e assumerole na conta
provider "aws" {
  region = "${var.region}"

  endpoints {
    sts = "https://sts.@@AWS_REGION@@.amazonaws.com"
  }

  assume_role {
    role_arn = "arn:aws:iam::@@AWS_ACCOUNT_ID@@:role/BURoleForDevSecOpsCockpitService"
  }
}

# Configuração para backend
terraform {
  required_version = ">= 1.0.1"

  backend "s3" {
    encrypt  = true
    bucket   = "cockpit-devsecops-states-@@AWS_ACCOUNT_ID@@"
    region   = "@@AWS_REGION@@"
    role_arn = "arn:aws:iam::@@AWS_ACCOUNT_ID@@:role/BURoleForDevSecOpsCockpitService"
    key      = "aws-stack-documentdb/@@TFSTATENAME@@.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.18.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.3.1"
    }
  }
}
