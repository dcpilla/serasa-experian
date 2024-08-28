resource "aws_s3_bucket" "main" {

  bucket              = "serasaexperian-${var.project_name}-${var.env}-${var.bucket_experian_prefix}"
  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock_enabled
  tags                = merge(var.data_gov_tags, local.default_tags)

}

resource "aws_s3_bucket_logging" "main" {
  bucket = aws_s3_bucket.main.id

  target_bucket = var.log_target_bucket
  target_prefix = var.log_target_prefix

  dynamic "log_target_grant" {
    
  }

  count = var.log_bucket_used_for_store_log ? 0 : 1
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  depends_on = [
    aws_s3_bucket.main,
    aws_s3_bucket_public_access_block.logs_bucket_access_block,
  ]
  bucket                  = aws_s3_bucket.main.id
  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
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
