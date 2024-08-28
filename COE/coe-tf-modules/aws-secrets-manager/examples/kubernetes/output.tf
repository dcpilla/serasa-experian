output "sm_arn" {
  description = "ARN of the secret"
  value       = module.experian_sm.sm_arn
}

output "install_secret_store_csi_drive" {
  description = "Execute below command to install Secret Store CSI Dribe in you k8s cluster"
  value       = "helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts\nhelm install csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver --namespace kube-system"
}

output "install_secret_store_csi_drive_yaml" {
  description = "Run yaml against your k8s cluster"
  value       = ""
}
