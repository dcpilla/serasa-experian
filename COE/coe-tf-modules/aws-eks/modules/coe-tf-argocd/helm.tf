resource "helm_release" "coe-argocd" {
  name                = "coe-argocd"
  repository          = format("oci://%s.dkr.ecr.sa-east-1.amazonaws.com", var.resources_aws_account)
  chart               = "coe-argocd"
  version             = var.helm_version
  namespace           = var.eks_namespace
  repository_username = data.aws_ecr_authorization_token.token.user_name
  repository_password = data.aws_ecr_authorization_token.token.password
  force_update        = true
  create_namespace    = true
  max_history         = 7
  wait                = false
  values = [
    "${templatefile(
      "${path.module}/templates/coe-argo-values.tftpl",
      {
        "env"                          = "${var.env}"
        "project_name"                 = "${var.project_name}"
        "eks_cluster_name"             = "${var.eks_cluster_name}"
        "external_dns_domain"          = "${var.external_dns_domain}"
        "secretManager"                = "${aws_secretsmanager_secret.cluster_argocd.name}"
        "timestamp"                    = "${timestamp()}"
        "role"                         = "${aws_iam_role.BURoleForDeployAccessSecretsManager.arn}"
        "argoUrl"                      = "${local.argo_url}"
        "authUrl"                      = "${local.auth_url}"
        "oidcDexSecret"                = "${var.oidc_dex_secret}"
        "eksClusterAdGroupAccessView"  = "${var.eks_cluster_ad_group_access_view}"
        "eksClusterAdGroupAccessAdmin" = "${var.eks_cluster_ad_group_access_admin}"
      }
    )}"
  ]

  depends_on = [
    aws_secretsmanager_secret.cluster_argocd,
    aws_secretsmanager_secret.cluster_dex
  ]
}

resource "helm_release" "coe-argo-rollout" {
  name                = "argo-rollouts"
  repository          = format("oci://%s.dkr.ecr.sa-east-1.amazonaws.com", var.resources_aws_account)
  chart               = "argo-rollouts"
  version             = var.argo-rollouts_helm_version
  namespace           = var.eks_namespace
  repository_username = data.aws_ecr_authorization_token.token.user_name
  repository_password = data.aws_ecr_authorization_token.token.password
  force_update        = true
  create_namespace    = true
  max_history         = 7
  wait                = false
  values = [
    "${templatefile(
      "${path.module}/templates/argo-rollout-values.tftpl",
      {
        "repository" = "${format("%s.dkr.ecr.sa-east-1.amazonaws.com", var.resources_aws_account)}"
      }
    )}"
  ]

  depends_on = [
    helm_release.coe-argocd
  ]
}

resource "helm_release" "coe-dex" {
  name                = "coe-dex"
  repository          = format("oci://%s.dkr.ecr.sa-east-1.amazonaws.com", var.resources_aws_account)
  chart               = "coe-dex"
  version             = var.dex_helm_version
  namespace           = var.dex_eks_namespace
  repository_username = data.aws_ecr_authorization_token.token.user_name
  repository_password = data.aws_ecr_authorization_token.token.password
  force_update        = true
  create_namespace    = true
  max_history         = 7
  wait                = false
  values = [
    "${templatefile(
      "${path.module}/templates/dex-values.tftpl",
      {
        "host"            = "${format("auth-%s.%s", local.cluster_name_env, var.external_dns_domain)}"
        "secretManager"   = "${aws_secretsmanager_secret.cluster_dex.name}"
        "repository"      = "${format("%s.dkr.ecr.sa-east-1.amazonaws.com/dexidp/dex", var.resources_aws_account)}"
        "role"            = "${aws_iam_role.BURoleForDexAccessSecretsManager.arn}"
        "secretManagerId" = "${aws_secretsmanager_secret_version.cluster_dex_version.id}"
      }
    )}"
  ]

  depends_on = [
    helm_release.coe-argocd
  ]
}

resource "helm_release" "argocd-app-installer" {
  name                = "argocd-app-installer"
  repository          = format("oci://%s.dkr.ecr.sa-east-1.amazonaws.com", var.resources_aws_account)
  chart               = "argocd-app-installer"
  version             = var.argocd-app-installer_helm_version
  namespace           = var.eks_namespace
  repository_username = data.aws_ecr_authorization_token.token.user_name
  repository_password = data.aws_ecr_authorization_token.token.password
  force_update        = true
  create_namespace    = true
  max_history         = 7
  wait                = false
  values = [
    "${templatefile(
      "${path.module}/templates/argocd-app-installer-values.tftpl",
      {
        "env"                   = "${var.env}"
        "eks_cluster_name"      = "${var.eks_cluster_name}"
        "external_dns_domain"   = "${var.external_dns_domain}"
        "aws_account_id"        = "${var.aws_account_id}"
        "project_name"          = "${var.project_name}"
        "git_repository_path"   = "${var.git_repository_path}"
        "git_repository_url"    = "${var.git_repository_url}"
        "git_repository_branch" = "${var.git_repository_branch}"
        "monitoring_asm"        = "${aws_secretsmanager_secret.grafana_auth.name}"
        "monitoring_role"       = "${aws_iam_role.BURoleForMonitoringASM.arn}"
      }
    )}"
  ]

  depends_on = [
    helm_release.coe-argocd
  ]
}
