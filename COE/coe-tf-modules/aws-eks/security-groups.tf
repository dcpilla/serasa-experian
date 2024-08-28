resource "aws_security_group" "one" {
  name_prefix = "${var.project_name}-eks-group-one"
  vpc_id      = data.aws_vpc.selected.id
  tags        = local.default_tags_eks
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
  #Enable master to node Metrics
  ingress {
    from_port   = 4443
    to_port     = 4443
    protocol    = "tcp"
    description = "Metric port"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }
  #Enable master to Istio
  ingress {
    from_port   = 15017
    to_port     = 15017
    protocol    = "tcp"
    description = "Istiod port"
    cidr_blocks = local.cidrs
  }
  #Enable master to Istio
  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    description = "Istiod port"
    cidr_blocks = local.cidrs
  }
  #Enable master to Istio
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "Istiod port HTTPS"
    cidr_blocks = local.cidrs
  }

  #Enable External comunication with LOKI
  ingress {
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    description = "Loki port"
    cidr_blocks = local.cidrs
  }
  ingress {
    from_port   = 9443
    to_port     = 9443
    protocol    = "tcp"
    description = "AWS load Balancer Controller"
    cidr_blocks = local.cidrs
  }
}

resource "aws_security_group" "eks_managed_node_group_secondary_additional" {

  name_prefix = "eks_managed_node_group_secondary_additional"
  description = "SG for Secondary IP address"
  vpc_id      = data.aws_vpc.selected.id

  tags = local.default_tags_eks

}

resource "aws_security_group_rule" "eks_managed_node_group_secondary_additional_rules" {
  for_each = { for k, v in merge(local.eks_managed_node_group_secondary_additional_rules, var.eks_managed_node_group_secondary_additional_rules) : k => v }

  # Required
  security_group_id = aws_security_group.eks_managed_node_group_secondary_additional.id
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  type              = each.value.type

  # Optional
  description      = try(each.value.description, null)
  cidr_blocks      = try(each.value.cidr_blocks, null)
  ipv6_cidr_blocks = try(each.value.ipv6_cidr_blocks, null)
  prefix_list_ids  = try(each.value.prefix_list_ids, [])
  self             = try(each.value.self, null)
}
