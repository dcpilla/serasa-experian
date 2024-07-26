output "app_bucket_name" {
  description = "Bucket name"
  value       = aws_s3_bucket.s3_bucket.id
}

output "cloudfront_id" {
  value = aws_cloudfront_distribution.cloudfront.id
}