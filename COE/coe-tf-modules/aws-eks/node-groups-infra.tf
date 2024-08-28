locals {

  eks_managed_node_infra_single_az = {
    #ON-DEMAND instance to infra

    ng_od_infra = {

      instance_types = var.eks_managed_node_infra_instance_types
      max_size       = var.eks_managed_node_infra_max_size
      #min_size       = 1
      #desired_size   = 1

      labels = {
        Environment = var.env
        Project     = var.project_name
        Spot        = false
        Worker      = "infra"
      }

      taints = {
        dedicated = {
          key    = "dedicated"
          value  = "infra"
          effect = "NO_SCHEDULE"
        }
      }

      iam_role_additional_policies = {
        ec2               = data.aws_iam_policy.ec2_container.arn
        ssm               = data.aws_iam_policy.ssm_instance.arn
        clusterAutoscaler = aws_iam_policy.clusterAutoscaler.arn
        externaldns       = aws_iam_policy.externaldns.arn
        lokiS3            = aws_iam_policy.lokiS3.arn
        ebs_csi_driver    = aws_iam_policy.ebs_csi_driver.arn
      }

    }
  }

  # Create multi AZ node group
  # To save some money only start in two region, if needed more the cluster autoscaler can launch more
  eks_managed_node_infra = merge([
    for r in var.node_groups_regions :
    merge({
      for i in keys(local.eks_managed_node_infra_single_az) : "${i}_${r}" =>
      merge(local.eks_managed_node_infra_single_az[i],
        {
          min_size     = "${r}" != "sa-east-1c" ? 1 : 0
          desired_size = "${r}" != "sa-east-1c" ? 1 : 0
          placement = {
            availability_zone = "${r}"
          },
          subnet_ids = [local.availability_zone_subnets_experian["${r}"]],
          tags = merge({
            Worker = "infra"
          }, local.default_tags_ec2)
      })
    })
  ]...)

  ## Keep here for compabilitie with olds verison, should be remove in the next version
  node_group_on_demand_infra_old = var.istio_ingress_loadbalancerclass == null && var.eks_cluster_version != "1.29" ? {
    node_group_on_demand_infra = {
      disk_size = 120
      block_device_mappings = {
        xvdb = {
          device_name = "/dev/xvdb"
          ebs = {
            volume_size           = 120
            volume_type           = "gp3"
            iops                  = 360
            throughput            = 150
            encrypted             = true
            delete_on_termination = true
          }
        }
      }
      use_custom_launch_template = true
      key_name                   = "mlcoe"
      ami_id                     = "${lookup(local.ami_eks, var.ami_bottlerocket, null) == null ? var.ami_bottlerocket : local.ami_eks[var.ami_bottlerocket]}"
      platform                   = "bottlerocket"
      enable_bootstrap_user_data = true
      instance_types             = var.eks_managed_node_infra_instance_types
      min_size                   = 0
      max_size                   = 3
      desired_size               = 0

      labels = {
        Environment = var.env
        Project     = var.project_name
        Spot        = false
        Worker      = "infra"
      }

      taints = {
        dedicated = {
          key    = "dedicated"
          value  = "infra-old"
          effect = "NO_SCHEDULE"
        }
      }

      tags = merge({
        Worker = "Infra"
      }, local.default_tags_ec2)

      iam_role_additional_policies = {
        ec2               = data.aws_iam_policy.ec2_container.arn
        ssm               = data.aws_iam_policy.ssm_instance.arn
        clusterAutoscaler = aws_iam_policy.clusterAutoscaler.arn
        externaldns       = aws_iam_policy.externaldns.arn
        lokiS3            = aws_iam_policy.lokiS3.arn
        ebs_csi_driver    = aws_iam_policy.ebs_csi_driver.arn
      }
    }
  } : null


}

