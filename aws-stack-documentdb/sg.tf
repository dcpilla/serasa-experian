## Configurações para o Security Group ##

resource "aws_security_group" "this" {
  count = local.sg_exists != "exists" ? 1 : 0

  name        = local.default_security_group
  description = "Allow traffic for cluster DocumentDB"
  vpc_id      = data.aws_vpc.selected.id

  tags = local.tags
}


## Cria SG para DocumentDB
resource "aws_security_group_rule" "docdb_sg_inbound_experian" {
  count = local.sg_exists != "exists" ? 1 : 0

  type              = "ingress"
  security_group_id = aws_security_group.this[0].id
  from_port         = var.port 
  to_port           = var.port 
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  description       = "Experian network"
}

resource "aws_security_group_rule" "docdb_sg_inbound_eks" {
  count = local.sg_exists != "exists" ? 1 : 0

  type              = "ingress"
  security_group_id = aws_security_group.this[0].id
  from_port         = var.port 
  to_port           = var.port 
  protocol          = "tcp"
  cidr_blocks       = ["100.64.0.0/16"]
  description       = "EKS network"
}

resource "aws_security_group_rule" "docdb_sg_outbound" {
  count = local.sg_exists != "exists" ? 1 : 0

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this[0].id
  description       = "Amazon outbound access"
}
