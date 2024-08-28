module "experian_eks" {
  source = "git::https://code.experian.local/scm/esbt/coe-tf-modules.git//aws-eks?ref=aws-eks-v0.0.2"

  # Cluster definitions
  env                     = var.env
  project_name            = var.project_name
  eks_cluster_name        = var.eks_cluster_name
  eks_cluster_version     = var.eks_cluster_version
  ami_bottlerocket        = var.ami_bottlerocket
  resource_business_unit  = var.resource_business_unit
  resource_owner          = var.resource_owner
  resource_name           = var.resource_name
  rapid7_tag              = var.rapid7_tag
  ad_group                = var.ad_group
  ad_domain               = var.ad_domain
  centrify_unix_role      = var.centrify_unix_role
  eks_managed_node_groups = local.eks_managed_node_groups
  node_groups_multi_az    = var.node_groups_multi_az
  node_groups_regions     = var.node_groups_regions
  region                  = var.region
  path_documentation_file = path.module
  documention             = local.documention


  # Metrics Server
  metrics_server_version             = var.metrics_server_version
  metrics_server_replicas            = var.metrics_server_replicas
  metrics_server_hostNetwork_enabled = var.metrics_server_hostNetwork_enabled
  metrics_server_containerPort       = var.metrics_server_containerPort

  # Istio
  ## To install kubeflow we need to disable istio
  istio_ingress_enabled                  = var.istio_ingress_enabled
  istio_ingress_version                  = var.istio_ingress_version
  istio_ingress_force_update             = var.istio_ingress_force_update
  istio_ingress_annotation               = var.istio_ingress_annotation
  istio_ingress_ports                    = var.istio_ingress_ports
  istio_ingress_loadBalancerSourceRanges = var.istio_ingress_loadBalancerSourceRanges

  # External DNS
  external_dns_version        = var.external_dns_version
  external_dns_provider       = var.external_dns_provider
  external_dns_source         = var.external_dns_source
  external_dns_domain_filters = var.external_dns_domain_filters
  external_dns_logLevel       = var.external_dns_logLevel
  external_dns_extra_args     = var.external_dns_extra_args

  # Prometheus
  prometheus_enabled = var.prometheus_enabled
}


