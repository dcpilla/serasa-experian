resource "aws_s3_bucket" "logs_bucket" {
  bucket = "serasaexperian-${var.project_name}-${var.env}-logs"
  tags = merge({
    BucketType     = "Log"
    Asset_Category = "Logs"
    Data_Type      = "N/A"
    Data_Category  = "N/A"
  }, local.default_tags)
}

resource "aws_s3_bucket_ownership_controls" "logs_bucket_bucket" {
  bucket = aws_s3_bucket.logs_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "logs_bucket_bucket_acl" {
  bucket = aws_s3_bucket.logs_bucket.id
  acl    = "log-delivery-write"
  depends_on = [
    aws_s3_bucket_ownership_controls.logs_bucket_bucket
  ]
}

resource "aws_s3_bucket_versioning" "logs_bucket_versioning" {
  bucket = aws_s3_bucket.logs_bucket.id
  versioning_configuration {
    status = "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs_bucket_encryption" {
  bucket = aws_s3_bucket.logs_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "logs_bucket_access_block" {
  depends_on = [
    aws_s3_bucket.logs_bucket,
    aws_s3_bucket_public_access_block.logs_bucket_access_block,
  ]
  bucket                  = aws_s3_bucket.logs_bucket.id
  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_s3_bucket_lifecycle_configuration" "logs_bucket" {

  bucket = aws_s3_bucket.logs_bucket.id

  rule {
    id = "rule-1"

    expiration {
      days = var.s3_logs_expiration_days
    }    

    transition {
      days          = var.s3_logs_transition_days
      storage_class = "GLACIER"
    }
    
    status = "Enabled"
  }

}

resource "aws_s3_bucket_policy" "logs_bucket_policy" {
  bucket     = aws_s3_bucket.logs_bucket.id
  depends_on = [aws_s3_bucket.logs_bucket]

  policy = <<EOF
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
            "Resource": "${aws_s3_bucket.logs_bucket.arn}/*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::507241528517:root"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.logs_bucket.arn}/*"
        },
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "delivery.logs.amazonaws.com"
          },
          "Action": "s3:PutObject",
          "Resource": "${aws_s3_bucket.logs_bucket.arn}/*",
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
          "Resource": "${aws_s3_bucket.logs_bucket.arn}"
        },
        {
          "Sid": "InventoryAndAnalyticsExamplePolicy",
          "Effect": "Allow",
          "Principal": {
              "Service": "s3.amazonaws.com"
          },
          "Action": [
              "s3:PutObject"
          ],
          "Resource": [
              "${aws_s3_bucket.logs_bucket.arn}/*"
          ],
          "Condition": {
              "ArnLike": {
                  "aws:SourceArn": "arn:aws:s3:::serasaexperian-mlcoe-prod-books"
              },
              "StringEquals": {
                  "aws:SourceAccount": "${data.aws_caller_identity.current.account_id}",
                  "s3:x-amz-acl": "bucket-owner-full-control"
              }
          }
        },
        {
           "Sid": "S3PolicyStmt-DO-NOT-MODIFY-1648236788172",
           "Effect": "Allow",
           "Principal": {
               "Service": "logging.s3.amazonaws.com"
           },
           "Action": "s3:PutObject",
           "Resource": "${aws_s3_bucket.logs_bucket.arn}/*"
        }
    ]
}
EOF

}


