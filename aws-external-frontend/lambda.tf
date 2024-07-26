### Lambda@Edge function for CloudFront public access restriction

resource "aws_lambda_function" "incapsula_whitelist" {
  depends_on = [aws_iam_role.lambda_invoke]

  function_name = "incapsula-whitelist_${var.app_name}-${var.environment}"
  filename      = "${path.module}/resources/experian-incapsula-whitelist.zip"
  role          = aws_iam_role.lambda_invoke.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  publish       = true

  tags = {
    Environment  = local.env
    AppID        = var.app_gearr_id
    CostString   = var.cost_center
    Project      = var.project_name
    BusinessUnit = var.business_unit
    ManagedBy    = "Terraform"
  }

}
