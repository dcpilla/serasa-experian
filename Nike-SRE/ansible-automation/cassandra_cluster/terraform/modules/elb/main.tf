resource "aws_lb" "lb" {
  depends_on = [aws_s3_bucket.lb_logs]

  name                             = "${var.lb_name}-lb"
  internal                         = var.lb_internal
  load_balancer_type               = var.lb_type
  ip_address_type                  = var.lb_ip_address_type
  subnets                          = data.aws_subnet_ids.this.ids

  enable_cross_zone_load_balancing = var.lb_enable_cross_zone_load_balancing

  dynamic "access_logs" {
    for_each = length(keys(var.lb_access_logs)) == 0 ? [] : [var.lb_access_logs]
    content {
      bucket  = "${var.lb_bucket}-lb-logs"
      prefix  = "${var.lb_bucket_prefix}"
      enabled =  true
    }
  }

  tags = "${merge(tomap({
    Environment          = var.env
    Project              = var.project_name
   }), var.lb_tags
  )}"
}

resource "aws_lb_listener" "lb_listener" {
  for_each = var.lb_ports

  load_balancer_arn = aws_lb.lb.arn
  protocol          = each.value["protocol"]
  port              = each.value["port"]

  certificate_arn = upper(each.value["protocol"]) == "TLS" ? var.lb_ssl_arn : null
  ssl_policy      = upper(each.value["protocol"]) == "TLS" ? var.lb_security_policy : null
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group[lower(each.value["protocol"])].arn
  }
}

resource "aws_lb_target_group" "lb_target_group" {
  for_each = var.lb_ports

  vpc_id            = data.aws_vpc.selected.id
  name              = var.lb_autoscaling_group_name == null ? "${var.project_name}-autoscaling" : "${var.project_name}-${var.lb_autoscaling_group_name}-autoscaling" 
  protocol          = each.value["protocol"]
  port              = each.value["port"]

  depends_on = [
    aws_lb.lb
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# TODO. Implement HERE aws_lb_target_group_attachment to instance attach

# TODO. Implement HERE aws_autoscaling_attachment to instance autoscaling attach

#resource "aws_autoscaling_attachment" "lb_target" {
#  for_each = var.lb_ports
#
#  autoscaling_group_name = var.lb_autoscaling_group_name == null ? "${var.project_name}-autoscaling" : "${var.project_name}-${var.lb_autoscaling_group_name}-autoscaling"
#  alb_target_group_arn   = aws_lb_target_group.lb_target_group[lower(each.value["protocol"])].arn
#
#  depends_on = [
#    aws_lb.lb,
#    aws_lb_target_group.lb_target_group
#  ]
#}
