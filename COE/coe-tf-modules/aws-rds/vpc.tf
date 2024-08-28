data "aws_vpc" "selected" {
  tags = var.vpc_tag_for_select
}

data "aws_subnets" "subnets_rds" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  tags = var.vpc_tag_for_select_subnets
}
