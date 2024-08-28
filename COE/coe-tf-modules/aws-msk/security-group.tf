resource "aws_security_group" "msk" {
  name_prefix = "${var.project_name}-eks-group-one"
  vpc_id      = data.aws_vpc.selected.id
  tags        = local.default_tags

  #Enable master to node Metrics
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "Metric port"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  ingress {
    from_port   = 9090
    to_port     = 9098
    protocol    = "tcp"
    description = "MSK"
    cidr_blocks = var.ip_to_access_brokers
  }

  ingress {
    from_port   = 2181
    to_port     = 2182
    protocol    = "tcp"
    description = "MSK ZK"
    cidr_blocks = var.ip_to_access_brokers
  }

  ingress {
    from_port   = 11001
    to_port     = 11002
    protocol    = "tcp"
    description = "MSK Open Monitoring metrics port"
    cidr_blocks = var.ip_to_access_brokers
  }  

}
