#
# This variables are used by TERRATEST do not use it for your applications
#

# The currecnt environment
env = "sandbox"

# The name of the project that did request this cluster
project_name = "mlops-test"

# An uniq name for this EKS cluster
eks_cluster_name = "mlops-test-11"

# auto = will get the latest EEC AMI bottlerocket or you can define a specific AMI
ami_bottlerocket = "ami-0f2113f6628fba648"

coststring = "N/A"
appid      = "N/A"

# Tag that will be used in ec2 instances node, 
# for more information see  https://pages.experian.com/pages/viewpage.action?pageId=400041906
default_tags_ec2 = {
  ResourceBusinessUnit = "DataPlatformAndMLE"
  ResourceOwner        = "mlops.sre@br.experian.com"
  resource_name        = "BRASA1DHYU01"
  Rapid7Tag            = "Server LATAM - MLOPS CoE SERASA EXPERIAN"
  CentrifyUnixRole     = "12456"
  CostString           = "1800.BR.640.402057"
  AppID                = "mlops"
}

# Grant access on EKS cluster to Roles or IAM users
# Admin is granted for BUAdmnistratorAccessRole automatically
# Ex:
# {
#   rolearn  = "arn:aws:iam::827294527432:role/BUAdministratorAccessRole"
#   username = "BUAdministratorAccessRole"
#   groups   = ["system:masters"]
# },
#
# Grant view access to ReadOnlyAccessRole
# Ex:
# {
#   rolearn  = "arn:aws:iam::827294527432:role/ReadOnlyAccessRole"
#   username = "ReadOnlyAccessRole"
#   groups   = ["readonly"]
# },
#
aws_auth_roles = [
  {
    rolearn  = "arn:aws:iam::827294527432:role/BURoleForSRE"
    username = "BUAdministratorAccessRole"
    groups   = ["system:masters"]
  },
  {
    rolearn  = "arn:aws:iam::827294527432:role/BURoleForDevelopersAccess"
    username = "BUAdministratorAccessRole"
    groups   = ["system:masters"]
  },
]

# Deploy the eks_managed_node_groups items in multi-az, this is useful to create only one entry
# in eks_managed_node_groups and let's the script create the other ones
# OPTIONS: true or false
node_groups_multi_az = false

# In which AZ will create the nodes group if the node_groups_multi_az is set to true
node_groups_regions = ["sa-east-1a", "sa-east-1b", "sa-east-1c"]

# CA AWS thummpprints
custom_oidc_thumbprints = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]

#EKS DEX auth
auth_system_ldap_user = "CN=sist_mlcoe_unix_01,OU=Red Accounts,OU=Accounts,DC=serasa,DC=intranet"
auth_system_ldap_config = {
  host               = "ldapss.serasa.intranet:389"
  insecureNoSSL      = true
  insecureSkipVerify = true
  startTLS           = false
  usernamePrompt     = "Username"
  userSearch = {
    baseDN    = "dc=serasa,dc=intranet"
    filter    = "(|(memberOf=CN=aws-mlops-odin-airflow-dev-admin,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(memberOf=CN=aws-mlops-odin-operations-uat-user,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(memberOf=CN=aws-mlops-odin-operations-uat-op,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(memberOf=CN=aws-mlops-odin-operations-uat-admin,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet))"
    username  = "sAMAccountName"
    idAttr    = "DN"
    emailAttr = "mail"
    nameAttr  = "sAMAccountName"
  }
  groupSearch = {
    baseDN    = "dc=serasa,dc=intranet"
    filter    = "(|(distinguishedName=CN=aws-mlops-odin-airflow-dev-admin,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(distinguishedName=CN=aws-mlops-odin-operations-uat-user,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(distinguishedName=CN=aws-mlops-odin-operations-uat-op,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(distinguishedName=CN=aws-mlops-odin-operations-uat-admin,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet))"
    userAttr  = "DN"
    groupAttr = "member"
    nameAttr  = "name"
  }
}

# Instance type to be used by node used to host the infra nodes
eks_managed_node_infra_instance_types = ["m5.xlarge"]

