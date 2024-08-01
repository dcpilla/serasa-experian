output "aws_lb_id" {
    description     = "Load balance ID"
    value           = aws_lb.lb.*.id
}

output "aws_lb_name" {
    description     = "Load balance name"
    value           = aws_lb.lb.*.name
}

output "aws_lb_type" {
    description     = "Load balance type"
    value           = aws_lb.lb.*.load_balancer_type
}

output "aws_lb_dns_name" {
    description = "The DNS name of the LB presumably to be used with a friendlier CNAME"
    value = aws_lb.lb.*.dns_name
}

output "aws_lb_zone_id" {
    description = "The zone_id of the LB to assist with crating DNS records"
    value = aws_lb.lb.*.zone_id
}