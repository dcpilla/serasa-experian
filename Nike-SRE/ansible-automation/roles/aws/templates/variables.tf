variable "service_request" {
  description = "ITIL Request Number"
  default     = ""
}

variable "region" {
  description = "AWS region"
  default     = "sa-east-1"
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
    1.24 = {
      ebs_csi_driver = "v1.25.0-eksbuild.1"
      kube_proxy = "v1.24.17-eksbuild.8"
      vpc_cni = "v1.16.2-eksbuild.1"
      coredns = "v1.9.3-eksbuild.11"
    }
    1.25 = {
      ebs_csi_driver = "v1.25.0-eksbuild.1"
      kube_proxy = "v1.25.16-eksbuild.2"
      vpc_cni = "v1.16.2-eksbuild.1"
      coredns = "v1.9.3-eksbuild.11"
    }
    1.26 = {
      ebs_csi_driver = "v1.25.0-eksbuild.1"
      kube_proxy = "v1.26.12-eksbuild.2"
      vpc_cni = "v1.16.2-eksbuild.1"
      coredns = "v1.9.3-eksbuild.11"
    }
    1.27 = {
      ebs_csi_driver = "v1.25.0-eksbuild.1"
      kube_proxy = "v1.27.9-eksbuild.2"
      vpc_cni = "v1.16.2-eksbuild.1"
      coredns = "v1.10.1-eksbuild.7"
    }
    1.28 = {
      ebs_csi_driver = "v1.25.0-eksbuild.1"
      kube_proxy = "v1.28.4-eksbuild.4"
      vpc_cni = "v1.16.2-eksbuild.1"
      coredns = "v1.10.1-eksbuild.7"
    }
  }
}

variable "eks_charts_version" {
  description = "List of Helm Charts version based on Kubernetes version"
  type        = map(map(string))
  default     = {
    1.24 = {
      cluster_autoscaler = "9.34.1"
      metrics_server = "3.11.0"
      external_dns = "1.14.3"
      istio = "1.18.7"
    }
    1.25 = {
      cluster_autoscaler = "9.34.1"
      metrics_server = "3.11.0"
      external_dns = "1.14.3"
      istio = "1.18.7"
    }
    1.26 = {
      cluster_autoscaler = "9.34.1"
      metrics_server = "3.11.0"
      external_dns = "1.14.3"
      istio = "1.18.7"
    }
    1.27 = {
      cluster_autoscaler = "9.34.1"
      metrics_server = "3.11.0"
      external_dns = "1.14.3"
      istio = "1.18.7"
    }
    1.28 = {
      cluster_autoscaler = "9.34.1"
      metrics_server = "3.11.0"
      external_dns = "1.14.3"
      istio = "1.18.7"
    }
  }
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

variable "prometheus_version" {
  description = "Version of Kube Prometheus Stack"
  type        = string
  default     = "35.6.2"
}

variable "prometheus_adapter_version" {
  description = "Version of Prometheus Adapter"
  type        = string
  default     = "4.0.0"
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

variable "kiali_version" {
  description = "Kiali version compatible with Istio version"
  type        = string
  default     = "1.63.2"
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
}

variable "eks_managed_node_small_instance_type" {
  description = "EC2 instance type for Small nodes"
  type        = string
  default     = "m5.xlarge"
}

variable "eks_managed_node_medium_instance_type" {
  description = "EC2 instance type for Medium nodes"
  type        = string
  default     = "m5.2xlarge"
}

variable "eks_managed_node_large_instance_type" {
  description = "EC2 instance type for Large nodes"
  type        = string
  default     = "m5.4xlarge"
}

variable "eks_managed_node_spot_instance_type" {
  description = "EC2 instance type for Spot nodes"
  type        = string
  default     = "m5.large"
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

variable "edgecli" {
  description = "The Apigee Edge credentials."
  type        = string
  sensitive   = true
  default     = "{{EDGE_CREDENTIALS}}"
}

variable "apigeecli" {
  description = "The Apigee Edge APIs credentials."
  type        = string
  sensitive   = true
  default     = "{{APIGEE_CREDENTIALS}}"
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

variable "proxy_env_vars" {
  description = "Serasa Experian Proxy"
  type        = list
  default     = [
    {
      "name"  = "HTTP_PROXY"
      "value" = "http://spobrproxy.serasa.intranet:3128"
    },
    {
      "name"  = "HTTPS_PROXY"
      "value" = "http://spobrproxy.serasa.intranet:3128"
    },
    {
      "name"  = "NO_PROXY"
      "value" = "172.20.0.0/16,localhost,127.0.0.1,10.0.0.0/8,169.254.169.254,.internal,.s3.amazonaws.com,.s3.sa-east-1.amazonaws.com,api.ecr.sa-east-1.amazonaws.com,dkr.ecr.sa-east-1.amazonaws.com,.ec2.sa-east-1.amazonaws.com,.eks.amazonaws.com,.sa-east-1.eks.amazonaws.com,.experiannet.corp,.aln.experian.com,.mck.experian.com,.sch.experian.com,.experian.eeca,.experian.local,.experian.corp,.gdc.local,.41web.internal,metadata.google.internal,metadata,10.188.14.54,10.188.14.57,10.99.132.16"
    }
  ]
}
