locals {
  # Create multi AZ node group
  eks_managed_node_groups_multi_az = var.node_groups_multi_az ? merge([
    for r in var.node_groups_regions :
    merge({
      for i in keys(var.eks_managed_node_groups) : "${i}_${r}" =>
      merge(var.eks_managed_node_groups[i],
        {
          placement = {
            availability_zone = "${r}"
          },
          subnet_ids = [local.availability_zone_subnets_experian["${r}"]],
          tags = merge({
            Worker = "Node"
          }, local.default_tags_ec2, var.eks_managed_node_groups[i].tags)
      })
    })
  ]...) : null

  # Add default_ec2 tags to all node groups
  eks_managed_node_groups_default_tag = var.node_groups_multi_az ? null : merge([{
    for i in keys(var.eks_managed_node_groups) : "${i}" =>
    merge(var.eks_managed_node_groups[i],
      {
        tags = merge({
          Worker = "Node"
        }, local.default_tags_ec2, var.eks_managed_node_groups[i].tags)
    })
  }]...)

  node_groups_to_disable_az_rebalance_list = merge([{
    for k, v in var.eks_managed_node_groups : k => v if lookup(v, "az_rebalance", null) == false

  }]...)



  # Due some limitations of the Terraform we can`t use ternary using object with different attributes
  eks_managed_node_groups_normal = var.node_groups_multi_az ? null : var.eks_managed_node_groups

  eks_managed_node_groups_to_create = merge(local.eks_managed_node_groups_normal, local.eks_managed_node_groups_multi_az, local.eks_managed_node_groups_default_tag)

  node_groups_to_documentation = [
    for k, v in local.eks_managed_node_groups_to_create :
    "|${k}|${replace(join(", ", v.instance_types), ", ", "; ")}||"
  ]
}
