
## First Step Portfolio Creation
resource "aws_servicecatalog_portfolio" "portfolio" {
  name          =  var.team != "" ? replace(lower("${var.project_name}-portifolio-${var.team}"),"_","-") : "${var.project_name}-portifolio"
  description   = "List of Data Engineering APPs"
  provider_name = "Data Solutions"
}

## Create a bucket to upload Cloudformation Stack to be used
resource "aws_s3_bucket" "cloudformation_template_bucket" {
    bucket = var.s3_cfn_template

    tags = merge(
        var.tags,
        local.data_cloudformation_metadata_tags,
        {
            Name = var.s3_cfn_template
        }
    )
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudformation_template_access_encryption_bucket" {
  bucket = aws_s3_bucket.cloudformation_template_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "cloudformation_template_access_version_bucket" {
  bucket = aws_s3_bucket.cloudformation_template_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "cloudformation_template_access_block_bucket" {
  bucket                  = aws_s3_bucket.cloudformation_template_bucket.id
  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_s3_bucket_ownership_controls" "cloudformation_template_access_ownership_controls_bucket" {
  bucket =  aws_s3_bucket.cloudformation_template_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
## Upload CloudFormation EMR on CF Template bucket

resource "aws_s3_object" "object" {
  bucket =  aws_s3_bucket.cloudformation_template_bucket.id
  key    = "emr.yml"
  content = data.template_file.cf-template-emr.rendered

}

resource "aws_s3_object" "bootstrap_script_object" {
  depends_on = [ data.template_file.bootstrap_script ]
  bucket =  aws_s3_bucket.cloudformation_template_bucket.id
  key    = var.team != "" ? replace(lower("bootstrap-scripts/bootstrap-script-${var.team}.sh"),"_","-") : "bootstrap-scripts/bootstrap-script.sh"
  content = data.template_file.bootstrap_script.rendered
}

## Create Service Catalog Product

resource "aws_servicecatalog_product" "emr" {
  name  = var.team != "" ? replace(lower("${var.application_name}-${var.team}"),"_","-") : var.application_name
  owner = "Data Solutions"
  type  = "CLOUD_FORMATION_TEMPLATE"

  provisioning_artifact_parameters {
    template_url = "https://s3.amazonaws.com/${aws_s3_object.object.bucket}/${aws_s3_object.object.id}"
    type = "CLOUD_FORMATION_TEMPLATE"
  }
  lifecycle {
    replace_triggered_by = [
      aws_s3_object.object
    ]
  }
  tags = local.default_tags
}

## Associating Product to Portfolio
resource "aws_servicecatalog_product_portfolio_association" "emr_association" {
  portfolio_id = aws_servicecatalog_portfolio.portfolio.id
  product_id   = aws_servicecatalog_product.emr.id
}

## Giving Access for this Product to Principal Porftolio
resource "aws_servicecatalog_principal_portfolio_association" "principal_association" {
  portfolio_id  = aws_servicecatalog_portfolio.portfolio.id
  principal_arn = data.aws_iam_role.role_admin.arn
}
resource "aws_servicecatalog_principal_portfolio_association" "principal_association_user" {
  portfolio_id  = aws_servicecatalog_portfolio.portfolio.id
  principal_arn = aws_iam_role.user[0].arn
}