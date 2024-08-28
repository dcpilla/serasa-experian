data "aws_iam_account_alias" "current" {}

locals {
  documention = <<EOF

  # AWS COE BASE ${data.aws_iam_account_alias.current.account_alias} Documentation
  
  ## ${var.env}
  
  Documentation related to this project

  ## Account Informations

  |NAME|URL/ID|OBS|
  |---|---|---|
  |AWS Account |${data.aws_caller_identity.current.account_id}|Auth OKTA|
  |Bucket TF state|${aws_s3_bucket.tf_state.bucket}||
  |Default Endpoints|${replace(join(", ", var.aws_endpoints_urls), ", ", " <br> ")}||
  |VPC|${data.aws_vpc.selected.id}|${replace(join(", ", local.cidrs), ", ", " <br> ")}|
  |SNS IAM role <br> for successful and failed deliveries|${aws_iam_role.BURoleForSNSLog.arn}||

  EOF

  path_doc_file = "${var.path_documentation_file}/docs/${var.env}.md"

}
resource "local_file" "environment" {
  content  = format("%s\n%s", local.documention, var.documention)
  filename = local.path_doc_file
}

