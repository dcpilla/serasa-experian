locals {
  cluster_name_env = "${substr(var.eks_cluster_name, 0, 27)}-${var.env}"
}

module "eks" {
  source                          = "./modules/terraform-aws-eks-19.15.3"
  cluster_name                    = local.cluster_name_env
  cluster_version                 = var.eks_cluster_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false
  dataplane_wait_duration         = "180s"

  #https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  cluster_enabled_log_types = [
    "audit",
    "api",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  # Addons are simply passed through to the underlying https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon
  cluster_addons = {
    kube-proxy = {
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts           = "OVERWRITE"
    }

    vpc-cni = {
      # Specify the VPC CNI addon should be deployed before compute to ensure
      # the addon is configured before data plane compute resources are created
      # See README for further details
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
      resolve_conflicts           = "OVERWRITE"

      before_compute = true
      most_recent    = var.aws_vpc_cni_most_recent # To ensure access to the latest settings provided
      addon_version  = var.aws_vpc_cni_version
      #https://github.com/aws/amazon-vpc-cni-k8s/blob/master/docs/prefix-and-ip-target.md
      configuration_values = jsonencode(var.aws_cni_configuration_values)
    }
    aws-ebs-csi-driver = {
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts           = "OVERWRITE"
      configuration_values        = jsonencode(var.aws_ebs_csi_driver_values)
    }
  }

  cluster_encryption_config = {
    provider_key_arn = local.kms_eks
    resources        = ["secrets"]
  }

  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    ingres_ports_tcp = {
      description = "Open 443 to Experian network"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = ["10.0.0.0/8"]
    }
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  vpc_id                  = data.aws_vpc.selected.id
  subnet_ids              = var.eks_cluster_node_ipclass == 100 ? data.aws_subnets.internal_pods.ids : data.aws_subnets.experian.ids
  enable_irsa             = true
  custom_oidc_thumbprints = var.custom_oidc_thumbprints

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
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
    ami_id                     = "${lookup(local.ami_eks, local.ami_bottlerocket, null) == null ? local.ami_bottlerocket : local.ami_eks[local.ami_bottlerocket]}"
    platform                   = "bottlerocket"
    enable_bootstrap_user_data = true
    #key_name                      = var.node_key_pair
    instance_types                = ["t3.large"]
    vpc_security_group_ids        = flatten([aws_security_group.one.id, var.eks_managed_node_group_additional_sgs])
    iam_role_name                 = "BURoleForEksN${var.eks_cluster_name}"
    iam_role_use_name_prefix      = true
    iam_role_description          = "EKS managed node Group"
    iam_role_permissions_boundary = data.aws_iam_policy.eec_boundary_policy.arn
    iam_role_additional_policies = merge({
      ec2 = data.aws_iam_policy.ec2_container.arn
      ssm = data.aws_iam_policy.ssm_instance.arn
    }, var.iam_role_additional_policies)

    bootstrap_extra_args = <<-EOT
      # extra args added
      ${var.global_max_pods_per_node == "auto" ? "#" : "max-pods = ${var.global_max_pods_per_node}"}
      #[settings.kubernetes.allowed-unsafe-sysctls]
      #allowed-unsafe-sysctls = ["net.ipv4.ip_unprivileged_port_start"]
      [settings.network]
      https-proxy = "http://spobrproxy.serasa.intranet:3128/"
      no-proxy = ["172.20.0.0/16","localhost","10.0.0.0/8","100.64.0.0/16","127.0.0.1","${data.aws_vpc.selected.cidr_block}","169.254.169.254",".internal",".s3.amazonaws.com",".s3.${data.aws_region.current.name}.amazonaws.com","api.ecr.${data.aws_region.current.name}.amazonaws.com",".dkr.ecr.${data.aws_region.current.name}.amazonaws.com","ec2.${data.aws_region.current.name}.amazonaws.com"]
      
      [settings.container-registry.mirrors]
      "docker.io" = ["dockerhub.datalabserasaexperian.com.br"]
      "gcr.io" = ["dockerhub.datalabserasaexperian.com.br"]
      "public.ecr.aws" = ["dockerhub.datalabserasaexperian.com.br"]
      "k8s.gcr.io" = ["dockerhub.datalabserasaexperian.com.br"]
      "southamerica-east1-docker.pkg.dev"  = ["dockerhub.datalabserasaexperian.com.br"]
      "southamerica-west1-docker.pkg.dev"  = ["dockerhub.datalabserasaexperian.com.br"]
      # The admin host container provides SSH access and runs with "superpowers" (disabled by default).
      [settings.host-containers.admin]
      enabled = true
      # The control host container provides out-of-band access via SSM (enabled by default).
      [settings.host-containers.control]
      enabled = true
      EOT

    tags = merge({
      Worker = "Node"
    }, local.default_tags_ec2)
  }

  eks_managed_node_infra = merge(local.eks_managed_node_infra, local.node_group_on_demand_infra_old)

  eks_managed_node_groups = local.eks_managed_node_groups_to_create

  create_iam_role                = true
  iam_role_name                  = "BURoleForEksC${var.eks_cluster_name}"
  cluster_encryption_policy_name = "BUPolicyForEKS-"
  iam_role_use_name_prefix       = true
  iam_role_description           = "EKS managed Cluster Group"
  iam_role_permissions_boundary  = data.aws_iam_policy.eec_boundary_policy.arn

  tags = local.default_tags_eks

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_roles = flatten([
    var.aws_auth_roles
    , [
      {
        rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/BUAdministratorAccessRole"
        username = "BUAdministratorAccessRole"
        groups   = ["system:masters"]
      },
    ]
  ])

  aws_auth_users = var.aws_auth_users


}
