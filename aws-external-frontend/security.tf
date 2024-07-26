### Roles and Policies for Lambda@Edge

resource "aws_iam_role" "lambda_invoke" {
  name               = "BURoleForLambda_${var.app_name}-${var.environment}"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "lambda.amazonaws.com",
                    "edgelambda.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
  tags = {
    Environment  = local.env
    AppID        = var.app_gearr_id
    CostString   = var.cost_center
    Project      = var.project_name
    BusinessUnit = var.business_unit
    ManagedBy    = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_invoke.name
}
