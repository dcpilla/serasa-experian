terraform {
  required_version = ">= 1.0.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.22.0"
    }
    git = {
      source  = "metio/git"
      version = "2023.2.3"
    }
  }
}
