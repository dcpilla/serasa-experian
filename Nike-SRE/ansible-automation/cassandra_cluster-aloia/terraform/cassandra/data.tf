data "aws_caller_identity" "current" {}

## AMI

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners   = [data.aws_caller_identity.current.account_id, "amazon"]

  filter {
    name   = "owner-alias"
    values = [data.aws_caller_identity.current.account_id, "amazon"] 
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"] 
  }

  filter {
    name  = "architecture"
    values = ["x86_64"] 
  }
}

## VPC
data "aws_vpc" "selected" {
  tags = {
    AWS_Solutions = "LandingZoneStackSet"
  }
}

data "aws_subnet_ids" "this" {
  vpc_id = data.aws_vpc.selected.id

  tags = {
    Network = "Private"
  }
}
