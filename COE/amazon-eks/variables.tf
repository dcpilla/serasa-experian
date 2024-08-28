variable "service_request" {
  description = "ITIL Request Number"
  default     = ""
}

variable "region" {
  description = "AWS region"
}

variable "env" {
  description = "Name of environment (dev|uat|prod|sandbox)"
  type        = string
}

variable "vpc_id" {
  description = "VPC to be used for all operations"
  type        = string
  default     = "auto"
}

variable "subnets" {
  description = "Subnets to be used by EKS ENIs, EC2 instances, Istio NLB, and EFS ENIs"
  type = string
  default = "auto"
}

variable "efs_enabled" {
  description = "Boolean that indicates if EFS should be installed and condigured"
  type        = bool
  default     = true
}

variable "eks_cluster_name" {
  description = "Name of EKS cluster"
  type        = string
}

variable "eks_cluster_version" {
  description = "Kubernetes Version"
  type        = string
  default     = "1.27"
}

variable "eks_ami_id" {
  description = "ID of AMI to be used on NodeGroups or latest"
  type        = string
  default     = "latest"
}

variable "eks_addons_version" {
  description = "List of EKS Addons version based on Kubernetes version"
  type        = map(map(string))
  default     = {
    "1.24" = {
      ebs_csi_driver = "v1.33.0-eksbuild.1"
      kube_proxy = "v1.24.17-eksbuild.8"
      vpc_cni = "v1.15.1-eksbuild.1"
      coredns = "v1.9.3-eksbuild.11"
    }
    "1.25" = {
      ebs_csi_driver = "v1.33.0-eksbuild.1"
      kube_proxy = "v1.25.14-eksbuild.2"
      vpc_cni = "v1.15.1-eksbuild.1"
      coredns = "v1.9.3-eksbuild.11"
    }
    "1.26" = {
      ebs_csi_driver = "v1.33.0-eksbuild.1"
      kube_proxy = "v1.26.9-eksbuild.2"
      vpc_cni = "v1.15.1-eksbuild.1"
      coredns = "v1.9.3-eksbuild.11"
    }
    "1.27" = {
      ebs_csi_driver = "v1.33.0-eksbuild.1"
      kube_proxy = "v1.27.6-eksbuild.2"
      vpc_cni = "v1.15.1-eksbuild.1"
      coredns = "v1.10.1-eksbuild.7"
    }
    "1.28" = {
      ebs_csi_driver = "v1.33.0-eksbuild.1"
      kube_proxy = "v1.28.2-eksbuild.2"
      vpc_cni = "v1.15.1-eksbuild.1"
      coredns = "v1.10.1-eksbuild.7"
    }
    "1.29" = {
      ebs_csi_driver = "v1.33.0-eksbuild.1"
      kube_proxy = "v1.29.0-eksbuild.1"
      vpc_cni = "v1.18.1-eksbuild.3"
      coredns = "v1.11.1-eksbuild.8"
    }
    "1.30" = {
      ebs_csi_driver = "v1.33.0-eksbuild.1"
      kube_proxy = "v1.30.0-eksbuild.3"
      vpc_cni = "v1.18.1-eksbuild.3"
      coredns = "v1.11.1-eksbuild.8"
    }
  }
}

