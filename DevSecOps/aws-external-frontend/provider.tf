provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = var.aws_assume_role_arn
  }
}

terraform {
  backend "s3" {
    encrypt  = true
    bucket   = "cockpit-devsecops-states-@@AWS_ACCOUNT_ID@@"
    region   = "sa-east-1"
    key      = "aws-external-frontend/@@APP_NAME@@-@@ENVIRONMENT@@.tfstate"
    role_arn = "arn:aws:iam::@@AWS_ACCOUNT_ID@@:role/BURoleForDevSecOpsCockpitService"
  }
}
