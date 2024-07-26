### ELB Provisioning

resource "aws_lb_target_group" "elb_target_group" {
  name        = local.app_name
  port        = 443
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = data.aws_vpc.selected.id

  health_check {
    path                = "/"
    protocol            = "HTTPS"
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200,307,405"
  }

  tags = {
    Environment  = local.env
    AppID        = var.app_gearr_id
    CostString   = var.cost_center
    Project      = var.project_name
    BusinessUnit = var.business_unit
    ManagedBy    = "Terraform"
  }
}

resource "aws_lb_target_group_attachment" "elb_target_group_attachment" {
  for_each         = data.aws_network_interface.s3_aws_vpc_endpoint
  target_group_arn = aws_lb_target_group.elb_target_group.arn
  target_id        = each.value.private_ip
  port             = 443
}

resource "aws_lb" "elb" {
  name                       = local.app_name
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.elb_sg.id]
  subnets                    = [for subnet in data.aws_subnet.private : subnet.id]
  enable_deletion_protection = false
  tags = {
    Environment  = local.env
    AppID        = var.app_gearr_id
    CostString   = var.cost_center
    Project      = var.project_name
    BusinessUnit = var.business_unit
    ManagedBy    = "Terraform"
  }
}

resource "aws_lb_listener" "elb_listener" {
  load_balancer_arn = aws_lb.elb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.elb_target_group.arn
  }
}

resource "aws_lb_listener_rule" "elb_listener_redirect_rule" {
  listener_arn = aws_lb_listener.elb_listener.arn
  priority     = 1
  action {
    type = "redirect"
    redirect {
      protocol    = "HTTPS"
      port        = "#{port}"
      host        = "#{host}"
      path        = "/#{path}index.html"
      query       = "#{query}"
      status_code = "HTTP_301"
    }
  }
  condition {
    path_pattern {
      values = ["*/"]
    }
  }
}

### Route53 DNS Record
resource "aws_route53_record" "elb_dns_record" {
  zone_id = data.aws_route53_zone.private.zone_id
  name    = replace(local.domain_name, ".${var.certificate_domain}", "")
  type    = "A"
  alias {
    name                   = aws_lb.elb.dns_name
    zone_id                = aws_lb.elb.zone_id
    evaluate_target_health = true
  }
}
