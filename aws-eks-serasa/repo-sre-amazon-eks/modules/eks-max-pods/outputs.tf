output "max_pods" {
  description = "Max Pods Available"
  value       = try(local.instance_max_pods, "")
}