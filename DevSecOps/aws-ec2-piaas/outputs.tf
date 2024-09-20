###jenkins###
output "jenkins_name" {
  value = "${module.aws_jenkins_iam_role}"
}

output "jenkins_ec2_id" {
  description = "List of IDs of instances"
  value       = ["${module.jenkins_ec2_instance.*.id}"]
}