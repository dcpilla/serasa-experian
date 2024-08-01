output "volume_ids" {
    description     = "List of volumes id"
    value           = aws_ebs_volume.ssd_attach.*.id
}
