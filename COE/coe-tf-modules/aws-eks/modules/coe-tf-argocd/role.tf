resource "aws_iam_role" "BURoleForDexAccessSecretsManager" {
  name_prefix = "BURoleForDexAccessSecretsManager-"
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
  permissions_boundary = data.aws_iam_policy.eec_boundary_policy.arn
}

resource "aws_iam_role_policy_attachment" "BURoleForDexAccessSecretsManager-attach" {
  role = aws_iam_role.BURoleForDexAccessSecretsManager.name
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  ])
  policy_arn = each.value
}

resource "aws_iam_role" "BURoleForDeployAccessSecretsManager" {
  name_prefix = "BURoleForDeployAccessSecretsManager-"
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
  permissions_boundary = data.aws_iam_policy.eec_boundary_policy.arn
}

resource "aws_iam_role_policy_attachment" "BURoleForDeployAccessSecretsManager-attach" {
  role = aws_iam_role.BURoleForDeployAccessSecretsManager.name
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  ])
  policy_arn = each.value
}


resource "aws_iam_role" "BURoleForMonitoringASM" {
  name_prefix = "BURoleForMonitoringASM-"
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
  permissions_boundary = data.aws_iam_policy.eec_boundary_policy.arn
}

resource "aws_iam_role_policy_attachment" "BURoleForMonitoringASM" {
  role = aws_iam_role.BURoleForMonitoringASM.name
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  ])
  policy_arn = each.value
}
