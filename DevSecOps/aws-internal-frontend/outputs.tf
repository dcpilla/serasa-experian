output "app_bucket_name" {
  description = "Bucket name"
  value       = aws_s3_bucket.s3_bucket.id
}

output "app_url" {
  value = "https://${local.domain_name}"
}