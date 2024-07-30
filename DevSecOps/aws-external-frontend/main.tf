### CloudFront Provisioning

resource "aws_cloudfront_distribution" "cloudfront" {
  depends_on = [aws_lambda_function.incapsula_whitelist]

  aliases             = [local.domain]
  comment             = "[${upper(var.environment)}] ${local.domain}"
  default_root_object = "index.html"
  enabled             = true
  http_version        = "http2"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = true

  default_cache_behavior {
    allowed_methods            = ["GET", "HEAD"]
    cached_methods             = ["GET", "HEAD"]
    target_origin_id           = aws_s3_bucket.s3_bucket.id
    cache_policy_id            = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    response_headers_policy_id = "eaab4381-ed33-4a86-88ca-d9558dc6cd63"
    viewer_protocol_policy     = "redirect-to-https"
    min_ttl                    = 0
    default_ttl                = 3600
    max_ttl                    = 86400

    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = aws_lambda_function.incapsula_whitelist.qualified_arn
      include_body = true
    }

  }

  dynamic "ordered_cache_behavior" {
    for_each = aws_s3_bucket.s3_data_bucket
    content {
      allowed_methods            = ["GET", "HEAD"]
      cached_methods             = ["GET", "HEAD"]
      path_pattern               = "/data/*"
      target_origin_id           = aws_s3_bucket.s3_data_bucket[0].id
      cache_policy_id            = "658327ea-f89d-4fab-a63d-7e88639e58f6"
      response_headers_policy_id = "eaab4381-ed33-4a86-88ca-d9558dc6cd63"
      viewer_protocol_policy     = "redirect-to-https"
      min_ttl                    = 0
      default_ttl                = 3600
      max_ttl                    = 86400

      lambda_function_association {
        event_type   = "origin-request"
        lambda_arn   = aws_lambda_function.incapsula_whitelist.qualified_arn
        include_body = true
      }

    }
  }

  origin {
    domain_name              = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.s3_bucket.id
    origin_access_control_id = aws_cloudfront_origin_access_control.access.id
    origin_path              = null
  }

  dynamic "origin" {
    for_each = aws_s3_bucket.s3_data_bucket
    content {
      domain_name              = aws_s3_bucket.s3_data_bucket[0].bucket_regional_domain_name
      origin_access_control_id = aws_cloudfront_origin_access_control.access_data[0].id
      origin_id                = aws_s3_bucket.s3_data_bucket[0].id
      origin_path              = null
    }
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 500
    response_code         = 200
    response_page_path    = "/index.html"
  }

  viewer_certificate {
    acm_certificate_arn            = var.certificate_arn
    cloudfront_default_certificate = false
    iam_certificate_id             = null
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  tags = {
    Environment  = local.env
    AppID        = var.app_gearr_id
    CostString   = var.cost_center
    Project      = var.project_name
    BusinessUnit = var.business_unit
    ManagedBy    = "Terraform"
  }

}

resource "aws_cloudfront_origin_access_control" "access" {
  description                       = null
  name                              = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_origin_access_control" "access_data" {
  count                             = var.app_type == "WEB" ? 1 : 0
  name                              = aws_s3_bucket.s3_data_bucket[count.index].bucket_regional_domain_name
  description                       = null
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
