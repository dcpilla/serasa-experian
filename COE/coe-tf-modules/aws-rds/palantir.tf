locals {
  # This will be replace by a provider in future
  palantir_aws_account_id = {
    sandbox = "294463638235"
    dev     = "294463638235"
    uat     = "201085490967"
    prod    = "833589082975"

  }
}

data "aws_iam_policy" "eec_boundary_policy" {
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/BUAdminBasePolicy"
}

resource "aws_iam_policy" "db-palantir-policy" {
  name   = "BUPolicyFor${var.application_name}Access"
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "rds-db:connect"
        ],
        "Resource": [
          "arn:aws:rds-db:${var.aws_region}:${data.aws_caller_identity.current.account_id}:dbuser:${aws_db_instance.rds_db.id}/user_palantir_view"
        ]
      }
    ]
  }
  EOF
}

resource "aws_iam_role" "db-palantir-role" {
  name = "BURoleFor${var.application_name}Access"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${local.palantir_aws_account_id["${lower(var.env)}"]}:role/BURoleForpalantirRDSAccess"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  permissions_boundary = data.aws_iam_policy.eec_boundary_policy.arn

}

resource "aws_iam_role_policy_attachment" "db-palantir-attach" {
  role       = aws_iam_role.db-palantir-role.name
  policy_arn = aws_iam_policy.db-palantir-policy.arn
}