variable "eks_charts_version" {
  description = "List of Helm Charts version based on Kubernetes version"
  type        = map(map(string))
  default     = {
    "1.24" = {
      cluster_autoscaler = "9.37.0"
      metrics_server = "3.12.1"
      external_dns = "1.14.5"
      istio = "1.18.7"
      kiali = "1.73.2"
    }
    "1.25" = {
      cluster_autoscaler = "9.37.0"
      metrics_server = "3.12.1"
      external_dns = "1.14.5"
      istio = "1.20.7"
      kiali = "1.78.0"
    }
    "1.26" = {
      cluster_autoscaler = "9.37.0"
      metrics_server = "3.12.1"
      external_dns = "1.14.5"
      istio = "1.20.7"
      kiali = "1.78.0"
    }
    "1.27" = {
      cluster_autoscaler = "9.37.0"
      metrics_server = "3.12.1"
      external_dns = "1.14.5"
      istio = "1.21.4"
      kiali = "1.81.0"
    }
    "1.28" = {
      cluster_autoscaler = "9.37.0"
      metrics_server = "3.12.1"
      external_dns = "1.14.5"
      istio = "1.21.4"
      kiali = "1.81.0"
    }
    "1.29" = {
      cluster_autoscaler = "9.37.0"
      metrics_server = "3.12.1"
      external_dns = "1.14.5"
      istio = "1.21.4"
      kiali = "1.81.0"
    }
    "1.30" = {
      cluster_autoscaler = "9.37.0"
      metrics_server = "3.12.1"
      external_dns = "1.14.5"
      istio = "1.21.4"
      kiali = "1.86.1"
    }
  }
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

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

variable "istio_ingress_annotation" {
  description = "Annotion used in service object"
  type        = map(string)
  default     = {}
}

variable "istio_ingress_ports" {
  description = "Ports to be listen at new Loadbalances"
  type        = list(map(string))
}

variable "istio_ingress_loadBalancerSourceRanges" {
  description = "IPs to allow connection to 443 loadbalancer"
  type        = list(string)
  default     = []
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

variable "eks_managed_node_infra_max_size" {
  description = "Max size to node group"
  type        = number
  default     = 6

  validation {
    condition = var.eks_managed_node_infra_max_size > 0
    error_message = "INFRA max size must not be lower than 1"
  }
}

variable "eks_managed_node_small_max_size" {
  description = "Max size to node group"
  type        = number
  default     = 6
}

variable "eks_managed_node_medium_max_size" {
  description = "Max size to node group"
  type        = number
  default     = 6
}

variable "eks_managed_node_larger_max_size" {
  description = "Max size to node group"
  type        = number
  default     = 6
}

variable "eks_managed_node_spot_max_size" {
  description = "Max size to node group"
  type        = number
  default     = 6
}

variable "eks_managed_node_infra_instance_type" {
  description = "EC2 instance type for Infra nodes"
  type        = string
  default     = "c6i.2xlarge"

  validation {
    condition = length(var.eks_managed_node_infra_instance_type) == 0 || can(regex("^[a-z0-9]{2,4}.[a-z0-9]+$", var.eks_managed_node_infra_instance_type))
    error_message = "Preliminary format analysis failed: regular expression not satisfied for INFRA nodegroup"
  }
}

variable "eks_managed_node_small_instance_type" {
  description = "EC2 instance type for Small nodes"
  type        = string
  default     = "m5.xlarge"

  validation {
    condition = length(var.eks_managed_node_small_instance_type) == 0 || can(regex("^[a-z0-9]{2,4}.[a-z0-9]+$", var.eks_managed_node_small_instance_type))
    error_message = "Preliminary format analysis failed: regular expression not satisfied for SMALL nodegroup"
  }
}

variable "eks_managed_node_medium_instance_type" {
  description = "EC2 instance type for Medium nodes"
  type        = string
  default     = "m5.2xlarge"

  validation {
    condition = length(var.eks_managed_node_medium_instance_type) == 0 || can(regex("^[a-z0-9]{2,4}.[a-z0-9]+$", var.eks_managed_node_medium_instance_type))
    error_message = "Preliminary format analysis failed: regular expression not satisfied for MEDIUM nodegroup"
  }
}

variable "eks_managed_node_large_instance_type" {
  description = "EC2 instance type for Large nodes"
  type        = string
  default     = "m5.4xlarge"

  validation {
    condition = length(var.eks_managed_node_large_instance_type) == 0 || can(regex("^[a-z0-9]{2,4}.[a-z0-9]+$", var.eks_managed_node_large_instance_type))
    error_message = "Preliminary format analysis failed: regular expression not satisfied for LARGE nodegroup"
  }
}

variable "eks_managed_node_spot_instance_type" {
  description = "EC2 instance type for Spot nodes"
  type        = string
  default     = "m5.large"

  validation {
    condition = length(var.eks_managed_node_spot_instance_type) == 0 || can(regex("^[a-z0-9]{2,4}.[a-z0-9]+$", var.eks_managed_node_spot_instance_type))
    error_message = "Preliminary format analysis failed: regular expression not satisfied for SPOT nodegroup"
  }
}

variable "resource_cost_center" {
  description = "Business Unit Cost Center"
  type        = string
}

variable "resource_app_id" {
  description = "GEARR ID of any app that runs in this cluster"
  type        = string
}

variable "resource_environment" {
  description = "List of Environments for the EEC Policy Tag"
  type        = map(map(string))
  default     = {
    dev = {
      value = "dev"
    }
    uat = {
      value = "uat"
    }
    prod = {
      value = "prd"
    }
    sandbox = {
      value = "sbx"
    }
  }
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

variable "ad_domain" {
  description = "Active Directory Domain to register EC2 instances"
  type        = string
}

variable "roles" {
  description = "List of Roles to grant Admin access to cluster."
  type        = list(string)
  default     = ["BUAdministratorAccessRole","BUAdminConsoleAccessRole","BURoleForDevSecOpsCockpitService", "BreakGlassAccessRole", "ReadOnlyAccessRole", "ViewOnlyAccessRole"]
}

variable "users" {
  description = "List of Users to grant Admin access to cluster."
  type        = list(string)
  default     = ["BUUserForDevSecOpsPiaaS"]
}

variable "karpenter" {
  description = "Feature flag for enabling Karpenter"
  type        = string
  default     = "disabled"
}

variable "nodegroup_names_prefix" {
  description = "Defines how to write NodeGroup names, if combining cluster name or not"
  type        = string
  default     = "combined"  
}

variable "apigee_config" {
  description = "List of Experian BR Apigee configurations"
  type        = map(map(string))
  default     = {
    dev = {
      hostname = "dev-br-api.experian.com"
      environment = "exp-dev"
      organization = "exp-global-nonprod"
    }
    uat = {
      hostname = "uat-api.serasaexperian.com.br"
      environment = "exp-uat"
      organization = "exp-br-prod"
    }
    prod = {
      hostname = "api.serasaexperian.com.br"
      environment = "exp-prod"
      organization = "exp-br-prod"
    }
    sandbox = {
      hostname = "sandbox-api.serasaexperian.com.br"
      environment = "exp-sandbox"
      organization = "exp-br-prod"
    }
  }
}

variable "dockerhub_cache_prefix" {
  description = "To be used with apps from Docker Hub due to 429 Rate Limit"
  type        = string
  default     = "off"
}

variable "use_proxy" {
  description = "'auto' for EEC/region proxy, 'no-proxy' for no proxy configuration, or ADDRESS:PORT for arbitrary proxy"
  type        = string
  default     = "auto"
}

variable "repo_version" {
  description = "Repositori tag, branch or commit used to deploy automation"
  type        = string
  default     = "master"
}