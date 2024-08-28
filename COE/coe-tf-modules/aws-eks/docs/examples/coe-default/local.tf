locals {
  default_tags = {
    ManagedBy   = "Terraform"
    ClusterName = module.experian_eks.cluster_name
    Application = "EKS"
    Project     = "${var.project_name}"
    Environment = "${var.env}"
  }


  deploy_project_name = var.deploy_project_name == "" ? var.project_name : var.deploy_project_name
}
