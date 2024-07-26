data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

## VPC

data "aws_vpc" "selected" {
  tags = {
    AWS_Solutions = "LandingZoneStackSet"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  tags = {
    Network = "Private"
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

data "aws_vpc_endpoint" "s3" {
  vpc_id       = data.aws_vpc.selected.id
  service_name = "com.amazonaws.sa-east-1.s3"
  filter {
    name   = "vpc-endpoint-type"
    values = ["Interface"]
  }
}

data "aws_network_interface" "s3_aws_vpc_endpoint" {
  for_each = data.aws_vpc_endpoint.s3.network_interface_ids
  id = each.key
}

data "aws_route53_zone" "private" {
  name         = var.certificate_domain
  private_zone = true
}
