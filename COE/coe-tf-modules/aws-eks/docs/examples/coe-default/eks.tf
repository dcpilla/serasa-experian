module "experian_eks" {
  source = "git::https://code.experian.local/scm/esbt/coe-tf-modules.git//aws-eks?ref=aws-eks-1.29-v0.0.3"
  # Cluster definitions
  env                                   = var.env
  project_name                          = var.project_name
  eks_cluster_name                      = var.eks_cluster_name
  ami_bottlerocket                      = var.ami_bottlerocket
  default_tags_ec2                      = var.default_tags_ec2
  eks_managed_node_groups               = local.eks_managed_node_groups
  node_groups_multi_az                  = var.node_groups_multi_az
  node_groups_regions                   = var.node_groups_regions
  region                                = var.region
  custom_oidc_thumbprints               = var.custom_oidc_thumbprints
  path_documentation_file               = path.module
  documention                           = local.documention
  istio_ingress_replica_count           = var.istio_ingress_replica_count
  eks_managed_node_infra_instance_types = var.eks_managed_node_infra_instance_types
  dex_static_passwords_hash             = var.dex_static_passwords_hash
  coststring                            = var.coststring
  appid                                 = var.appid
  global_max_pods_per_node              = var.global_max_pods_per_node
  #eks_managed_node_group_secondary_additional_rules = local.eks_managed_node_group_secondary_additional_rules

  #Coe-argo
  auth_system_ldap_user                    = var.auth_system_ldap_user
  auth_system_ldap_password                = var.auth_system_ldap_password
  auth_system_ldap_config                  = var.auth_system_ldap_config
  coe_argocd_global_ssh_git_repository_url = var.coe_argocd_global_ssh_git_repository_url
  coe_argocd_git_repository_url            = var.coe_argocd_git_repository_url
  coe_argocd_git_repository_branch         = var.coe_argocd_git_repository_branch
  coe_argocd_git_repository_path           = var.coe_argocd_git_repository_path
  coe_argocd_eks_namespace                 = var.coe_argocd_eks_namespace
  eks_cluster_ad_group_access_admin        = var.eks_cluster_ad_group_access_admin
  eks_cluster_ad_group_access_view         = var.eks_cluster_ad_group_access_view
  resources_aws_account                    = var.resources_aws_account


  aws_auth_roles = var.aws_auth_roles

  # Metrics Server
  #metrics_server_version             = var.metrics_server_version
  metrics_server_replicas            = var.metrics_server_replicas
  metrics_server_hostNetwork_enabled = var.metrics_server_hostNetwork_enabled
  metrics_server_containerPort       = var.metrics_server_containerPort

  # Istio
  ## To install kubeflow we need to disable istio
  istio_ingress_enabled = var.istio_ingress_enabled
  #istio_ingress_version                  = var.istio_ingress_version
  istio_ingress_force_update             = var.istio_ingress_force_update
  istio_ingress_annotation               = var.istio_ingress_annotation
  istio_ingress_ports                    = var.istio_ingress_ports
  istio_ingress_loadBalancerSourceRanges = var.istio_ingress_loadBalancerSourceRanges

  # External DNS
  #external_dns_version        = var.external_dns_version
  external_dns_provider       = var.external_dns_provider
  external_dns_source         = var.external_dns_source
  external_dns_domain_filters = var.external_dns_domain_filters
  external_dns_logLevel       = var.external_dns_logLevel
  external_dns_extra_args     = var.external_dns_extra_args

  #https://github.com/aws/amazon-vpc-cni-k8s/blob/master/docs/prefix-and-ip-target.md
  #aws_cni_configuration_values = var.aws_cni_configuration_values


}


