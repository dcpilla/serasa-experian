#https://www.terraform.io/configuration/expressions#for-expressions
locals {
  ## VPC  
  availability_zone_subnets = {
    for s in data.aws_subnet.internal_pods : s.availability_zone => s.id
  }
  #Experian subnet
  availability_zone_subnets_experian = {
    for s in data.aws_subnet.eec_subnets : s.availability_zone => s.id
  }


  # Return the last bottlerocket AMI
  ami_eks = {
    "auto_private" = "${join("\\,", data.aws_subnets.experian.ids)}",
    "auto"         = data.aws_ami.eec_bottlerocket_ami.id
  }

  # Remove blank space
  ami_bottlerocket = trimspace(var.ami_bottlerocket)

  ami_filter = local.ami_bottlerocket != "auto" ? ["eec_aws_bottlerocket_*"] : ["eec_aws_bottlerocket_${var.eks_cluster_version}*"]

  external_dns_domain_filters = [
    "${var.env}-mlops.br.experian.eeca"
  ]

  args_helm_assume_role = ["eks", "get-token", "--cluster-name", "${local.cluster_name_env}", "--role-arn", "${var.assume_role_arn}"]

  args_helm = ["eks", "get-token", "--cluster-name", "${local.cluster_name_env}"]

  cidrs = [
    for item in data.aws_vpc.selected.cidr_block_associations :
    item.cidr_block
  ]

  default_tags_eks = merge({
    ManagedBy   = "Terraform"
    ClusterName = local.cluster_name_env
    Application = "EKS"
    Project     = "${var.project_name}"
    Environment = "${var.env}"
    CostString  = var.coststring
    AppID       = var.appid
  }, var.default_tags)

  default_tags_ec2 = merge(local.default_tags_eks, var.default_tags_ec2)

  eks_managed_node_group_secondary_additional_rules = {
    egress_default_ports_tcp = {
      description = "All trafic to internal AWS Account"
      protocol    = "-1"
      from_port   = 0
      to_port     = 65535
      type        = "egress"
      cidr_blocks = [data.aws_vpc.selected.cidr_block]
    }

    ingress_443_port_tcp = {
      description = "Trafic to internal 443 services"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = [
        "10.0.0.0/8",
        "100.64.0.0/16",
      ]
    }

    ingress_istio_port_tcp = {
      description = "Trafic to Istiod service"
      protocol    = "tcp"
      from_port   = 15017
      to_port     = 15017
      type        = "ingress"
      cidr_blocks = [
        "10.0.0.0/8",
        "100.64.0.0/16",
      ]
    }

  }
}
