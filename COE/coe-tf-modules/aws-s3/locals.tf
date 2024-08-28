locals {

  default_tags = merge({
    ManagedBy   = "Terraform"
    Application = var.application_name
    Project     = var.project_name
    Environment = var.env
    BU          = var.bu_name
  }, var.tags)
  

}
