######
output "ec2_name" {
  value = "${module.aws_iam_role}"
}

output "ec2_id" {
  description = "List of IDs of instances"
  value       = ["${module.ec2_instance.*.id}"]
}

output "ipv4_address" {
  description = "IPV4 assigned to EC2 instance."
  value       = "${module.ec2_instance.private_ip}"
}