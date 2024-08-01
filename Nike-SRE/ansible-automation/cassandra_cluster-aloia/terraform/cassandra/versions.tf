# Configure AWS Provider
terraform {
  required_version = ">= 1.0.1"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.37.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 2.2"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
    external = {
      source = "hashicorp/external"
      version = ">= 2.2.2"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
