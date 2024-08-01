resource "aws_s3_bucket" "lb_logs" {
  bucket = "${var.lb_bucket}-lb-logs"

  logging {
    target_bucket = "${var.lb_bucket}-lb-logs" 
    target_prefix = "${var.lb_bucket_prefix}/"
  }

  tags = {
    BucketType = "Log"
    Name = "${var.lb_bucket}-lb-logs"
  }

  force_destroy = true

  versioning {
    enabled = false
  }

  lifecycle_rule {
    id      = "log-expiration"
    enabled = "true"

    expiration {
      days = "7"
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "lb_accesslog_bucket_policy" {
  depends_on = [aws_s3_bucket.lb_logs]
  bucket     = aws_s3_bucket.lb_logs.id
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
            "Resource": "${aws_s3_bucket.lb_logs.arn}/*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::507241528517:root"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.lb_logs.arn}/*"
        },
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "delivery.logs.amazonaws.com"
          },
          "Action": "s3:PutObject",
          "Resource": "${aws_s3_bucket.lb_logs.arn}/*",
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
          "Resource": "${aws_s3_bucket.lb_logs.arn}"
        }
    ]
}
EOF
}

resource "aws_s3_bucket_public_access_block" "lb_accesslog_bucket_access_block" {
  depends_on = [aws_s3_bucket_policy.lb_accesslog_bucket_policy]
  bucket     = aws_s3_bucket.lb_logs.id
  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}
