data "aws_caller_identity" "current" {}

data "aws_iam_policy" "eec_boundary_policy" {
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/BUAdminBasePolicy"
}



### Create Permissions policies
resource "aws_iam_role_policy" "BUPolicyForDevelopersAccessS3Heimdall" {
  name = "BUPolicyForDevelopersAccessS3Heimdall"
  role = aws_iam_role.BURoleForDevelopersAccess[0].id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "s3:*t"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:s3:::serasaexperian-mlcoe-${var.env}-heimdall-raw-data",
          "arn:aws:s3:::serasaexperian-mlcoe-${var.env}-heimdall-raw-data/*"
        ]
      }
    ]
  })
  count = var.env == "dev" || var.env == "uat" ? 1 : 0
}

resource "aws_iam_role_policy" "BUPolicyForDevelopersAccessS3EMR" {
  name = "BUPolicyForDevelopersAccessS3EMR"
  role = aws_iam_role.BURoleForDevelopersAccess[0].id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "s3:Get*",
          "s3:List*",
        ],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:s3:::serasaexperian-mlcoe-${var.env}-emr-logs",
          "arn:aws:s3:::serasaexperian-mlcoe-${var.env}-emr-logs/*"
        ]
      }
    ]
  })
  count = var.env == "dev" || var.env == "uat" ? 1 : 0
}

resource "aws_iam_role_policy" "BUPolicyForDevelopersListS3" {
  name = "BUPolicyForDevelopersListS3"
  role = aws_iam_role.BURoleForDevelopersAccess[0].id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "s3:List*"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
  count = var.env == "dev" || var.env == "uat" ? 1 : 0
}

resource "aws_iam_role_policy" "BUPolicyForDevelopersAccessS3Airflow" {
  name = "BUPolicyForDevelopersAccessS3Airflow"
  role = aws_iam_role.BURoleForDevelopersAccess[0].id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "s3:List*",
        ],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:s3:::serasaexperian-mlcoe-${var.env}-airflow",
          "arn:aws:s3:::serasaexperian-mlcoe-${var.env}-airflow/artifacts/*"
        ]
      },
      {
        "Action" : [
          "s3:PutObject",
          "s3:Get*",
        ],
        "Effect" : "Allow",
        "Resource" : "arn:aws:s3:::serasaexperian-mlcoe-${var.env}-airflow/artifacts/*"
      }
    ]
  })

  count = var.env == "dev" || var.env == "uat" ? 1 : 0
}

resource "aws_iam_role_policy" "BUPolicyForDevelopersAccessLambda" {
  name = "BUPolicyForDevelopersAccessLambda"
  role = aws_iam_role.BURoleForDevelopersAccess[0].id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Stmt1624308334198",
        "Action" : [
          "lambda:Get*",
          "lambda:InvokeAsync",
          "lambda:InvokeFunction",
          "lambda:List*",
          "lambda:PublishLayerVersion",
          "lambda:PublishVersion",
          "lambda:Put*",
          "lambda:RemoveLayerVersionPermission",
          "lambda:TagResource",
          "lambda:UntagResource",
          "lambda:UpdateAlias",
          "iam:List*"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })

  count = var.env == "dev" || var.env == "uat" ? 1 : 0
}

