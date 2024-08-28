/**
 * # AWS LOAD BALANCER CONTROLLER
 *
 * Install controller to manager load balancer from EKS cluster
 * 
 * ```hcl
 * module "aws-load-balancer-controller" {
 * source = "./modules/aws-load-balancer-controller"
 *
 * env                   = var.env
 * eks_cluster_name      = var.eks_cluster_name
 * project_name          = var.project_name
 * tags                  = local.default_tags
 * oidc_provider_arn     = module.eks.oidc_provider_arn
 * eks_cluster_id        = module.eks.cluster_id
 * resources_aws_account = var.resources_aws_account
 * eec_boundary_policy   = data.aws_iam_policy.eec_boundary_policy.arn
 *
 * depends_on = [
 *   helm_release.metrics-server
 * ]
 *}
 * ```
 */
data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_ecr_authorization_token" "token" {
  registry_id = var.resources_aws_account
}



################################################################################
# AWS LOAD BALANCER CONROLLER
################################################################################

locals {

  cluster_name_env = "${substr(var.eks_cluster_name, 0, 27)}-${var.env}"

  default_tags = merge({
    ManagedBy   = "Terraform"
    ClusterName = local.cluster_name_env
    Application = "EKS"
    Project     = "${var.project_name}"
    Environment = "${var.env}"
  }, var.tags)


}
