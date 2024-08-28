locals {
  eks_managed_node_groups = {

    #ON-DEMAND instance to general purpose SMALL
    ng_general_small = {
      instance_types = [
        "m5.large",
        "t3.large"
      ]

      # Enable or Disable AZ rebalance
      # true = Enable AZ
      # false = Disable AZ
      az_rebalance = false

      ## use only when is not using custom LT 
      ## Ex. when the "use_custom_launch_template" is set to false
      # disk_size = 120 

      # block_device_mappings = {
      #   xvdb = {
      #     device_name = "/dev/xvdb"
      #     ebs = {
      #       volume_size           = 120
      #       volume_type           = "gp3"
      #       iops                  = 360
      #       throughput            = 150
      #       encrypted             = true
      #       delete_on_termination = true
      #     }
      #   }
      # }

      min_size     = 1
      max_size     = var.node_group_on_demand_general_small_max_size
      desired_size = 1

      labels = {
        Environment  = var.env
        Project      = var.project_name
        InstanceType = "m5.large"
        instanceType = "m5.large"
        Spot         = false
        Worker       = "node"
      }
      tags = {
        InstanceType = "m5.large"
        instanceType = "m5.large"
      }
    }

    #ON-DEMAND instance to general purpose MEDIUM
    # ng_general_medium = {
    #   instance_types = [
    #     "m5.xlarge",
    #     "t3.xlarge"
    #   ]
    #   create_launch_template = false
    #   launch_template_name   = ""
    #   disk_size              = 120
    #   min_size               = 0
    #   max_size               = var.node_group_on_demand_general_medium_max_size
    #   desired_size           = 0

    #   labels = {
    #     Environment  = var.env
    #     Project      = var.project_name
    #     InstanceType = "m5.xlarge"
    #     instanceType = "m5.xlarge"
    #     Spot         = false
    #     Worker       = "node"
    #   }
    #   tags = {
    #     InstanceType         = "m5.xlarge"
    #     instanceType         = "m5.xlarge"
    #   }
    # }

    # #ON-DEMAND instance to general purpose LARGER
    # ng_general_larger = {
    #   instance_types = [
    #     "m5.2xlarge",
    #     "t3.2xlarge"
    #   ]
    #   create_launch_template = false
    #   launch_template_name   = ""
    #   disk_size              = 120
    #   min_size               = 0
    #   max_size               = var.node_group_on_demand_general_larger_max_size
    #   desired_size           = 0

    #   labels = {
    #     Environment  = var.env
    #     Project      = var.project_name
    #     Spot         = false
    #     InstanceType = "m5.2xlarge"
    #     instanceType = "m5.2xlarge"
    #     Worker       = "node"
    #   }
    #   tags = {
    #     InstanceType         = "m5.2xlarge"
    #     instanceType         = "m5.2xlarge"
    #   }
    # }

    # #ON-DEMAND instance to general purpose m5a.4xlargeR
    ng_m5a4xlarge = {

      instance_types = [
        "m5a.4xlarge"
      ]
      min_size     = 0
      max_size     = var.node_group_on_demand_4xlarger_max_size
      desired_size = 0

      taints = {
        dedicated = {
          key    = "dedicated"
          value  = "larger"
          effect = "NO_EXECUTE"
        }
      }
      labels = {
        Environment  = var.env
        Project      = var.project_name
        Spot         = false
        InstanceType = "m5a.4xlarge"
        instanceType = "m5a.4xlarge"
        Worker       = "node"
      }
      tags = {
        InstanceType = "m5a.4xlarge"
        instanceType = "m5a.4xlarge"
      }
    }
    # ng_r5n2xlarge = {

    #   instance_types = [
    #     "r5n.2xlarge"
    #   ]
    #   create_launch_template = false
    #   launch_template_name   = ""
    #   disk_size              = 120
    #   min_size               = 0
    #   max_size               = var.node_group_on_demand_r5n2xlarge_max_size
    #   desired_size           = 0

    #   taints = {
    #     dedicated = {
    #       key    = "dedicated"
    #       value  = "larger"
    #       effect = "NO_EXECUTE"
    #     }
    #   }
    #   labels = {
    #     Environment  = var.env
    #     Project      = var.project_name
    #     Spot         = false
    #     InstanceType = "r5n.2xlarge"
    #     instanceType = "r5n.2xlarge"
    #     Worker       = "node"
    #   }
    #   tags = {
    #     InstanceType         = "r5n.2xlarge"
    #     instanceType         = "r5n.2xlarge"
    #   }
    # }



    # ##SPOT instance to general purpose MIXED
    # ng_spot_mixed = {

    #   instance_types = [
    #     "t3.large",
    #     "m5.large",
    #     "t3.xlarge",
    #     "m5.xlarge"
    #   ]
    #   create_launch_template = false
    #   launch_template_name   = ""
    #   disk_size              = 120
    #   min_size               = 0
    #   max_size               = var.node_group_spot_general_mixed_max_size
    #   desired_size           = 0
    #   capacity_type          = "SPOT"

    #   labels = {
    #     Environment = var.env
    #     Project     = var.project_name
    #     Spot        = true
    #     Worker      = "node"
    #   }
    #   enable_bootstrap_user_data = true


    #   taints = {
    #     dedicated = {
    #       key    = "dedicated"
    #       value  = "spot"
    #       effect = "NO_SCHEDULE"
    #     }
    #   }
    # }

    ng_g54xlarge_gpu = {

      instance_types = [
        "g4dn.2xlarge"
      ]

      # AMI for GPU should be send here
      ami_id   = "ami-01f7c29325bc87d25"
      ami_type = "BOTTLEROCKET_x86_64_NVIDIA"

      min_size     = 0
      max_size     = 1
      desired_size = 0

      taints = {
        gpu = {
          key    = "nvidia.com/gpu"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      }
      labels = {
        Environment  = var.env
        Project      = var.project_name
        InstanceType = "g5.4xlarge"
        instanceType = "g5.4xlarge"
        Spot         = false
        Worker       = "node"
      }
      tags = {
        InstanceType = "g5.4xlarge"
        instanceType = "g5.4xlarge"
      }
    }
  }
}
