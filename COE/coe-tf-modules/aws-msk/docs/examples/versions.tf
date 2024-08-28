terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.40.0"
    }
    git = {
      source  = "metio/git"
      version = "2023.2.3"
    }
  }
  required_version = ">= 0.13"
}
