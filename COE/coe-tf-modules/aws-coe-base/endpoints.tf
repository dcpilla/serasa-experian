resource "aws_vpc_endpoint" "default_endpoints" {
  for_each = { for k, endpoint in toset(var.aws_endpoints_urls) : k => endpoint if var.aws_endpoints_urls_enabled }


  vpc_id            = data.aws_vpc.selected.id
  service_name      = each.key
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.endpoints.id,
  ]
  private_dns_enabled = true
  subnet_ids          = data.aws_subnets.internal_experian.ids

  tags = local.default_tags

  depends_on = [
    aws_security_group.endpoints
  ]
}
