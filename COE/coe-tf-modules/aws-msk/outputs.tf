
output "arn" {
  value = aws_msk_cluster.cluster.arn
}

output "current_version" {
  value = try(aws_msk_cluster.cluster.current_version, "")
}

output "zookeeper_connect_string" {
  description = "Plaintext connection host:port pairs for zookeeper"
  value       = sort(split(",", aws_msk_cluster.cluster.zookeeper_connect_string))
}

output "zookeeper_connect_string_tls" {
  description = "TLS connection host:port pairs for zookeeper"
  value       = sort(split(",", aws_msk_cluster.cluster.zookeeper_connect_string_tls))
}

output "bootstrap_brokers" {
  description = "Plaintext connection host:port pairs for brokers"
  value       = sort(split(",", aws_msk_cluster.cluster.bootstrap_brokers))
}

output "bootstrap_brokers_tls" {
  description = "TLS connection host:port pairs for brokers"
  value       = sort(split(",", aws_msk_cluster.cluster.bootstrap_brokers_tls))
}

output "bootstrap_brokers_sasl_iam" {
  description = "IAM connection host:port pairs for brokers"
  value       = sort(split(",", aws_msk_cluster.cluster.bootstrap_brokers_sasl_iam))
}

output "bootstrap_brokers_sasl_scram" {
  description = "SCRAM connection host:port pairs for brokers"
  value       = sort(split(",", aws_msk_cluster.cluster.bootstrap_brokers_sasl_scram))
}

#=~=~=~=~=~=~=~=~=~=
# KMS 
#=~=~=~=~=~=~=~=~=~=

output "kms_alias_arn" {
  description = "The Amazon Resource Name (ARN) of the key alias."
  value       = try(aws_kms_alias.msk_cluster[0].arn, "")
}

output "kms_target_key_arn" {
  description = "The Amazon Resource Name (ARN) of the target key identifier."
  value       = try(aws_kms_alias.msk_cluster[0].target_key_arn, "")
}
