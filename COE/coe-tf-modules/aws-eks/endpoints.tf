# resource "aws_vpc_endpoint" "eksCluster" {
#   for_each = toset(var.aws_endpoints_urls)

#   vpc_id       = data.aws_vpc.selected.id
#   service_name = each.key
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [
#     aws_security_group.endpoints.id,
#   ]

#   subnet_ids = data.aws_subnets.experian.ids

#   tags = {
#      ManagedBy = "Terraform"
#   }
# }
