variable "region" {
  description = "AWS region"
  default     = "sa-east-1"
}

variable "env" {
  description = "Name of environment (dev|uat|sandbox)"
  type        = string

}
variable "eks_cluster_name" {
  description = "Name of EKS cluster"
  type        = string
}

variable "eks_cluster_node_ipclass" {
  description = "IP Class for the Worker Nodes. Can be '10' (default) or '100' (used by EKS cluster for kubeflow)"
  type        = number
  default     = 10
}

variable "eks_managed_node_groups" {
  description = "Map of EKS managed node group definitions to create"
  type        = map(any)
  default     = {}
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "aws_cni_configuration_values" {
  description = "Additional configuration to be set in AWS-CNI "
  type        = map(any)
  default     = null
}
#=~=~=~=~=~=~=~=~=~
# Metrics Server
#=~=~=~=~=~=~=~=~=~
variable "metrics_server_replicas" {
  description = "Number of Metrics Server replicas to run"
  type        = number
}
variable "metrics_server_hostNetwork_enabled" {
  description = "If true, start metric-server in hostNetwork mode. You would require this enabled if you use alternate overlay networking for pods and API server unable to communicate with metrics-server. As an example, this is required if you use Weave network on EKS"
  type        = bool
}
variable "metrics_server_containerPort" {
  description = "Port for the metrics-server container"
  type        = number
}
variable "metrics_server_version" {
  description = "Version of Metrics Server"
  type        = string
  default     = "3.8.0"
}

#=~=~=~=~=~=~=~=~=~
# Istio
#=~=~=~=~=~=~=~=~=~
variable "istio_ingress_annotation" {
  description = "Annotion used in service object"
  type        = map(string)
  default     = {}
}

variable "istio_ingress_ports" {
  description = "Ports to be listen at new Loadbalances"
  type        = list(map(string))
  default     = [{}]
}

variable "istio_ingress_loadBalancerSourceRanges" {
  description = "IPs to allow connection to 443 loadbalancer"
  type        = list(string)
  default     = []
}

variable "istio_ingress_version" {
  description = "Istio version"
  type        = string
  default     = "1.12.2"
}

variable "istio_ingress_force_update" {
  description = "Force istio stack update, default false"
  type        = bool
  default     = false
}
variable "istio_ingress_enabled" {
  description = "Enable or disable istio, default yes"
  type        = bool
  default     = true
}
variable "istio_ingress_replica_count" {
  description = "Define replica set to Istio-ingress container, for prod  minimum recommended is 2"
  type        = number
  default     = 2
}

#=~=~=~=~=~=~=~=~=~
# External DNS
#=~=~=~=~=~=~=~=~=~
variable "external_dns_source" {
  description = "K8s resources type to be observed for new DNS entries"
  type        = list(string)
  default     = []
}

variable "external_dns_provider" {
  description = "DNS provider where the DNS records will be created"
  type        = string
  default     = "aws"
}

variable "external_dns_version" {
  description = "Verion of the ExternalDNS"
  type        = string
  default     = "1.7.1"
}

variable "external_dns_domain_filters" {
  description = "Limit possible target zones by domain suffixes, the first element of the list will be used in AUTH system url"
  type        = list(string)
  default     = []
}

variable "external_dns_extra_args" {
  description = "Extra arguments to pass to the external-dns container, these are needed for provider specific arguments"
  type        = list(string)
  default     = []
}

variable "external_dns_logLevel" {
  description = "External DNS log Level (panic, debug, info, warning, error, fatal"
  type        = string
  default     = "info"
}

variable "assume_role_arn" {
  description = "Role used by Service Catalog automation"
  type        = string
  default     = ""
}

variable "aws_cni_extra_vars" {
  description = "List of extra var to be setup in AWS CNI."
  type        = list(string)
  default     = []
}


variable "map_server_id" {
  description = "AWS Map Migration Server Id"
  type        = string
  default     = ""
}

variable "node_group_on_demand_general_small" {
  description = "Max size to node group"
  type        = any
  default     = {}
}

variable "node_group_on_demand_4xlarger_max_size" {
  description = "Max size to node group"
  type        = any
  default     = 6
}

variable "node_group_on_demand_r5n2xlarge_max_size" {
  description = "Max size to node group"
  type        = any
  default     = 6
}

variable "node_group_on_demand_c59xlarger_max_size" {
  description = "Max size to node group"
  type        = any
  default     = 6
}

variable "node_group_on_demand_8xlarger_max_size" {
  description = "Max size to node group"
  type        = any
  default     = 6
}

variable "eks_managed_node_infra_max_size" {
  description = "Max size to node group"
  type        = number
  default     = 6
}
variable "eks_managed_node_infra_instance_types" {
  description = "List of instance type for EKS Infra nodes"
  type        = list(string)
  default     = ["m5.large"]
}
variable "node_group_on_demand_general_small_max_size" {
  description = "Max size to node group"
  type        = number
  default     = 6
}
variable "node_group_on_demand_general_medium_max_size" {
  description = "Max size to node group"
  type        = number
  default     = 6
}
variable "node_group_on_demand_general_larger_max_size" {
  description = "Max size to node group"
  type        = number
  default     = 6
}
variable "node_group_spot_general_mixed_max_size" {
  description = "Max size to node group"
  type        = number
  default     = 6
}


variable "ami_bottlerocket" {
  description = "Bottlerocket AMI ID or AUTO to get the latest AMI version"
  type        = string
  default     = "auto"
}

variable "resource_business_unit" {
  description = "Required EEC: Business Unit name # https://pages.experian.com/display/SC/How+to+build+EC2+instances+using+the+Experian+Golden+AMIs"
  type        = string
  default     = ""
}
variable "resource_owner" {
  description = "Team Distribution List that owns the EC2 instance. This email will also be used to notify the Distribution List about any errors found in the AMI post-build phase"
  type        = string
  default     = ""
}
variable "resource_name" {
  description = "Name of the EC2 instance (fully qualified domain name). The approved AMIs will also use this tag to configure hostname and hosts file in the machine"
  type        = string
  default     = ""
}
variable "rapid7_tag" {
  description = "Tag used to activate Rapid7 and monitor the assets based on the BU which is building the instances"
  type        = string
  default     = ""
}
variable "ad_group" {
  description = "Set administrator/sudo permissions for the specific AD group. If multiple groups need to be setup they can be separated by commas."
  type        = string
  default     = ""
}
variable "ad_domain" {
  description = "Used by AMI instance post build automation to join machine to the domain."
  type        = string
  default     = "br.experian.local"
}
variable "centrify_unix_role" {
  description = "The Unix Role that will be used to grant access and authorization to the Linux instance."
  type        = string
  default     = ""
}


variable "coredns_version" {
  description = "CoreDNS Version"
  type        = string
  default     = "1.19.0"
}

variable "aws_auth_roles" {
  description = "List of role maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []

}

variable "aws_auth_users" {
  description = "	List of user maps to add to the aws-auth configmap."
  type        = list(any)
  default     = []

}

variable "roles" {
  description = "List of Roles name to grant Admin access to cluster."
  type        = list(string)
  default     = ["BUAdministratorAccessRole"]
}

variable "users" {
  description = "List of Users to grant Admin access to cluster."
  type        = list(string)
  default     = []
}

variable "node_groups_multi_az" {
  description = "If set to true will replicate each node group in all AZ set by node_group_regions"
  type        = bool
  default     = false
}

variable "node_groups_regions" {
  description = "Regions to be used by node_groups_multi_az"
  type        = list(any)
  default     = ["sa-east-1a", "sa-east-1b", "sa-east-1c"]
}


variable "custom_oidc_thumbprints" {
  description = "Additional list of server certificate thumbprints for the OpenID Connect (OIDC) identity provider's server certificate(s)"
  type        = list(string)
  default     = []
}
#=~=~=~=~=~=~=~=~=~
# AUTH SYSTEM
#=~=~=~=~=~=~=~=~=~
variable "auth_system_ldap_password" {
  description = "LDAP Password to be setup in DEX"
  type        = string
}

variable "dex_static_passwords_hash" {
  description = "Hashed password to use as SRE user in DEX, set blank SRE will not be created, Gen hash (echo password | htpasswd -BinC 10 admin | cut -d: -f2)"
  type        = string
  default     = ""
}


variable "auth_system_ldap_config" {
  description = "Config for DEX Ldap Connector"
  type        = any
}

variable "auth_system_ldap_user" {
  description = "LDAP User for DEX Connector"
  type        = string
  default     = "CN=sist_mlcoe_unix_01,OU=Red Accounts,OU=Accounts,DC=serasa,DC=intranet"
}


#=~=~=~=~=~=~=~=~=~
# DEPLOY SYSTEM
#=~=~=~=~=~=~=~=~=~
variable "coe_argocd_helm_version" {
  description = "Version of the Helm Coe Argo, try not use it, let the module choose the best version for you"
  type        = string
  default     = null
}


variable "deploy_project_name" {
  description = "Name of the Project in the APPS repository, default is PROJECT_NAME"
  type        = string
  default     = ""
}
variable "coe_argocd_git_repository_path" {
  description = "Git path in repository were are hosted default apps for this cluster Ex. app/cluster-01"
  type        = string
}
variable "coe_argocd_git_repository_url" {
  description = "Git url to the repository were are the all default apps for the cluster"
  type        = string
}
variable "coe_argocd_git_repository_branch" {
  description = "Name of the Git Branch to use"
  type        = string
  default     = ""
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

variable "coe_argocd_eks_namespace" {
  description = "Namespace to install coe-argocd"
  type        = string
  default     = "deploy-system"
}

variable "coe_argocd_global_ssh_git_repository_url" {
  description = "Global git repository for the BU team Ex: ssh://git@code.experian.local/cdeamlot"
  type        = string
}


#=~=~=~=~=~=~=~=~=~
# EC2
#=~=~=~=~=~=~=~=~=~

variable "default_tags_ec2" {
  description = "Default tag to EC2 instance - # https://pages.experian.com/pages/viewpage.action?pageId=400041906"
  type        = map(any)
  default     = {}
}

#=~=~=~=~=~=~=~=~=~
# Mandatory TAGS
#=~=~=~=~=~=~=~=~=~
variable "coststring" {
  description = "Cost Center (CostString) of your project"
  type        = string
}
variable "appid" {
  description = "AppID of your project"
  type        = string
}



variable "global_max_pods_per_node" {
  description = "Set the maximum number of pods per node. Default is auto"
  type        = string
  default     = "auto"
}
