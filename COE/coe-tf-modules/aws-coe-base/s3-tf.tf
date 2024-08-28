resource "aws_s3_bucket" "tf_state" {
  depends_on = [
    aws_s3_bucket.logs_bucket,
    aws_s3_bucket_policy.logs_bucket_policy,
  ]

  bucket = "serasaexperian-${var.project_name}-${var.env}-${var.bucket_tf_state_end_name}"

  tags = merge({
    Asset_Category = "Metadata"
    Data_Type      = "N/A"
    Data_Category  = "N/A"
  }, local.default_tags)

}

resource "aws_s3_bucket_logging" "tf_state_logging" {
  bucket = aws_s3_bucket.tf_state.id

  target_bucket = aws_s3_bucket.logs_bucket.id
  target_prefix = "logs-tf/"
}

resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_encryption" {
  bucket = aws_s3_bucket.tf_state.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state_access_block" {
  depends_on = [
    aws_s3_bucket.tf_state,
    aws_s3_bucket_public_access_block.logs_bucket_access_block,
  ]
  bucket                  = aws_s3_bucket.tf_state.id
  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}

# data "aws_iam_policy_document" "tf_state" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
#     }

#     actions   = ["s3:*"]
#     resources = ["${aws_s3_bucket.tf_state.arn}", "${aws_s3_bucket.tf_state.arn}/*"]
#   }

# }

# resource "aws_s3_bucket_policy" "tf_state" {
#   bucket     = aws_s3_bucket.tf_state.id
#   policy = data.aws_iam_policy_document.tf_state.json
# }