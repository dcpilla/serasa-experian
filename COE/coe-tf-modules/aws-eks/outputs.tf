################################################################################
# Cluster
################################################################################
output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name_env
}

output "VPC_CIDR" {
  description = "CIDR Account Range"
  value       = data.aws_vpc.selected.cidr_block
}

output "grafana_password" {
  description = "Grafana Password"
  value       = random_password.password.result
  sensitive   = true
}

output "bucket_log_name" {
  description = "Bucket used for log purpose. IMPORTANT: If EKS is deleted, this bucket must not be deleted. We need to keep the data for at least 1 year according to the civil"
  value       = aws_s3_bucket.eks_log_bucket.id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = try(module.eks.cluster_arn, "")
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = try(module.eks.cluster_certificate_authority_data, "")
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = try(module.eks.cluster_endpoint, "")
}

output "cluster_name_from_module" {
  description = "The name of the EKS cluster. Will block on cluster creation until the cluster is really ready"
  value       = try(module.eks.cluster_name, "")
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = try(module.eks.cluster_oidc_issuer_url, "")
}

output "cluster_version" {
  description = "The Kubernetes version for the cluster"
  value       = try(module.eks.cluster_version, "")
}

output "cluster_platform_version" {
  description = "Platform version for the cluster"
  value       = try(module.eks.cluster_platform_version, "")
}




output "cluster_status" {
  description = "Status of the EKS cluster. One of `CREATING`, `ACTIVE`, `DELETING`, `FAILED`"
  value       = try(module.eks.cluster_status, "")
}

output "cluster_primary_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console"
  value       = try(module.eks.cluster_primary_security_group_id, "")
}

################################################################################
# Cluster Security Group
################################################################################

output "cluster_security_group_arn" {
  description = "Amazon Resource Name (ARN) of the cluster security group"
  value       = try(module.eks.cluster_security_group_arn, "")
}

output "cluster_security_group_id" {
  description = "ID of the cluster security group"
  value       = try(module.eks.cluster_security_group_arn, "")
}

################################################################################
# Node Security Group
################################################################################

output "node_security_group_arn" {
  description = "Amazon Resource Name (ARN) of the node shared security group"
  value       = try(module.eks.cluster_security_group_arn, "")
}

output "node_security_group_id" {
  description = "ID of the node shared security group"
  value       = try(module.eks.cluster_security_group_arn, "")
}

################################################################################
# IRSA
################################################################################

output "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
  value       = try(module.eks.oidc_provider, "")
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider if `enable_irsa = true`"
  value       = try(module.eks.oidc_provider_arn, "")
}

################################################################################
# IAM Role
################################################################################

output "cluster_iam_role_name" {
  description = "IAM role name of the EKS cluster"
  value       = try(module.eks.cluster_iam_role_name, "")
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster"
  value       = try(module.eks.cluster_iam_role_arn, "")
}

output "cluster_iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = try(module.eks.cluster_iam_role_unique_id, "")
}

################################################################################
# EKS Addons
################################################################################

output "cluster_addons" {
  description = "Map of attribute maps for all EKS cluster addons enabled"
  value       = try(module.eks.cluster_addons, "")
}

################################################################################
# EKS Identity Provider
################################################################################

output "cluster_identity_providers" {
  description = "Map of attribute maps for all EKS identity providers enabled"
  value       = try(module.eks.cluster_identity_providers, "")
}

################################################################################
# CloudWatch Log Group
################################################################################

output "cloudwatch_log_group_name" {
  description = "Name of cloudwatch log group created"
  value       = try(module.eks.cloudwatch_log_group_name, "")
}

output "cloudwatch_log_group_arn" {
  description = "Arn of cloudwatch log group created"
  value       = try(module.eks.cloudwatch_log_group_arn, "")
}

################################################################################
# EKS Infra Node Group
################################################################################

output "eks_managed_node_group_infra" {
  description = "Map of attribute maps for all EKS managed node INFRA groups created"
  value       = try(module.eks.eks_managed_node_group_infra, "")
}

################################################################################
# EKS Managed Node Group
################################################################################

output "eks_managed_node_groups" {
  description = "Map of attribute maps for all EKS managed node groups created"
  value       = try(module.eks.eks_managed_node_groups, "")
}

output "eks_managed_node_groups_autoscaling_group_names" {
  description = "List of the autoscaling group names created by EKS managed node groups"
  value       = try(module.eks.eks_managed_node_groups_autoscaling_group_names, "")
}

################################################################################
# Self Managed Node Group
################################################################################

output "self_managed_node_groups" {
  description = "Map of attribute maps for all self managed node groups created"
  value       = try(module.eks.self_managed_node_groups, "")
}

output "self_managed_node_groups_autoscaling_group_names" {
  description = "List of the autoscaling group names created by self-managed node groups"
  value       = try(module.eks.self_managed_node_groups_autoscaling_group_names, "")
}

################################################################################
# Additional
################################################################################

output "aws_auth_configmap_yaml" {
  description = "Formatted yaml output for base aws-auth configmap containing roles used in cluster node groups/fargate profiles"
  value       = try(module.eks.aws_auth_configmap_yaml, "")
}


################################################################################
# Coe-argocd
################################################################################
output "deploy_pub_key" {
  description = "Pub key to setup Bitbuckek for Argocd integration"
  value       = module.coe-argocd.deploy_pub_key
}

output "dex_iam_role_arn" {
  description = "Role to be used in DEX service Account"
  value       = module.coe-argocd.dex_iam_role_arn
}

output "deploy_iam_role_arn" {
  description = "Role to be used in Deploy service Account"
  value       = module.coe-argocd.deploy_iam_role_arn
}

output "deploy_aws_secrets_manager" {
  description = "Name of the AWS Secrets Manager use by Deploy system setup repositories"
  value       = module.coe-argocd.deploy_aws_secrets_manager
}

output "argo_url" {
  description = "Coe-argocd URL"
  value       = module.coe-argocd.argo_url
}

output "auth_url" {
  description = "Coe-argocd URL"
  value       = module.coe-argocd.auth_url
}
