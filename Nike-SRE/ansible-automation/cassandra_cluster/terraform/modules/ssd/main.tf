resource "aws_volume_attachment" "ssd_att" {
  count         = "${var.ebs_instance_count}"
  skip_destroy  = true
  device_name   = "${var.device_name}"
  volume_id     = "${var.volume_ids["${count.index}"]}"
  instance_id   = "${var.instances["${count.index}"]}"
}
