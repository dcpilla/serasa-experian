# locals {
#   eks_managed_node_group_secondary_additional_rules = {
#       ingres_ports_gossip = {
#         description = "Stargate GOSSIP"
#         protocol    = "-1"
#         from_port   = 7000
#         to_port     = 7001
#         type        = "ingress"
#         cidr_blocks = ["10.0.0.0/8"]
#       ingres_ports_gossip_2 = {
#         description = "Stargate GOSSIP"
#         protocol    = "-1"
#         from_port   = 9042
#         to_port     = 9042
#         type        = "ingress"
#         cidr_blocks = ["10.0.0.0/8"]
#       }
#       }
#   }
# }
