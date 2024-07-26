### Bucket Provisioning

resource "aws_s3_bucket" "s3_bucket" {
  bucket        = local.domain_name
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

resource "aws_s3_bucket_cors_configuration" "s3_bucket_cors" {
  bucket = aws_s3_bucket.s3_bucket.id
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  depends_on = [aws_s3_bucket.s3_bucket]
  bucket     = aws_s3_bucket.s3_bucket.id
  policy     = <<EOF
  {
    "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Principal": "*",
              "Action": "s3:GetObject",
              "Resource": [
                  "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}",
                  "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}/*"
              ],
              "Condition": {
                  "StringEquals": {
                      "aws:SourceVpce": "${data.aws_vpc_endpoint.s3.id}"
                  }
              }
          }
      ]
  }
  EOF
}