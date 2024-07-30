terraform {
  backend "s3" {
    bucket         = "tfstate-564593125549-sa-east-1-prod"
    region         = "sa-east-1"
    encrypt        = true
    dynamodb_table = "tf-lock-564593125549-sa-east-1-prod"
    key            = "atlantis-corporateprod/terraform.tfstate"
    profile        = "corporateprod"
  }
}