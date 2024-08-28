locals {


  default_tags = merge({
    ManagedBy   = "Terraform"
    Application = "${var.application_name}"
    Project     = "${var.project_name}"
    Environment = "${var.env}"
  }, try(var.tags))


  full_name = "${var.name}-${var.env}"
}
