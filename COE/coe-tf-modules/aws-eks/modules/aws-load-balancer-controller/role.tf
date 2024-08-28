resource "aws_iam_role" "BURoleForAwsLoadbalanceController" {
  name_prefix = "BURoleForAwsLoadbalanceController-"
  tags        = local.default_tags
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
      {
        Effect : "Allow",
        Principal : {
          Federated : var.oidc_provider_arn
        },
        Action : "sts:AssumeRoleWithWebIdentity"
      }
    ]
  })
  permissions_boundary = var.eec_boundary_policy
}


resource "aws_iam_role_policy_attachment" "BURoleForAwsLoadbalanceController" {
  policy_arn = aws_iam_policy.BUPolicyForAwsLoadbalanceController.arn
  role       = aws_iam_role.BURoleForAwsLoadbalanceController.name
}

