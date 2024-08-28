resource "aws_s3_bucket" "app_bucket_studio-workspace" {
  bucket =   var.team != "" ? replace(lower("serasaexperian-${var.project_name}-workspace-${var.team}-${var.env}"), "_", "-") : "serasaexperian-${var.project_name}-workspace-${var.env}"
  tags = merge(
    local.default_tags,
    local.data_cluster_workspace_metadata_tags, var.team != "" ?
    {
      Name =   replace(lower("serasaexperian-${var.project_name}-workspace-${var.team}-${var.env}"), "_", "-")
    } : {
      Name =   "serasaexperian-${var.project_name}-workspace-${var.env}"
    } 
  )
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_bucket_access_encryption_emr-workspace" {
  bucket = aws_s3_bucket.app_bucket_studio-workspace.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "app_bucket_access_version_emr-workspace" {
  bucket = aws_s3_bucket.app_bucket_studio-workspace.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "app_bucket_access_block_emr-workspace" {
  bucket                  = aws_s3_bucket.app_bucket_studio-workspace.id
  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_s3_bucket_ownership_controls" "app_bucket_emr-workspace" {
  bucket = aws_s3_bucket.app_bucket_studio-workspace.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_policy" "app_bucket_policy_emr-workspace" {
  bucket = aws_s3_bucket.app_bucket_studio-workspace.id
  policy = data.template_file.aws_s3_emr-workspace_policy.rendered
}
