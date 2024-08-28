terraform {
  required_version = ">= 1.0.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.73.0"
    }
    # https://github.com/helm/helm/issues/10975
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
  }
}
