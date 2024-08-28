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
variable "eks_cluster_version" {
  description = "Kubernetes Version"
  type        = string
  default     = "1.21"
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

variable "vpc_cni_patch_version" {
  description = "Version of CoE SRE VPC CNI Patch"
  type        = string
  default     = "0.1.5"
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
  description = "Limit possible target zones by domain suffixes"
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

variable "costcenter" {
  description = "Cost Center of your project"
  type        = string
  default     = "finops-eks"
}

variable "ami_bottlerocket" {
  description = "Bottlerocket AMI ID or AUTO to get the latest AMI version"
  type        = string
  default     = "auto"
}

variable "resource_business_unit" {
  description = "Required EEC: Business Unit name # https://pages.experian.com/display/SC/How+to+build+EC2+instances+using+the+Experian+Golden+AMIs"
  type        = string
}
variable "resource_owner" {
  description = "Team Distribution List that owns the EC2 instance. This email will also be used to notify the Distribution List about any errors found in the AMI post-build phase"
  type        = string
}
variable "resource_name" {
  description = "Name of the EC2 instance (fully qualified domain name). The approved AMIs will also use this tag to configure hostname and hosts file in the machine"
  type        = string
}
variable "rapid7_tag" {
  description = "Tag used to activate Rapid7 and monitor the assets based on the BU which is building the instances"
  type        = string
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

variable "prometheus_enabled" {
  description = "Enable or disable Prometheus"
  type        = bool
  default     = true
}
