output "simple_queue_sqs_queue_arn" {
  description = "The ARN of the SQS queue"
  value       = module.simple_queue.sqs_queue_arn
}

output "simple_queue_sqs_queue_id" {
  description = "The URL for the created Amazon SQS queue"
  value       = module.simple_queue.sqs_queue_id
}

output "simple_queue_sqs_queue_name" {
  description = "The Queue name"
  value       = module.simple_queue.sqs_queue_name
}
