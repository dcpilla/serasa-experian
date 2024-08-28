locals {
  # module.eks.eks_managed_node_groups_autoscaling_group_names = ["eks-ng_general_larger-2023070616095777820000001e-1ac495fb-d3ef-9a37-561f-5225a7989ff4"]
  # Just to registry how it works
  # $ > regex("eks-(.*)-[0-9]{10,}", "eks-ng_general_larger-2023070616095777820000001e-1ac495fb-d3ef-9a37-561f-5225a7989ff4")[0]
  # $ "ng_general_larger"
  asg_names = {
    for asg_name in module.eks.eks_managed_node_groups_autoscaling_group_names :
    try(regex("eks-(.*)-[0-9]{10,}", asg_name)[0], "default") => asg_name

  }

}

# To get current status of AZ rebalnce
# aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name eks-ng_m5a4xlarge_cs-20240117231625283200000002-92c68cdb-1605-11a6-3d99-44f74a1982fd --region=sa-east-1 | jq '.AutoScalingGroups | .[].SuspendedProcesses'

resource "null_resource" "disable_az_rebalance_on_asgs" {
  for_each = local.node_groups_to_disable_az_rebalance_list


  provisioner "local-exec" {
    interpreter = ["/bin/sh", "-c"]
    environment = {
      AWS_DEFAULT_REGION = var.region
    }

    command = <<EOF
set -e
nameAsg="${lookup(local.asg_names, each.key, "")}"
error_temp_file="/tmp/asg_failure-$nameAsg"
sucesss_temp_file="/tmp/asg_sucesss-$nameAsg"
if [ "$nameAsg" == "" ];then
  echo "AZ rebalance IS NOT disable to ${each.key}, unable to find auto scale group"
  echo "disableAZRebalance_on_ASGs failed" > $error_temp_file
  exit 0
fi
aws autoscaling suspend-processes \
  --auto-scaling-group-name $nameAsg \
  --scaling-processes AZRebalance 2> /dev/null && echo "works" > $sucesss_temp_file|| echo "disableAZRebalance_on_ASGs failed" > $error_temp_file

EOF
  }
  # Need nodegroup names to exist before we can run above
  depends_on = [
    module.eks,
    module.eks.eks_managed_node_groups_autoscaling_group_names
  ]
  # Only runs when the nodegroup names change
  triggers = {
    value = join(",", [
      for name in keys(local.node_groups_to_disable_az_rebalance_list) :
      name
    ])
  }

  # Throws error if bash command fails
  lifecycle {
    postcondition {

      # We used the base64 encoding of the temporary file contents because the presence of newlines was making it difficult to perform comparisons.
      condition = fileexists("/tmp/asg_failure-${each.key}") ? filebase64("/tmp/asg_failure${each.key}") != "ZGlzYWJsZUFaUmViYWxhbmNlX29uX0FTR3MgZmFpbGVkCg==" : true

      error_message = format("AZ rebalance IS NOT disable to %s, unable to find auto scale group.\n########################################\nDebug:\n\nList of autoscaling groups: \n\neks_managed_node_groups_autoscaling_group_names: \n\n  %#v \n\n######################################## \n\nList of nodegroup name set in terraform \n\nasg_names: \n\n  %#v \\n\n######################################## \n\nRegex used: \n\nregex(\"eks-(.*)-[0-9]{10,}\", asg_name)[0])\n\nRemove the temp file before re-run this scripts\n rm -r /tmp/asg_failure-*\n", each.key, module.eks.eks_managed_node_groups_autoscaling_group_names, local.asg_names)
    }
  }

}
