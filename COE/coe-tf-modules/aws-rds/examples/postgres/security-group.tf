
resource "aws_security_group" "one" {
  name_prefix = "${var.project_name}-rds-one"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    description = "DB port"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  lifecycle {
    create_before_destroy = true
  }

}