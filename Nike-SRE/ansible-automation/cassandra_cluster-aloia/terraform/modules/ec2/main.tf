resource "aws_placement_group" "ec2_pg" {
  count    = var.use_placement_group ? 1 : 0
  name     = "pg-${local.prefix}-${var.placement_group_name}-${data.aws_subnet.subnet.availability_zone}"
  strategy = "cluster"
}

data "aws_subnet" "subnet" {
  vpc_id = var.vpc_id
  tags = {
    Name = var.subnet_name
  }
}

resource "aws_instance" "ec2" {
  count                       = var.instance_count
  ami                         = var.ami
  placement_group             = var.use_placement_group ? aws_placement_group.ec2_pg[0].id : null
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.subnet.id
  vpc_security_group_ids      = var.security_group_ids
  key_name                    = var.keypair_name
  associate_public_ip_address = false
  user_data                   = var.userdata
  iam_instance_profile        = var.iam_instance_profile

  dynamic "metadata_options" {
    for_each = var.metadata_options != null ? [var.metadata_options] : []
    content {
      http_endpoint               = lookup(metadata_options.value, "http_endpoint", "enabled")
      http_tokens                 = lookup(metadata_options.value, "http_tokens", "optional")
      http_put_response_hop_limit = lookup(metadata_options.value, "http_put_response_hop_limit", "1")
    }
  }

  tags = "${merge(tomap({
    Name                 = "${local.prefix}-${count.index +1}-${data.aws_subnet.subnet.availability_zone}"
    Environment          = var.env
    Project              = var.project_name
    Terraform-managed    = true
    ResourceAppRole      = "app"
    ResourceName         = var.resource_name
    CentrifyUnixRole     = "12456"
    adGroup              = "APP-eec-aws#${var.account_id}#BUAdministratorAccessRole"
    adDomain             = "br.experian.local"
    ResourceBusinessUnit = var.BU
    Rapid7Tag            = "${var.BU}, Brazil SP, AWS ${var.account_id}, ${var.env}"
    DynatraceRegion      = "${data.aws_subnet.subnet.availability_zone}" 
    Instance-Scheduler   = var.env != "prod" ? "br-saopaulo-office-hours": null
   }), var.tags
  )}"

  volume_tags = "${merge(tomap({
    Name        = "${local.prefix}-${count.index}"
    Environment = var.env
    Project     = var.project_name
  }), var.volume_tags
  )}"
}
