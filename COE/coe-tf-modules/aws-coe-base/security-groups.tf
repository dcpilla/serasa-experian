resource "aws_security_group" "endpoints" {
  vpc_id      = data.aws_vpc.selected.id
  description = var.aws_security_group_description

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = flatten([local.cidrs, var.endpoint_allowed_ip])
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = flatten([local.cidrs, var.endpoint_allowed_ip])
  }

  tags = local.default_tags
}
