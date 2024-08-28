module "aws-load-balancer-controller" {
  source = "./modules/aws-load-balancer-controller"

  env              = var.env
  eks_cluster_name = var.eks_cluster_name
  project_name     = var.project_name
  #tags                  = local.default_tags_eks
  oidc_provider_arn     = module.eks.oidc_provider_arn
  eks_cluster_id        = module.eks.cluster_name
  resources_aws_account = var.resources_aws_account
  eec_boundary_policy   = data.aws_iam_policy.eec_boundary_policy.arn
  coststring            = var.coststring
  appid                 = var.appid

  depends_on = [
    helm_release.metrics-server
  ]
}
