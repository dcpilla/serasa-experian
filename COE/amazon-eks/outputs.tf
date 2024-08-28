output "cluster_id" {
  description = "EKS Cluster ID."
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS Region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name_env
}

# output "cluster_addons" {
#   value = module.eks.cluster_addons 
# }

output "grafana_password" {
  description = "Grafana Password"
  value       = random_password.password.result
  sensitive   = true
}

output "bucket_backup_name" {
  description = "Bucket used for Velero backups"
  value       = aws_s3_bucket.eks_backup_bucket.id
}

output "bucket_log_name" {
  description = "Bucket used for log purpose"
  value       = aws_s3_bucket.eks_log_bucket.id
}

output "bucket_helm_name" {
  description = "Bucket used to store PiaaS Helm Charts for deployments"
  value       = aws_s3_bucket.eks_helm_bucket.id
}