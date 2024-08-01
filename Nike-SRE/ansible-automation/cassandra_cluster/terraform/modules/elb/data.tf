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

data "aws_caller_identity" "current" {}
