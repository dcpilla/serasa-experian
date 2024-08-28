data "aws_vpc" "selected" {
  tags = var.vpc_tag_for_select
}

data "aws_subnets" "internal_experian" {

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    Network = "Private"
  }
}
