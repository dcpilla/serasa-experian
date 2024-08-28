locals {
  eks_managed_node_groups = {

    #ON-DEMAND instance to general purpose SMALL
    ng_general_small = {
      instance_types = [
        "m5.large",
        "t3.large"
      ]
      disk_size    = 120
      min_size     = 1
      max_size     = var.node_group_on_demand_general_small_max_size
      desired_size = 1

      labels = {
        Environment  = var.env
        Project      = var.project_name
        InstanceType = "m5.large"
        Spot         = false
        Worker       = "node"
      }
      tags = {
        Application          = "EKS"
        Project              = "${var.project_name}"
        Environment          = "${var.env}"
        ResourceCostCenter   = "${var.costcenter}"
        ResourceBusinessUnit = "${var.resource_business_unit}"
        ResourceAppRole      = "app"
        ResourceOwner        = "${var.resource_owner}"
        ResourceName         = "${var.resource_name}"
        Rapid7Tag            = "${var.rapid7_tag}"
        adGroup              = "${var.ad_group}"
        adDomain             = "${var.ad_domain}"
        CentrifyUnixRole     = "${var.centrify_unix_role}"
        InstanceType         = "m5.large"
        ManagedBy            = "Terraform"
      }
    }

    #ON-DEMAND instance to general purpose MEDIUM
    ng_general_medium = {
      instance_types = [
        "m5.xlarge",
        "t3.xlarge"
      ]
      disk_size    = 120
      min_size     = 0
      max_size     = var.node_group_on_demand_general_medium_max_size
      desired_size = 0

      labels = {
        Environment  = var.env
        Project      = var.project_name
        InstanceType = "m5.xlarge"
        Spot         = false
        Worker       = "node"
      }
      tags = {
        Application          = "EKS"
        Project              = "${var.project_name}"
        Environment          = "${var.env}"
        ResourceCostCenter   = "${var.costcenter}"
        ResourceBusinessUnit = "${var.resource_business_unit}"
        ResourceAppRole      = "app"
        ResourceOwner        = "${var.resource_owner}"
        ResourceName         = "${var.resource_name}"
        Rapid7Tag            = "${var.rapid7_tag}"
        adGroup              = "${var.ad_group}"
        adDomain             = "${var.ad_domain}"
        CentrifyUnixRole     = "${var.centrify_unix_role}"
        InstanceType         = "m5.xlarge"
        ManagedBy            = "Terraform"
      }
    }

    #ON-DEMAND instance to general purpose LARGER
    ng_general_larger = {
      instance_types = [
        "m5.2xlarge",
        "t3.2xlarge"
      ]
      disk_size    = 120
      min_size     = 0
      max_size     = var.node_group_on_demand_general_larger_max_size
      desired_size = 0

      labels = {
        Environment  = var.env
        Project      = var.project_name
        Spot         = false
        InstanceType = "m5.2xlarge"
        Worker       = "node"
      }
      tags = {
        Application          = "EKS"
        Project              = "${var.project_name}"
        Environment          = "${var.env}"
        ResourceCostCenter   = "${var.costcenter}"
        ResourceBusinessUnit = "${var.resource_business_unit}"
        ResourceAppRole      = "app"
        ResourceOwner        = "${var.resource_owner}"
        ResourceName         = "${var.resource_name}"
        Rapid7Tag            = "${var.rapid7_tag}"
        adGroup              = "${var.ad_group}"
        adDomain             = "${var.ad_domain}"
        CentrifyUnixRole     = "${var.centrify_unix_role}"
        InstanceType         = "m5.2xlarge"
        ManagedBy            = "Terraform"
      }
    }

    #ON-DEMAND instance to general purpose 4xLARGER
    ng_4xlarger = {

      instance_types = [
        "m5.4xlarge"
      ]
      disk_size    = 120
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
        InstanceType = "m5.4xlarge"
        Worker       = "node"
      }
      tags = {
        Application          = "EKS"
        Project              = "${var.project_name}"
        Environment          = "${var.env}"
        ResourceCostCenter   = "${var.costcenter}"
        ResourceBusinessUnit = "${var.resource_business_unit}"
        ResourceAppRole      = "app"
        ResourceOwner        = "${var.resource_owner}"
        ResourceName         = "${var.resource_name}"
        Rapid7Tag            = "${var.rapid7_tag}"
        adGroup              = "${var.ad_group}"
        adDomain             = "${var.ad_domain}"
        CentrifyUnixRole     = "${var.centrify_unix_role}"
        InstanceType         = "m5.4xlarge"
        ManagedBy            = "Terraform"
      }
    }

    #ON-DEMAND instance to general purpose 4xLARGER
    ng_8xlarger = {

      instance_types = [
        "m5.8xlarge"
      ]
      disk_size    = 120
      min_size     = 0
      max_size     = var.node_group_on_demand_8xlarger_max_size
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
        InstanceType = "m5.8xlarge"
        Worker       = "node"
      }
      tags = {
        Application          = "EKS"
        Project              = "${var.project_name}"
        Environment          = "${var.env}"
        ResourceCostCenter   = "${var.costcenter}"
        ResourceBusinessUnit = "${var.resource_business_unit}"
        ResourceAppRole      = "app"
        ResourceOwner        = "${var.resource_owner}"
        ResourceName         = "${var.resource_name}"
        Rapid7Tag            = "${var.rapid7_tag}"
        adGroup              = "${var.ad_group}"
        adDomain             = "${var.ad_domain}"
        CentrifyUnixRole     = "${var.centrify_unix_role}"
        InstanceType         = "m5.8xlarge"
        ManagedBy            = "Terraform"
      }
    }
    #ON-DEMAND instance to general purpose c5.9xLARGER
    ng_c59xlarger = {

      instance_types = [
        "c5.9xlarge"
      ]
      disk_size    = 120
      min_size     = 0
      max_size     = var.node_group_on_demand_c59xlarger_max_size
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
        InstanceType = "c5.9xlarge"
        Worker       = "node"
      }
      tags = {
        Application          = "EKS"
        Project              = "${var.project_name}"
        Environment          = "${var.env}"
        ResourceCostCenter   = "${var.costcenter}"
        ResourceBusinessUnit = "${var.resource_business_unit}"
        ResourceAppRole      = "app"
        ResourceOwner        = "${var.resource_owner}"
        ResourceName         = "${var.resource_name}"
        Rapid7Tag            = "${var.rapid7_tag}"
        adGroup              = "${var.ad_group}"
        adDomain             = "${var.ad_domain}"
        CentrifyUnixRole     = "${var.centrify_unix_role}"
        InstanceType         = "c5.9xlarge"
        ManagedBy            = "Terraform"
      }
    }
    ##SPOT instance to general purpose MIXED
    ng_spot_mixed = {

      instance_types = [
        "t3.large",
        "m5.large",
        "t3.xlarge",
        "m5.xlarge"
      ]
      disk_size     = 120
      min_size      = 0
      max_size      = var.node_group_spot_general_mixed_max_size
      desired_size  = 0
      capacity_type = "SPOT"

      labels = {
        Environment = var.env
        Project     = var.project_name
        Spot        = true
        Worker      = "node"
      }
      enable_bootstrap_user_data = true


      taints = {
        dedicated = {
          key    = "dedicated"
          value  = "spot"
          effect = "NO_SCHEDULE"
        }
      }
      tags = {
        Application          = "EKS"
        Project              = "${var.project_name}"
        Environment          = "${var.env}"
        ResourceCostCenter   = "${var.costcenter}"
        ResourceBusinessUnit = "${var.resource_business_unit}"
        ResourceAppRole      = "app"
        ResourceOwner        = "${var.resource_owner}"
        ResourceName         = "${var.resource_name}"
        Rapid7Tag            = "${var.rapid7_tag}"
        adGroup              = "${var.ad_group}"
        adDomain             = "${var.ad_domain}"
        CentrifyUnixRole     = "${var.centrify_unix_role}"
        ManagedBy            = "Terraform"
      }
    }
  }
}
