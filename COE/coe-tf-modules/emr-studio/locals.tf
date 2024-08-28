locals {
  
   default_tags = var.team != "" ? {
    ManagedBy   = "Terraform"
    Application = "${var.application_name}"
    Project     = "${var.project_name}"
    Environment = "${var.env}"
    CostString = "${var.cost_string}"
    AppID = "${var.gearr_id}"
    Team        = "${var.team}"
  } : {
    ManagedBy   = "Terraform"
    Application = "${var.application_name}"
    Project     = "${var.project_name}"
    Environment = "${var.env}"
    CostString = "${var.cost_string}"
    AppID = "${var.gearr_id}"
    AppID = "${var.gearr_id}"
  }

  data_cluster_workspace_metadata_tags = {
    Asset_Category  = var.emr_studio_bucket_category
    Data_Category   = "Metadata"
    Data_Type       = "NA"
    Asset_Category  = var.emr_studio_bucket_category
    Data_Category   = "Metadata"
    Data_Type       = "NA"
  }
  
  data_cloudformation_metadata_tags = {
    Asset_Category  = "Metadata"
    Data_Category   = "Metadata"
    Data_Type       = "NA"
    Asset_Category  = "Metadata"
    Data_Category   = "Metadata"
    Data_Type       = "NA"
  }
}

