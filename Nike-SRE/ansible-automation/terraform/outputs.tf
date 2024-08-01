output "region" {
  description = "AWS region"
  value       = var.region
}

output "opensearch_endpoint" {
  value = aws_opensearch_domain.opensearch.endpoint
}

output "opensearch_kibana_endpoint" {
  value = "https://${aws_opensearch_domain.opensearch.kibana_endpoint}"
}

output "opensearch_master_password" {
  value = random_password.opensearch.result
  sensitive = true
}

output "kafka_brokers" {
  # value = local.kafka_brokers
  value = [for b in split(",", aws_msk_cluster.kafka.bootstrap_brokers): split(":", b)[0]]
}

output "logstash_instance_private_ip" {
  # value = module.ec2_logstash.private_ip
  value = aws_instance.logstash.private_ip
}
