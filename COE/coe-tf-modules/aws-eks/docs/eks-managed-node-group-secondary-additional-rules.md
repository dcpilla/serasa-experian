# Additionals Rules for POD (Secondary CNI) SGs

## Examples

´´´
eks_managed_node_group_secondary_additional_rules = {
    ingres_ports_tcp = {
      description = "Open 443 to Experian network"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = ["10.0.0.0/8"]
    }
     egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
}
´´´