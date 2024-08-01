resource "aws_route53_record" "aws_route53_record_name_a" {
  count   = length(module.cassandra_ec2_instances_1a.get_private_ips) > 0 ? 1 : 0
  zone_id = var.hosted_zone_id
  name    = var.aws_route53_record_name["a"]
  type    = "A"
  ttl     = "300"
  records = [module.cassandra_ec2_instances_1a.get_private_ips[0]]
}

resource "aws_route53_record" "aws_route53_record_name_b" {
  count   = length(module.cassandra_ec2_instances_1b.get_private_ips) > 0 ? 1 : 0
  zone_id = var.hosted_zone_id
  name    = var.aws_route53_record_name["b"]
  type    = "A"
  ttl     = "300"
  records = [module.cassandra_ec2_instances_1b.get_private_ips[0]]
}

#resource "aws_route53_record" "aws_route53_record_name_c" {
#  count   = length(module.cassandra_ec2_instances_1c.get_private_ips) > 0 ? 1 : 0
#  zone_id = var.hosted_zone_id
#  name    = var.aws_route53_record_name["c"]
#  type    = "A"
#  ttl     = "300"
#  records = [module.cassandra_ec2_instances_1c.get_private_ips[0]]
#}
