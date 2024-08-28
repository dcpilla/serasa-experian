module "coe-argocd" {
  source = "./modules/coe-tf-argocd"

  env                 = var.env
  eks_cluster_name    = var.eks_cluster_name
  project_name        = var.project_name
  external_dns_domain = var.external_dns_domain_filters[0]
  aws_account_id      = tostring(data.aws_caller_identity.current.account_id)
  #tags                              = local.default_tags
  oidc_provider_arn                 = module.eks.oidc_provider_arn
  auth_system_ldap_password         = var.auth_system_ldap_password
  eks_cluster_id                    = module.eks.cluster_id
  git_repository_url                = var.coe_argocd_git_repository_url
  git_repository_path               = var.coe_argocd_git_repository_path
  global_ssh_git_repository_url     = var.coe_argocd_global_ssh_git_repository_url
  git_repository_branch             = var.coe_argocd_git_repository_branch
  eks_namespace                     = var.coe_argocd_eks_namespace
  helm_version                      = var.coe_argocd_helm_version
  eks_cluster_ad_group_access_admin = var.eks_cluster_ad_group_access_admin
  eks_cluster_ad_group_access_view  = var.eks_cluster_ad_group_access_view
  resources_aws_account             = var.resources_aws_account
  oidc_dex_secret                   = random_password.oidc_argo_password.result
  oidc_dex_secret_monitoring        = random_password.oidc_monitoring_password.result
  auth_system_ldap_user             = var.auth_system_ldap_user
  auth_system_ldap_config           = var.auth_system_ldap_config
  dex_static_passwords_hash         = var.dex_static_passwords_hash
  argocd-app-installer_helm_version = var.argocd-app-installer_helm_version
  oidc_dex_callback_monitoring      = var.oidc_dex_grafana_callback_monitoring

  depends_on = [
    helm_release.istio-gateway,
    helm_release.secrets-store-csi-driver-provider-aws
  ]
}
