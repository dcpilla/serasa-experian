output "deploy_pub_key" {
  description = "Pub key to setup Bitbuckek for Argocd integration"
  value       = module.experian_eks.deploy_pub_key
}
