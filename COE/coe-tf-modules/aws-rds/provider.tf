provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Name        = "rds-${var.application_name}-${var.project_name}-${var.db_name}-${var.db_engine}"
      Application = "${var.application_name}"
      Project     = "${var.project_name}"
      Environment = "${var.env}"
      CostString  = "${var.cost_string}"
      AppID       = "${var.app_id}"
    }
  }
}
