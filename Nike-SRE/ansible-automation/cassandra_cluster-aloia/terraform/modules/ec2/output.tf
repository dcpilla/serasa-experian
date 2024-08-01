output "get_private_ips" {
  description 	= "List of private IP addresses assigned to the EC2's instances"
  value 	= aws_instance.ec2.*.private_ip
}

output "instance_ids" {
  value = aws_instance.ec2.*.id
}