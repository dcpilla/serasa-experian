output "deploy_pub_key" {
  description = "Pub key to setup Bitbuckek for Argocd integration"
  value       = "${trimspace(tls_private_key.argocd-rsa-4096.public_key_openssh)}  argocd@${local.cluster_name_env}"
}

output "dex_iam_role_arn" {
  description = "Role to be used in DEX service Account"
  value       = aws_iam_role.BURoleForDexAccessSecretsManager.arn
}

output "deploy_iam_role_arn" {
  description = "Role to be used in Deploy service Account"
  value       = aws_iam_role.BURoleForDeployAccessSecretsManager.arn
}

output "deploy_aws_secrets_manager" {
  description = "Name of the AWS Secrets Manager use by Deploy system setup repositories"
  value       = aws_secretsmanager_secret.cluster_argocd.name
}

output "argo_url" {
  description = "Coe-argocd URL"
  value       = local.argo_url
}

output "auth_url" {
  description = "Coe-argocd URL"
  value       = local.auth_url
}
