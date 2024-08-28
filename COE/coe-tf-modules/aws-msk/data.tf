data "aws_caller_identity" "current" {}

## VPC
data "aws_vpc" "selected" {
  tags = {
    AWS_Solutions = "LandingZoneStackSet"
  }
}
data "aws_kms_key" "kafka" {
  key_id = "alias/aws/kafka"
}


data "aws_subnets" "experian" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    Network = "Private"
  }
}

data "aws_subnet" "eec_subnets" {

  for_each = toset(data.aws_subnets.experian.ids)
  id       = each.key

}


# KMS policy
data "aws_iam_policy_document" "kms" {
  statement {
    sid = "KMS-Default"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "kms:*",
    ]

    resources = [
      "*",
    ]
  }
}
