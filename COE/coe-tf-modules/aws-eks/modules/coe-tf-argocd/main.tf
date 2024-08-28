/**
 * # Coe TF Argocd
 *
 * Install Argocd in their component 
 * 
 * ```hcl
 * module "coe-argocd" {
 *  source = "./modules/coe-tf-argocd"
 *
 *  env                               = var.env
 *  eks_cluster_name                  = var.eks_cluster_name
 *  project_name                      = var.project_name
 *  external_dns_domain               = var.external_dns_domain_filters[0]
 *  tags                              = local.default_tags
 *  oidc_provider_arn                 = module.eks.oidc_provider_arn
 *  auth_system_ldap_password         = var.auth_system_ldap_password
 *  eks_cluster_id                    = module.eks.cluster_id
 *  git_repository_url                = var.coe_argocd_git_repository_url
 *  git_repository_path               = var.coe_argocd_git_repository_path
 *  global_ssh_git_repository_url     = var.coe_argocd_global_ssh_git_repository_url
 *  git_repository_branch             = var.coe_argocd_git_repository_branch
 *  eks_namespace                     = var.coe_argocd_eks_namespace
 *  helm_version                      = var.coe_argocd_helm_version
 *  eks_cluster_ad_group_access_admin = var.eks_cluster_ad_group_access_admin
 *  eks_cluster_ad_group_access_view  = var.eks_cluster_ad_group_access_view
 *  resources_aws_account             = var.resources_aws_account
 *  oidc_dex_secret                   = random_password.oidc_argo_password.result
 *  auth_system_ldap_user             = var.auth_system_ldap_user
 *  auth_system_ldap_config           = var.auth_system_ldap_config
 *  dex_static_passwords_hash         = var.dex_static_passwords_hash
 *  argocd-app-installer_helm_version = var.argocd-app-installer_helm_version
 *
 *  depends_on = [
 *    helm_release.istio-gateway,
 *    helm_release.secrets-store-csi-driver-provider-aws
 *  ]
 * }
 * ```
 */
data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy" "eec_boundary_policy" {
  name = "BUAdminBasePolicy"
}

data "aws_ecr_authorization_token" "token" {
  registry_id = var.resources_aws_account
}

################################################################################
# Key Pair
################################################################################

resource "tls_private_key" "argocd-rsa-4096" {
  algorithm = "RSA"
  rsa_bits  = 2048
}


################################################################################
# ARGOCD
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

  argo_secret = {
    url           = var.global_ssh_git_repository_url
    sshPrivateKey = tls_private_key.argocd-rsa-4096.private_key_pem
  }

  grafana_callback_map = {
    "auto" = "https://monitoring-${substr(var.eks_cluster_name, 0, 27)}.${var.external_dns_domain}/login/generic_oauth"
  }

  grafana_auth = {
    secret = var.oidc_dex_secret_monitoring
  }

  argo_url = "https://deploy-${local.cluster_name_env}.${var.external_dns_domain}"
  auth_url = "https://auth-${local.cluster_name_env}.${var.external_dns_domain}/api/dex/"

  grafana_callback = lookup(local.grafana_callback_map, var.oidc_dex_callback_monitoring, var.oidc_dex_callback_monitoring)

  dex_static_passwords_config = <<EOF
enablePasswordDB: true

staticPasswords:
 - email: "sre@admin.com"
   hash: "${var.dex_static_passwords_hash}"
   username: "sre"
   userID: "63AAC7EC-DFF9-402F-9F5D-529185B94E25"
 EOF

  dex_static_passwords = var.dex_static_passwords_hash == "" ? "enablePasswordDB: false" : local.dex_static_passwords_config

}

################################################################################
# TRIGGERS
################################################################################

resource "null_resource" "dex_secret_manager" {
  triggers = {
    "secret_manager_version_id" = aws_secretsmanager_secret_version.cluster_dex_version.version_id
  }

}