# AWS CNI
# Example to EKS not use the secondary interface ip 100.64/16
# aws_cni_configuration_values = {
#   "env" : {
#     "AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG" : "false",
#     "ENABLE_PREFIX_DELEGATION" : "true",
#     "MINIMUM_IP_TARGET" : "2",
#     "WARM_IP_TARGET" : "2"
#   }
# }



# Metrics Server
metrics_server_replicas            = 1
metrics_server_hostNetwork_enabled = true
metrics_server_containerPort       = 4443

# ArgoCD configuration
# Main repository URL
coe_argocd_global_ssh_git_repository_url = "ssh://git@code.experian.local/cdeamlo"
# The repository from the ArgoCD should get the applications
coe_argocd_git_repository_url = "ssh://git@code.experian.local/cdeamlo/coe-odin-infra.git"
# Repository Branch name
coe_argocd_git_repository_branch = "feature/COMLDE-1967"
# Path where are the helm to be installed by ArgoCD
coe_argocd_git_repository_path = "apps/mlops-test-01"
# AD group to grant admin access
eks_cluster_ad_group_access_admin = "aws-mlops-odin-airflow-dev-admin"
# AD group to grant view access
eks_cluster_ad_group_access_view = "aws-mlops-odin-operations-dev-viewer"
coe_argocd_helm_version          = "v1.0.0-35-g4d7195b"



# Istio
istio_ingress_enabled       = true
istio_ingress_force_update  = true
istio_ingress_replica_count = 2
istio_ingress_annotation = {
  "service.beta.kubernetes.io/aws-load-balancer-ssl-cert"               = "arn:aws:acm:sa-east-1:827294527432:certificate/3c50d19c-9229-42ca-9f52-e2f231cf075b"
  "service.beta.kubernetes.io/aws-load-balancer-backend-protocol"       = "http"
  "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type"        = "instance"
  "service.beta.kubernetes.io/aws-load-balancer-type"                   = "external"
  "service.beta.kubernetes.io/aws-load-balancer-ssl-ports"              = "443"
  "service.beta.kubernetes.io/aws-load-balancer-internal"               = true
  "service.beta.kubernetes.io/aws-load-balancer-ssl-negotiation-policy" = "ELBSecurityPolicy-TLS-1-2-2017-01"
  "service.beta.kubernetes.io/aws-load-balancer-access-log-enabled"     = true
  "service.beta.kubernetes.io/aws-load-balancer-access-log-s3-bucket-name" : "eks_log_bucket"
  "service.beta.kubernetes.io/aws-load-balancer-access-log-s3-bucket-prefix" : "logs-istio-nlb2"
  "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled" = true
  "service.beta.kubernetes.io/aws-load-balancer-subnets"                           = "auto_private"
  "service.beta.kubernetes.io/aws-load-balancer-target-group-attributes"           = "preserve_client_ip.enabled=false"
}

istio_ingress_ports = [
  {
    "name"       = "status-port"
    "port"       = "15021"
    "protocol"   = "TCP"
    "targetPort" = "15021"
  },
  {
    "name"       = "http2"
    "port"       = "9080"
    "protocol"   = "TCP"
    "targetPort" = "80"
  },
  {
    "name"       = "https"
    "port"       = "443"
    "protocol"   = "TCP"
    "targetPort" = "8080"
  },
  {
    "name"       = "loki"
    "port"       = "3100"
    "protocol"   = "TCP"
    "targetPort" = "3100"
  }
]
istio_ingress_loadBalancerSourceRanges = [
  "10.0.0.0/8",
  "100.64.0.0/16",
  "100.65.0.0/16",
]

# External DNS
external_dns_provider = "aws"
external_dns_source = [
  "ingress",
  "istio-gateway",
  "istio-virtualservice",
]
external_dns_domain_filters = [
  "sandbox-mlops.br.experian.eeca"
]
external_dns_logLevel = "info"
external_dns_extra_args = [
  "--aws-zone-type=private",
]
