### Bucket Provisioning

## Web App Bucket
resource "aws_s3_bucket" "s3_bucket" {
  bucket        = lower("${var.app_name}-${var.environment}")
  force_destroy = true
  tags = {
    Data_Type      = "N/A"
    Data_Category  = "N/A"
    Asset_Category = "Embbeded"
    Environment    = local.env,
    AppID          = "${var.app_gearr_id}"
    CostString     = "${var.cost_center}"
    Project        = "${var.project_name}"
    BusinessUnit   = "${var.business_unit}"
    ManagedBy      = "Terraform"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_encryption" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket     = aws_s3_bucket.s3_bucket.id
  policy     = <<EOF
  {
    "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Principal": {
                "Service": "cloudfront.amazonaws.com"
              },
              "Action": "s3:GetObject",
              "Resource": [
                  "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}",
                  "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}/*"
              ],
              "Condition": {
                  "StringEquals": {
                      "AWS:SourceArn": "arn:aws:cloudfront::${var.aws_account_id}:distribution/${aws_cloudfront_distribution.cloudfront.id}"
                  }
              }
          }
      ]
  }
  EOF
}

## Web App Data Bucket
resource "aws_s3_bucket" "s3_data_bucket" {
  count         = var.app_type == "WEB" ? 1 : 0
  bucket        = lower("${var.app_name}-data-${var.environment}")
  force_destroy = true
  tags = {
    Data_Type      = "N/A"
    Data_Category  = "N/A"
    Asset_Category = "Embbeded"
    Environment    = local.env,
    Project        = "${var.project_name}"
    AppID          = "${var.app_gearr_id}"
    CostString     = "${var.cost_center}"
    Project        = "${var.project_name}"
    BusinessUnit   = "${var.business_unit}"
    ManagedBy      = "Terraform"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_data_bucket_encryption" {
  count  = var.app_type == "WEB" ? 1 : 0
  bucket = aws_s3_bucket.s3_data_bucket[count.index].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_data_bucket_public_access_block" {
  count                   = var.app_type == "WEB" ? 1 : 0
  bucket                  = aws_s3_bucket.s3_data_bucket[count.index].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "s3_data_bucket_policy" {
  count      = var.app_type == "WEB" ? 1 : 0
  bucket     = aws_s3_bucket.s3_data_bucket[count.index].id
  policy     = <<EOF
  {
    "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Principal": {
                "Service": "cloudfront.amazonaws.com"
              },
              "Action": "s3:GetObject",
              "Resource": [
                  "arn:aws:s3:::${aws_s3_bucket.s3_data_bucket[count.index].id}",
                  "arn:aws:s3:::${aws_s3_bucket.s3_data_bucket[count.index].id}/*"
              ],
              "Condition": {
                  "StringEquals": {
                      "AWS:SourceArn": "arn:aws:cloudfront::${var.aws_account_id}:distribution/${aws_cloudfront_distribution.cloudfront.id}"
                  }
              }
          }
      ]
  }
  EOF
}