variable "env" {
  description = "Name of environment (dev|uat|sandbox)"
  type        = string

}
variable "eks_cluster_name" {
  description = "Name of EKS cluster"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "external_dns_domain" {
  description = "Domain name to use in external DNS url"
  type        = string
}

variable "tags" {
  description = "Default Tags to put in all resources"
  type        = map(any)
  default     = {}
}

variable "oidc_provider_arn" {
  description = "OIDC EKS provider"
  type        = string
}

variable "eks_cluster_id" {
  description = "EKS cluster ID"
  type        = any
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

#=~=~=~=~=~=~=~=~=~
# ARGO SYSTEM
#=~=~=~=~=~=~=~=~=~

variable "git_repository_url" {
  description = "Git url repository were are hosted default apps for this cluster Ex. https://code.experian.local/projects/CDEAMLO/repos/coe-data-platform-infra"
  type        = string
}

variable "git_repository_path" {
  description = "Git path in repository were are hosted default apps for this cluster Ex. app/cluster-01"
  type        = string
}

variable "global_ssh_git_repository_url" {
  description = "Global git repository for the BU team Ex: ssh://git@code.experian.local/cdeamlot"
  type        = string
  default     = "ssh://git@code.experian.local/cdeamlot"
}

variable "git_repository_branch" {
  description = "Name of the Git Branch to use"
  type        = string
  default     = ""
}
variable "eks_namespace" {
  description = "Namespace to install coe-argocd"
  type        = string
  default     = "deploy-system"
}

variable "helm_version" {
  description = "Version of the Helm Coe Argo"
  type        = string
}

variable "argo-rollouts_helm_version" {
  description = "Version of the Helm Argo Rollout"
  type        = string
  default     = "2.34.3"
}

variable "argocd-app-installer_helm_version" {
  description = "Version of the Helm Argo app installer"
  type        = string
  default     = "v1.0.0-34-gf91dcd0"
}


variable "dex_helm_version" {
  description = "Version of the Helm DEX"
  type        = string
  default     = "v1.0.0-9-g110984e"
}

variable "eks_cluster_ad_group_access_admin" {
  description = "AD group name to be associated with admin role at Dex"
  type        = string
}

variable "eks_cluster_ad_group_access_view" {
  description = "AD group name to be associated with admin role at Dex"
  type        = string
}

variable "resources_aws_account" {
  description = "AWS Account with the basic resources"
  type        = string
  default     = "837714169011"
}


#=~=~=~=~=~=~=~=~=~
# DEX SYSTEM
#=~=~=~=~=~=~=~=~=~
variable "oidc_dex_secret" {
  description = "Secret to setup DEX app for Argo cd"
  type        = string
  sensitive   = true
}

variable "oidc_dex_secret_monitoring" {
  description = "Secret to setup DEX app for Grafana"
  type        = string
  sensitive   = true
}

variable "oidc_dex_callback_monitoring" {
  description = "Grafana URL to callback after login user ex: https://monitoring-mlops-odin-03.dev-mlops.br.experian.eeca/login/generic_oauth, Default auto."
  type        = string
  default     = "auto"

}


variable "dex_static_passwords_hash" {
  description = "Hashed password to use as SRE user in DEX, set blank SRE will not be created, Gen hash (echo password | htpasswd -BinC 10 admin | cut -d: -f2)"
  type        = string
  default     = ""
}

variable "dex_eks_namespace" {
  description = "Namespace to install DEX"
  type        = string
  default     = "auth-system"
}

variable "auth_system_ldap_password" {
  description = "LDAP Password to be setup in DEX"
  type        = string
}

variable "auth_system_ldap_user" {
  description = "LDAP User for DEX Connector"
  type        = string
  default     = "CN=sist_mlcoe_unix_01,OU=Red Accounts,OU=Accounts,DC=serasa,DC=intranet"
}

variable "auth_system_ldap_config" {
  description = "Config for DEX Ldap Connector"
  type        = any
  default = {
    host               = "ldapss.serasa.intranet:389"
    insecureNoSSL      = true
    insecureSkipVerify = true
    startTLS           = false
    usernamePrompt     = "Username"
    userSearch = {
      baseDN    = "dc=serasa,dc=intranet"
      filter    = "(|(memberOf=CN=aws-mlops-odin-airflow-dev-viewer,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(memberOf=CN=aws-mlops-odin-airflow-dev-user,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(memberOf=CN=aws-mlops-odin-airflow-dev-op,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(memberOf=CN=aws-mlops-odin-airflow-dev-admin,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet))"
      username  = "sAMAccountName"
      idAttr    = "DN"
      emailAttr = "mail"
      nameAttr  = "sAMAccountName"
    }
    groupSearch = {
      baseDN    = "dc=serasa,dc=intranet"
      filter    = "(|(distinguishedName=CN=aws-mlops-odin-airflow-dev-viewer,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(distinguishedName=CN=aws-mlops-odin-airflow-dev-user,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(distinguishedName=CN=aws-mlops-odin-airflow-dev-op,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(distinguishedName=CN=aws-mlops-odin-airflow-dev-admin,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet))"
      userAttr  = "DN"
      groupAttr = "member"
      nameAttr  = "name"
    }
  }
}
