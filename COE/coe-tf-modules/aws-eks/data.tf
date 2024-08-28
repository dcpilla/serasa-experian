data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

## EKS
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

data "aws_ecr_authorization_token" "token" {
  registry_id = var.resources_aws_account
}

## IAM
data "aws_iam_policy" "ssm_instance" {
  name = "AmazonSSMManagedInstanceCore"
}
data "aws_iam_policy" "ec2_container" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}

data "aws_iam_policy" "eec_boundary_policy" {
  name = "BUAdminBasePolicy"
}

## Get the last bottlerocket AMI
data "aws_ami" "eec_bottlerocket_ami" {
  most_recent = true
  owners = [
    "363353661606",
    "044060155884"
  ]
  filter {
    name   = "name"
    values = local.ami_filter

  }
}

## VPC
data "aws_vpc" "selected" {
  tags = {
    AWS_Solutions = "LandingZoneStackSet"
  }
}

data "aws_subnets" "experian" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = merge({
    Network = "Private"
  }, var.aws_subnets_experian_filter_tags)
}

data "aws_subnets" "internal_pods" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  tags = {
    Network = "Pod"
  }
}

data "aws_subnet" "internal_pods" {

  for_each = toset(try(data.aws_subnets.internal_pods.ids, []))
  id       = each.key
}

data "aws_subnet" "eec_subnets" {

  for_each = toset(data.aws_subnets.experian.ids)
  id       = each.key

}
