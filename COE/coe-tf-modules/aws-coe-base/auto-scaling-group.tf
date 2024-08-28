## Get the last bottlerocket AMI
data "aws_ami" "eec_latest_ami" {
  most_recent = true
  owners      = ["363353661606"]
  filter {
    name   = "name"
    values = ["eec_aws_amzn-lnx_2*"]

  }
}

resource "aws_launch_template" "aws-base" {
  name_prefix   = "aws-base"
  image_id      = data.aws_ami.eec_latest_ami.id
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "aws-base" {
  desired_capacity    = 0
  max_size            = 0
  min_size            = 0
  vpc_zone_identifier = data.aws_subnets.internal_experian.ids
  launch_template {
    id      = aws_launch_template.aws-base.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = local.default_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

}