resource "aws_iam_role_policy" "BUPolicyForDevelopersAccessEMR" {
  name = "BUPolicyForDevelopersAccessEMR"
  role = aws_iam_role.BURoleForDevelopersAccess[0].id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Stmt1624308580397",
        "Action" : [
          "emr-containers:*",
          "elasticmapreduce:*"

        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
  count = var.env == "dev" || var.env == "uat" ? 1 : 0
}

resource "aws_iam_role_policy" "BUPolicyForDevelopersAdditional" {
  name = "BUPolicyForDevelopersAdditional"
  role = aws_iam_role.BURoleForDevelopersAccess[0].id
  policy = jsonencode(local.aditional_policy)
  count = var.env == "dev" || var.env == "uat" ? 1 : 0
}

resource "aws_iam_policy" "BUPolicyForSNSLog" {
  name = "BUPolicyForSNSLog"
  path = "/"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:PutMetricFilter",
          "logs:PutRetentionPolicy"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
  tags = local.default_tags
}



### Create Role
resource "aws_iam_role" "BURoleForDevelopersAccess" {
  name = "BURoleForDevelopersAccess"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:saml-provider/OktaSSO"
        },
        "Action" : "sts:AssumeRoleWithSAML",
        "Condition" : {
          "StringEquals" : {
            "SAML:aud" : "https://signin.aws.amazon.com/saml"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::294463638235:role/BURoleForDevelopersAccess"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  permissions_boundary = data.aws_iam_policy.eec_boundary_policy.arn

  max_session_duration = "43200"

  tags  = local.default_tags
  count = var.env == "dev" || var.env == "uat" ? 1 : 0
}


resource "aws_iam_role" "BURoleForSRE" {
  name = "BURoleForSRE"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:saml-provider/OktaSSO"
        },
        "Action" : "sts:AssumeRoleWithSAML",
        "Condition" : {
          "StringEquals" : {
            "SAML:aud" : "https://signin.aws.amazon.com/saml"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${var.assume_role_account_id}:role/BUAdministratorAccessRole"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  permissions_boundary = data.aws_iam_policy.eec_boundary_policy.arn

  max_session_duration = "43200"

  tags = local.default_tags
}


resource "aws_iam_role" "BURoleForBillingAccess" {
  name = "BURoleForBillingAccess"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:saml-provider/OktaSSO"
        },
        "Action" : "sts:AssumeRoleWithSAML",
        "Condition" : {
          "StringEquals" : {
            "SAML:aud" : "https://signin.aws.amazon.com/saml"
          }
        }
      }
    ]
  })
  permissions_boundary = data.aws_iam_policy.eec_boundary_policy.arn


}


# Role to SNS write logs in cloudwatch
resource "aws_iam_role" "BURoleForSNSLog" {
  name = "BURoleForSNSLog"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "sns.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  permissions_boundary = data.aws_iam_policy.eec_boundary_policy.arn
  tags                 = local.default_tags
}


### Attach policy in role
resource "aws_iam_role_policy_attachment" "BURoleForDevelopersAccess-AmazonEMRServicePolicy_v2" {
  role       = aws_iam_role.BURoleForDevelopersAccess[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEMRServicePolicy_v2"
}

resource "aws_iam_role_policy_attachment" "BURoleForDevelopersAccess-ReadOnlyAccess" {
  role       = aws_iam_role.BURoleForDevelopersAccess[0].name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "BURoleForDevelopersAccess-ServiceQuotasReadOnlyAccess" {
  role       = aws_iam_role.BURoleForDevelopersAccess[0].name
  policy_arn = "arn:aws:iam::aws:policy/ServiceQuotasReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "BURoleForDevelopersAccess-AWSSupportAccess" {
  role       = aws_iam_role.BURoleForDevelopersAccess[0].name
  policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
}

resource "aws_iam_role_policy_attachment" "BURoleForSRE-attach" {
  role       = aws_iam_role.BURoleForSRE.name
  policy_arn = data.aws_iam_policy.eec_boundary_policy.arn
}

resource "aws_iam_role_policy_attachment" "BURoleForSNSLog-attach" {
  role       = aws_iam_role.BURoleForSNSLog.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}
resource "aws_iam_role_policy_attachment" "BURoleForSNSLog-attach2" {
  role       = aws_iam_role.BURoleForSNSLog.name
  policy_arn = aws_iam_policy.BUPolicyForSNSLog.arn
}

resource "aws_iam_role_policy_attachment" "BURoleForBillingAccess-attach" {
  role       = aws_iam_role.BURoleForBillingAccess.name
  policy_arn = "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess"
}

