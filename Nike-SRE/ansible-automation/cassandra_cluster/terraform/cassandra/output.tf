output "az_a-ec2_ips" {
   value = module.cassandra_ec2_instances_1a.get_private_ips
}

output "az_b-ec2_ips" {
   value = module.cassandra_ec2_instances_1b.get_private_ips
}

#output "az_c-ec2_ips" {
#   value = module.cassandra_ec2_instances_1c.get_private_ips
#}

output "az_a-volume_id" {
   value = module.ssd_attach_volume_1a.volume_ids
}

output "az_b-volume_id" {
   value = module.ssd_attach_volume_1b.volume_ids
}

#output "az_c-volume_id" {
#   value = module.ssd_attach_volume_1c.volume_ids
#}
