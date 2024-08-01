resource "aws_ebs_volume" "ssd_attach" {
  count               = "${var.ebs_instance_count}"
  availability_zone   = "${var.az}"
  size                = "${var.disk_size}"
  iops                = "${var.iops}"
  type                = "${var.disk_type}"
  throughput          = "${var.throughput}"

  tags = {
    Name = "${var.project_name}-${var.env}-vol-${var.az}-${count.index +1}"
  }
}
