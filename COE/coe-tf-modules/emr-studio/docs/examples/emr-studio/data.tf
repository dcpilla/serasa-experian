data "aws_caller_identity" "current" {}

# get GIT URL
data "git_remote" "remote" {
  directory = "../../"
  name      = "origin"
}

# get commit by parent
data "git_commit" "head_shortcut" {
  directory = "../../"
  revision  = "@"
}


data "aws_iam_policy" "eec_boundary_policy" {
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/BUAdminBasePolicy"
}

data "template_file" "aws_s3_emr-workspace_policy" {
  template = file("${path.module}/policies/s3/s3-emr-workspace-policy.json.tmpl")
  vars = {
    bucket_arn = aws_s3_bucket.app_bucket_studio-workspace.arn
    account_id = data.aws_caller_identity.current.account_id
  }
  depends_on = [aws_s3_bucket.app_bucket_studio-workspace]
}

data "aws_iam_policy_document" "aws_emr_role_dev_policy" {

  statement {
    sid = "AllowS3ListOperation"
    actions = [
      "s3:ListBucket"
    ]
    resources = concat(tolist([for name in concat(var.buckets_name_allow_emr_studio_role) : "arn:aws:s3:::${name}"]),
      tolist([for name in var.buckets_name_allow_emr_role : "arn:aws:s3:::${name}"]),
      [
        "arn:aws:s3:::serasaexperian-${var.project_name}-cfn-tmpl-${var.env}"
      ]
    )
  }

  statement {
    sid = "AllowS3GPDOperations"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = concat(tolist([for name in var.buckets_name_allow_emr_studio_role : "arn:aws:s3:::${name}/*"]),
      tolist([for name in var.buckets_name_allow_emr_role : "arn:aws:s3:::${name}/*"])
    )
  }

  statement {
    sid = "AllowS3GetOperations"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::serasaexperian-${var.project_name}-cfn-tmpl-${var.env}/bootstrap-scripts/*"
    ]
  }

  statement {
    sid = "AllowEMRTerminate"
    actions = [
      "elasticmapreduce:TerminateJobFlows"
    ]
    resources = [
      "*"
    ]

    condition {
      test     = "StringLikeIfExists"
      variable = "elasticmapreduce:ResourceTag/Team"
      values = [
        "${var.team}"
      ]
    }
  }

  statement {
    sid = "AllowEC2BasicActions"
    actions = [
      "ec2:DescribeInstances"
    ]
    resources = [
      "*"
    ]
  }

}

data "aws_iam_policy_document" "additional_user_dev_policy" {
  statement {
    sid = ""
    actions = [
      "",
    ]

    resources = [
      "",
    ]
  }
}


data "template_file" "aws-emr-role-trust-policy" {
  template = file("${path.module}/policies/emr/emr-trust-policy.json")
  vars = {
    account_id = data.aws_caller_identity.current.account_id
  }
}