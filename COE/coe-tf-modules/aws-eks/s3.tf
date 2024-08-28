resource "aws_s3_bucket" "eks_log_bucket" {

  bucket        = "serasaexperian-${local.cluster_name_env}-metrics-logs"
  force_destroy = false

  tags = merge({
    BucketType     = "Log"
    Asset_Category = "Logs"
    Data_Type      = "N/A"
    Data_Category  = "N/A"
  }, local.default_tags_eks)
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_config_lifecycle" {
  bucket = aws_s3_bucket.eks_log_bucket.id

  rule {
    id = "log"

    expiration {
      days = 365
    }
status = "Enabled"

  transition {
      days          = 20
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket_versioning" "eks_log_bucket" {

  bucket = aws_s3_bucket.eks_log_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "eks_log_bucket" {
  bucket = aws_s3_bucket.eks_log_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "eks_log_bucket_policy" {
  bucket     = aws_s3_bucket.eks_log_bucket.id
  depends_on = [aws_s3_bucket.eks_log_bucket]
  policy     = <<EOF
{
    "Version": "2012-10-17",
    "Id": "Policy1621613846656",
    "Statement": [
       {
            "Sid": "Stmt1611277877767",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "s3:*",
            "Resource": "${aws_s3_bucket.eks_log_bucket.arn}/*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::507241528517:root"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.eks_log_bucket.arn}/*"
        },
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "delivery.logs.amazonaws.com"
          },
          "Action": "s3:PutObject",
          "Resource": "${aws_s3_bucket.eks_log_bucket.arn}/*",
          "Condition": {
            "StringEquals": {
              "s3:x-amz-acl": "bucket-owner-full-control"
            }
          }
        },
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "delivery.logs.amazonaws.com"
          },
          "Action": "s3:GetBucketAcl",
          "Resource": "${aws_s3_bucket.eks_log_bucket.arn}"
        }
    ]
}
EOF
}

resource "aws_s3_bucket_public_access_block" "eks_log_bucket_access_block" {
  bucket                  = aws_s3_bucket.eks_log_bucket.id
  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}
