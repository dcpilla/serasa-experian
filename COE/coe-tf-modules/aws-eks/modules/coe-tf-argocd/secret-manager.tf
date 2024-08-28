# Creating a AWS secret manager to DEX auth
resource "aws_secretsmanager_secret" "cluster_dex" {
  name_prefix = "${var.project_name}/${var.eks_cluster_name}/dex_${var.env}-settings-"
  description = "Secret Manager to store DEX's configuration"
  tags        = local.default_tags
}

resource "aws_secretsmanager_secret_version" "cluster_dex_version" {
  secret_id     = aws_secretsmanager_secret.cluster_dex.id
  secret_string = <<EOF
issuer: ${local.auth_url}

storage:
  type: kubernetes
  config:
    inCluster: true

web:
  http: 127.0.0.1:5556
  allowedOrigins: ['*']

telemetry:
  http: 127.0.0.1:5558

grpc:
  addr: 127.0.0.1:5557

oauth2:
  skipApprovalScreen: true

${local.dex_static_passwords}

staticClients:
  - id: argo-cd
    name: Argo CD
    redirectURIs:
      - "${local.argo_url}/auth/callback"
    secret: ${var.oidc_dex_secret}
  - id: monitoring-system
    name: Monitoring System
    redirectURIs:
      - "${local.grafana_callback}"
    secret: ${local.grafana_auth.secret}

# See https://dexidp.io/docs/storage/ for more options
connectors:
  - type: ldap
    name: Active Directory
    id: ad
    config:
      # Ldap server address
      host: ${var.auth_system_ldap_config.host}
      insecureNoSSL: ${var.auth_system_ldap_config.insecureNoSSL}
      insecureSkipVerify: ${var.auth_system_ldap_config.insecureSkipVerify}
      # Variable name stores ldap bindDN in argocd-secret
      bindDN: "${var.auth_system_ldap_user}"
      # Variable name stores ldap bind password in argocd-secret
      bindPW: "${var.auth_system_ldap_password}"
      startTLS: ${var.auth_system_ldap_config.startTLS}
      usernamePrompt: ${var.auth_system_ldap_config.usernamePrompt}
      # Ldap user serch attributes
      userSearch:
        baseDN: ${var.auth_system_ldap_config.userSearch.baseDN}
        filter: ${var.auth_system_ldap_config.userSearch.filter}
        username: ${var.auth_system_ldap_config.userSearch.username}
        idAttr: ${var.auth_system_ldap_config.userSearch.idAttr}
        emailAttr: ${var.auth_system_ldap_config.userSearch.emailAttr}
        nameAttr: ${var.auth_system_ldap_config.userSearch.nameAttr}
      # Ldap group serch attributes
      groupSearch:
        baseDN: ${var.auth_system_ldap_config.groupSearch.baseDN}
        filter: ${var.auth_system_ldap_config.groupSearch.filter}
        userAttr: ${var.auth_system_ldap_config.groupSearch.userAttr}
        groupAttr: ${var.auth_system_ldap_config.groupSearch.groupAttr}
        nameAttr: ${var.auth_system_ldap_config.groupSearch.nameAttr}
EOF
}


# Creating a AWS secret manager to Argocd Repository
resource "aws_secretsmanager_secret" "cluster_argocd" {
  name_prefix = "${var.project_name}/${var.eks_cluster_name}/argocd_${var.env}-repositories-"
  description = "Secret Manager to store Argocd repository configuration"
  tags        = local.default_tags
}

resource "aws_secretsmanager_secret_version" "cluster_argocd_version" {
  secret_id     = aws_secretsmanager_secret.cluster_argocd.id
  secret_string = jsonencode(local.argo_secret)
}


# Creating a AWS secret manager to Grafana 
resource "aws_secretsmanager_secret" "grafana_auth" {
  name_prefix = "${var.project_name}/${var.eks_cluster_name}/grafana_${var.env}-auth-"
  description = "Secret Manager to store DEX secret for Grafana"
  tags        = local.default_tags
}

resource "aws_secretsmanager_secret_version" "grafana_auth" {
  secret_id     = aws_secretsmanager_secret.grafana_auth.id
  secret_string = jsonencode(local.grafana_auth)
}
