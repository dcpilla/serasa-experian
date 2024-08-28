terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.57.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }
    external = {
      source = "hashicorp/external"
      version = "~> 2.2.3"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.region
  dynamic "assume_role" {
    for_each = toset(var.assume_role_arn != null ? ["fake"] : [])
    content {
      role_arn = var.assume_role_arn
    }
  }
}

locals {
  # EKS cluster name and related resources identification
  cluster_name_env = "${substr(var.eks_cluster_name, 0, 27)}-${var.env}"

  # EEC Golden Image KMS keys for EBS re-encryption
  eec_kms_key = {
    "us-east-1"      = "arn:aws:kms:us-east-1:363353661606:key/923dfe86-1e45-4ff3-a75c-f8e95e7944b0"
    "us-west-2"      = "arn:aws:kms:us-west-2:363353661606:key/6a611956-f586-47da-bb67-6d305a15fc74"
    "ap-south-1"     = "arn:aws:kms:ap-south-1:363353661606:key/b7b93891-314f-4e00-8359-4f51d0a0cd09"
    "ap-southeast-1" = "arn:aws:kms:ap-southeast-1:363353661606:key/edc1a20a-de45-423c-b06e-ce7485ae3aec"
    "ap-southeast-2" = "arn:aws:kms:ap-southeast-2:363353661606:key/ea938280-bcdd-40d5-9302-ced83f9dd4f0"
    "ap-northeast-1" = "arn:aws:kms:ap-northeast-1:363353661606:key/4fedb0a1-71e3-4a84-962d-177093b72386"
    "eu-central-1"   = "arn:aws:kms:eu-central-1:363353661606:key/00424fe0-fe05-4999-9e1c-f73674b8f2fd"
    "eu-west-1"      = "arn:aws:kms:eu-west-1:363353661606:key/34b027d4-f2c9-4622-b7e1-7043648fb9b1"
    "eu-west-2"      = "arn:aws:kms:eu-west-2:363353661606:key/4e9611e2-dd2a-4b8c-b79d-1b7602d5155f"
    "sa-east-1"      = "arn:aws:kms:sa-east-1:363353661606:key/52ef2dd4-4fb4-4e7d-8683-930d90b9e636"
  }

  # VPC to be used for all resources
  vpc_selected_by_tag = [for x in data.aws_vpc.foreach: x if contains(keys(x.tags), "AWS_Solutions")]
  vpc_auto = length(local.vpc_selected_by_tag) > 0 ? one(local.vpc_selected_by_tag) : data.aws_vpc.foreach[keys(data.aws_vpc.foreach)[0]]
  # Subnets to be used by EKS, EC2, NLB and EFS
  subnets = var.subnets == "auto" ? data.aws_subnets.private.ids : [for x in split(",", var.subnets): trim(x," ") if length(trim(x, " ")) > 0]

  # Manual AMI ID parameter
  ami_eks = {
    "latest"       = data.aws_ami.eec_amznlnx_ami.id
  }
  ami_id           = lookup(local.ami_eks, var.eks_ami_id, var.eks_ami_id) 

  # S3 bucket name for Access Log configuration
  s3_bucket_access_logs = "se-${random_id.s3_id.hex}-${local.cluster_name_env}-access-logs"

  # Helm charts variables
  availability_zone_subnets = {
    for s in data.aws_subnet.pods : s.availability_zone => s.id
  }

  cluster_oidc_issuer = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  # cluster_oidc_issuer = replace(aws_iam_openid_connect_provider.cluster.url, "https://", "")

  # Tagging-related locals

  required_tags = {
    AppID       = var.resource_app_id
    Environment = var.resource_environment[var.env].value
    CostString  = var.resource_cost_center
  }

  common_tags = merge(local.required_tags, {
    Application          = "EKS"
    ClusterName          = local.cluster_name_env
    Project              = var.project_name
    ResourceCostCenter   = var.resource_cost_center
    ResourceBusinessUnit = var.resource_business_unit
    ResourceAppRole      = "app"
    ResourceOwner        = var.resource_owner
    ResourceName         = var.resource_name
    map-migrated         = var.map_server_id
    ManagedBy            = "Terraform"
  })

  cluster_tags = merge(local.common_tags, {
    service-request = var.service_request
    RepositoryVersion    = var.repo_version
  })

  ec2_tags = merge(local.common_tags, {
    #adGroup              = var.ad_group
    adDomain             = var.ad_domain
    #CentrifyUnixRole     = var.centrify_unix_role
    #ProxyUrl             = var.proxy_url
    Instance-Scheduler   = "opt-out"
    PCI                  = "false"
  })

  # Proxy-related locals

  proxy_servers = {
    sa-east-1 = "spobrproxy.serasa.intranet:3128"
    us-east-1 = "usaeast-proxy.us.experian.eeca:9595"
  }

  proxy_server = var.use_proxy == "auto" ? lookup(local.proxy_servers, data.aws_region.current.name, "") : var.use_proxy
  proxy_bypass = "172.20.0.0/16,localhost,127.0.0.1,10.0.0.0/8,169.254.169.254,.internal,.s3.amazonaws.com,.s3.${data.aws_region.current.name}.amazonaws.com,api.ecr.${data.aws_region.current.name}.amazonaws.com,dkr.ecr.${data.aws_region.current.name}.amazonaws.com,.ec2.${data.aws_region.current.name}.amazonaws.com,.eks.amazonaws.com,.${data.aws_region.current.name}.eks.amazonaws.com,.experiannet.corp,.aln.experian.com,.mck.experian.com,.sch.experian.com,.experian.eeca,.experian.local,.experian.corp,.gdc.local,.41web.internal,metadata.google.internal,metadata,10.188.14.54,10.188.14.57,10.99.132.16"
  proxy_env_vars = [{
    "name"  = "HTTP_PROXY"
    "value" = "http://${local.proxy_server}"
  }, {
    "name"  = "HTTPS_PROXY"
    "value" = "http://${local.proxy_server}"
  }, {
    "name"  = "NO_PROXY"
    "value" = local.proxy_bypass
  }]

  proxy_user_data = <<-EOT
--//
Content-Type: text/x-shellscript; charset="us-ascii"

PROXY="${local.proxy_server}"
MAC=$(curl -s http://169.254.169.254/latest/meta-data/mac/)
VPC_CIDR=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$MAC/vpc-ipv4-cidr-blocks | xargs | tr ' ' ',')

mkdir -p /etc/systemd/system/containerd.service.d

cloud-init-per instance yum_proxy_config cat << EOF >> /etc/yum.conf
proxy=http://$PROXY
EOF

cloud-init-per instance proxy_config cat << EOF >> /etc/environment
http_proxy=http://$PROXY
https_proxy=http://$PROXY
HTTP_PROXY=http://$PROXY
HTTPS_PROXY=http://$PROXY
no_proxy=$VPC_CIDR,172.20.0.0/16,localhost,127.0.0.1,169.254.169.254,100.64.0.0/16,10.0.0.0/8,.internal,.s3.amazonaws.com,.s3.${data.aws_region.current.name}.amazonaws.com,api.ecr.${data.aws_region.current.name}.amazonaws.com,dkr.ecr.${data.aws_region.current.name}.amazonaws.com,.ec2.${data.aws_region.current.name}.amazonaws.com,.eks.amazonaws.com,.${data.aws_region.current.name}.eks.amazonaws.com
NO_PROXY=$VPC_CIDR,172.20.0.0/16,localhost,127.0.0.1,169.254.169.254,100.64.0.0/16,10.0.0.0/8,.internal,.s3.amazonaws.com,.s3.${data.aws_region.current.name}.amazonaws.com,api.ecr.${data.aws_region.current.name}.amazonaws.com,dkr.ecr.${data.aws_region.current.name}.amazonaws.com,.ec2.${data.aws_region.current.name}.amazonaws.com,.eks.amazonaws.com,.${data.aws_region.current.name}.eks.amazonaws.com
EOF

cloud-init-per instance containerd_proxy_config tee <<EOF /etc/systemd/system/containerd.service.d/http-proxy.conf >/dev/null
[Service]    
EnvironmentFile=/etc/environment
EOF

cloud-init-per instance kubelet_proxy_config tee <<EOF /etc/systemd/system/kubelet.service.d/proxy.conf >/dev/null
[Service]
EnvironmentFile=/etc/environment
EOF

cloud-init-per instance reload_daemon systemctl daemon-reload
EOT

  pre_bootstrap_user_data = <<-EOT
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="//"

${var.use_proxy == "no-proxy" ? "" : local.proxy_user_data}--//
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash -ex
EOT

  # Nodegroup-related locals

  nodegroups_array = [
    var.eks_managed_node_small_max_size > 0 ? local.nodegroup_tier1 : {},
    var.eks_managed_node_medium_max_size > 0 ? local.nodegroup_tier2 : {},
    var.eks_managed_node_larger_max_size > 0 ? local.nodegroup_tier3 : {},
    var.eks_managed_node_spot_max_size > 0 ? local.nodegroup_spot : {}
  ]
  nodegroups_map = {
    for nodegroup in local.nodegroups_array:
      element(keys(nodegroup), 0) => element(values(nodegroup), 0)
        if length(keys(nodegroup)) > 0
  }

  nodegroup_prefix = lookup({
    "combined" = "EKS-${local.cluster_name_env}-NG"
    "simple" = "eks-node-group"
  }, var.nodegroup_names_prefix, var.nodegroup_names_prefix)

  nodegroup_tier1 = {
    "${local.nodegroup_prefix}-small" = {
      ami_id                     = local.ami_id
      enable_bootstrap_user_data = true
      instance_types            = tolist([var.eks_managed_node_small_instance_type])
      min_size                  = 0
      max_size                  = var.eks_managed_node_small_max_size
      desired_size              = 0

      labels = {
        Environment = var.env
        Project     = var.project_name
        Spot        = false
      }

      tags = merge(local.ec2_tags, {})
    }
  }
  nodegroup_tier2 = {
    "${local.nodegroup_prefix}-medium" = {
      ami_id                     = local.ami_id
      enable_bootstrap_user_data = true
      instance_types            = tolist([var.eks_managed_node_medium_instance_type])
      min_size                  = 0
      max_size                  = var.eks_managed_node_medium_max_size
      desired_size              = 0

      labels = {
        Environment = var.env
        Project     = var.project_name
        Spot        = false
      }

      tags = merge(local.ec2_tags, {})
    }
  }
  nodegroup_tier3 = {
    "${local.nodegroup_prefix}-large" = {
      ami_id                     = local.ami_id
      enable_bootstrap_user_data = true
      instance_types       = tolist([var.eks_managed_node_large_instance_type])
      min_size             = 0
      max_size             = var.eks_managed_node_larger_max_size
      desired_size         = 0

      labels = {
        Environment = var.env
        Project     = var.project_name
        Spot        = false
      }

      tags = merge(local.ec2_tags, {})
    }
  }
  nodegroup_spot  = {
    "${local.nodegroup_prefix}-spot" = {
      ami_id                     = local.ami_id
      enable_bootstrap_user_data = true
      instance_types            = tolist([var.eks_managed_node_spot_instance_type])
      min_size                  = 0
      max_size                  = var.eks_managed_node_spot_max_size
      desired_size              = 0
      capacity_type             = "SPOT"
      
      labels = {
        Environment = var.env
        Project     = var.project_name
        Spot        = true
      }

      taints = {
        dedicated = {
          key    = "dedicated"
          value  = "spot"
          effect = "NO_SCHEDULE"
        }
      }

      tags = merge(local.ec2_tags, {})
    }
  }

  # Post-cluster, pre-charts locals
  eniconfig_securitygroups = [module.eks.node_security_group_id, aws_security_group.one.id]
  eniconfig_availabilityzone = [for s in data.aws_subnet.pods : {
    name = s.availability_zone
    subnet_id = s.id
    security_groups = join(",", [for sg in local.eniconfig_securitygroups: "\"${sg}\""])
  }]
  eniconfig_yaml = join("\n---\n", [for f in data.template_file.eniconfig: f.rendered])

  kubectl_cni_config_items = [
    "AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG=true",
    "ENI_CONFIG_LABEL_DEF=topology.kubernetes.io/zone",
    "MINIMUM_IP_TARGET-",
    "WARM_IP_TARGET-",
    "ENABLE_PREFIX_DELEGATION=true",
    "WARM_PREFIX_TARGET=1"
  ]
  kubectl_cni_config_cmd = "set env daemonset aws-node -n kube-system -c aws-node ${join(" ", local.kubectl_cni_config_items)}"

  # kubectl_wait = "wait --for=condition=Ready --all pod -n kube-system --selector=k8s-app=aws-node --timeout=300s"
  # kubectl_wait = "rollout status -n kube-system daemonset/aws-node && sleep 10"
  kubectl_wait = "rollout status -n kube-system daemonset/aws-node"

  kubectl_proxy_items = [ for x in local.proxy_env_vars: "${x.name}=${x.value}" ]
  kubectl_proxy_vars = join(" ", local.kubectl_proxy_items)
  kubectl_proxy_cmds = {
    "aws-ebs-csi-driver" = "set env deployment ebs-csi-controller -n kube-system -c ebs-plugin ${local.kubectl_proxy_vars}",
    "aws-efs-csi-driver" = "set env deployment efs-csi-controller -n kube-system -c efs-plugin ${local.kubectl_proxy_vars}"
  }

  # Karpenter-related locals
  karpenter_ec2nodeclass = yamlencode({
    spec = {
      amiFamily = "AL2"
      amiSelectorTerms = [local.ami_id]
      blockDeviceMappings = [{
        # ...
      }]
      metadataOptions = {
        httpEndpoint = "enabled"
        httpProtocolIPv6 = "disabled"
        httpPutResponseHopLimit = 2
        httpTokens = "required"
      }
      role = var.karpenter == "enabled+resources" ? aws_iam_role.karpenter_node.0.name : ""
      securityGroupSelectorTerms = [{
        tags = {
          "karpenter.sh/discovery" = local.cluster_name_env
        }
      }]
      subnetSelectorTerms = [{
        tags = {
          "karpenter.sh/discovery" = local.cluster_name_env
        }
      }]
      tags = local.ec2_tags
      userData = local.pre_bootstrap_user_data
    }
  })

  eks_nodegroup_infra_name = regex("[^:]+:(.+)", element(values(module.eks.eks_managed_node_group_infra), 0).node_group_id).0  
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

## EKS
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

## IAM
data "aws_iam_policy" "ebs_csi_driver" {
  name = "AmazonEBSCSIDriverPolicy"
}

data "aws_iam_policy" "eks_worker_node" {
  name = "AmazonEKSWorkerNodePolicy"
}

data "aws_iam_policy" "eks_cni" {
  name = "AmazonEKS_CNI_Policy"
}

data "aws_iam_policy" "ec2_ecr_readonly" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}

data "aws_iam_policy" "ssm_instance" {
  name = "AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "eec_boundary_policy" {
  name = "BUAdminBasePolicy"
}

## Get the last Amazon Linux AMI
data "aws_ami" "eec_amznlnx_ami" {
  owners      = ["363353661606"]
  most_recent = true
  filter {
    name   = "name"
    values = ["eec_aws_eks_amzn-lnx_2_${var.eks_cluster_version}_*"]
  }
}

data "aws_vpcs" "all" {}

data "aws_vpc" "foreach" {
    for_each = toset(data.aws_vpcs.all.ids)
    id = each.key
}

data "aws_vpc" "thevpc" {
    id = var.vpc_id == "auto" ? local.vpc_auto.id : var.vpc_id
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.thevpc.id]
  }
  
  tags = {
    Network = "Private"
  }
}

data "aws_subnets" "pods" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.thevpc.id]
  }

  tags = {
    Network = "Pod"
  }
}

data "aws_subnet" "private" {
  for_each = toset(local.subnets)
  id = each.key
}

data "aws_subnet" "pods" {
  for_each = toset(data.aws_subnets.pods.ids)
  id = each.key
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "random_id" "s3_id" {
  byte_length = 8
}

resource "aws_iam_policy" "eks_nodes" {
  name        = "BUPolicyForEksNodes-${local.cluster_name_env}"
  path        = "/"
  description = "Policy to grant access for Cluster Autoscaler, External DNS, Loki, EFS, etc."

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid": "ECRPullThrough0",
        "Effect" : "Allow",
        "Action" : [
          "ecr:BatchImportUpstreamImage",
          "ecr:CreateRepository"
        ],
        "Resource" : "arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/aws-public/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "ec2:DescribeLaunchTemplateVersions"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "autoscaling:UpdateAutoScalingGroup"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled" : "true",
            "autoscaling:ResourceTag/kubernetes.io/cluster/${local.cluster_name_env}" : "owned"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ChangeResourceRecordSets"
        ],
        "Resource" : [
          "arn:aws:route53:::hostedzone/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets"
        ],
        "Resource" : [
          "*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:List*",
          "s3:Get*",
          "s3:Put*"
        ],
        "Resource" : [
          "${aws_s3_bucket.eks_log_bucket.arn}",
          "${aws_s3_bucket.eks_log_bucket.arn}/*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "elasticfilesystem:*"
        ],
        "Resource": "*"
      },
      {
        "Effect":"Allow",
        "Action":[
            "ec2:DescribeVolumes",
            "ec2:DescribeSnapshots",
            "ec2:CreateTags",
            "ec2:CreateVolume",
            "ec2:CreateSnapshot",
            "ec2:DeleteSnapshot"
        ],
        "Resource":"*"
      },
      {
        "Effect":"Allow",
        "Action":[
            "s3:GetObject",
            "s3:DeleteObject",
            "s3:PutObject",
            "s3:AbortMultipartUpload",
            "s3:ListMultipartUploadParts"
        ],
        "Resource":[
            "${aws_s3_bucket.eks_backup_bucket.arn}/*"
        ]
      },
      {
        "Effect":"Allow",
        "Action":[
            "s3:ListBucket"
        ],
        "Resource":[
            "${aws_s3_bucket.eks_backup_bucket.arn}",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_nodes" {
  for_each   = merge(module.eks.eks_managed_node_groups, module.eks.eks_managed_node_group_infra)
  # for_each   = module.eks.eks_managed_node_groups
  policy_arn = aws_iam_policy.eks_nodes.arn
  role       = each.value.iam_role_name
}

resource "aws_iam_role" "karpenter_controller" {
  count = var.karpenter != "disabled" ? 1 : 0
  name = "KarpenterControllerRole-${local.cluster_name_env}"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.cluster_oidc_issuer}"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "${local.cluster_oidc_issuer}:aud": "sts.amazonaws.com",
                    "${local.cluster_oidc_issuer}:sub": "system:serviceaccount:kube-system:karpenter"
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_policy" "karpenter_controller" {
  count = var.karpenter != "disabled" ? 1 : 0
  name_prefix = "KarpenterControllerPolicy-${local.cluster_name_env}-"
  policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "ssm:GetParameter",
                "ec2:DescribeImages",
                "ec2:RunInstances",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeLaunchTemplates",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeInstanceTypeOfferings",
                "ec2:DescribeAvailabilityZones",
                "ec2:DeleteLaunchTemplate",
                "ec2:CreateTags",
                "ec2:CreateLaunchTemplate",
                "ec2:CreateFleet",
                "ec2:DescribeSpotPriceHistory",
                "pricing:GetProducts"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "Karpenter"
        },
        {
            "Action": "ec2:TerminateInstances",
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/karpenter.sh/nodepool": "*"
                }
            },
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "ConditionalEC2Termination"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/KarpenterNodeRole-${local.cluster_name_env}",
            "Sid": "PassNodeIAMRole"
        },
        {
            "Effect": "Allow",
            "Action": "eks:DescribeCluster",
            "Resource": "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/${local.cluster_name_env}",
            "Sid": "EKSClusterEndpointLookup"
        },
        {
            "Sid": "AllowScopedInstanceProfileCreationActions",
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
            "iam:CreateInstanceProfile"
            ],
            "Condition": {
            "StringEquals": {
                "aws:RequestTag/kubernetes.io/cluster/${local.cluster_name_env}": "owned",
                "aws:RequestTag/topology.kubernetes.io/region": "${data.aws_region.current.name}"
            },
            "StringLike": {
                "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass": "*"
            }
            }
        },
        {
            "Sid": "AllowScopedInstanceProfileTagActions",
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
            "iam:TagInstanceProfile"
            ],
            "Condition": {
            "StringEquals": {
                "aws:ResourceTag/kubernetes.io/cluster/${local.cluster_name_env}": "owned",
                "aws:ResourceTag/topology.kubernetes.io/region": "${data.aws_region.current.name}",
                "aws:RequestTag/kubernetes.io/cluster/${local.cluster_name_env}": "owned",
                "aws:RequestTag/topology.kubernetes.io/region": "${data.aws_region.current.name}"
            },
            "StringLike": {
                "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass": "*",
                "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass": "*"
            }
            }
        },
        {
            "Sid": "AllowScopedInstanceProfileActions",
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
            "iam:AddRoleToInstanceProfile",
            "iam:RemoveRoleFromInstanceProfile",
            "iam:DeleteInstanceProfile"
            ],
            "Condition": {
            "StringEquals": {
                "aws:ResourceTag/kubernetes.io/cluster/${local.cluster_name_env}": "owned",
                "aws:ResourceTag/topology.kubernetes.io/region": "${data.aws_region.current.name}"
            },
            "StringLike": {
                "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass": "*"
            }
            }
        },
        {
            "Sid": "AllowInstanceProfileReadActions",
            "Effect": "Allow",
            "Resource": "*",
            "Action": "iam:GetInstanceProfile"
        }
    ],
    "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_role_policy_attachment" "karpenter_controller" {
  count = var.karpenter != "disabled" ? 1 : 0
  # name = "KarpenterControllerPolicy-${local.cluster_name_env}"
  role = var.karpenter != "disabled" ? aws_iam_role.karpenter_controller.0.name : ""
  policy_arn = var.karpenter != "disabled" ? aws_iam_policy.karpenter_controller.0.arn : ""
}

resource "aws_iam_role" "karpenter_node" {
  count = var.karpenter != "disabled" ? 1 : 0
  name = "KarpenterNodeRole-${local.cluster_name_env}"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF  
}

resource "aws_iam_role_policy_attachment" "karpenter_node" {
  for_each = tomap(var.karpenter != "disabled" ? {
    "${data.aws_iam_policy.eks_worker_node.name}" = data.aws_iam_policy.eks_worker_node.arn 
    "${data.aws_iam_policy.eks_cni.name}" = data.aws_iam_policy.eks_cni.arn
    "${data.aws_iam_policy.ebs_csi_driver.name}" = data.aws_iam_policy.ebs_csi_driver.arn
    "${data.aws_iam_policy.ssm_instance.name}" = data.aws_iam_policy.ssm_instance.arn
    "${data.aws_iam_policy.ec2_ecr_readonly.name}" = data.aws_iam_policy.ec2_ecr_readonly.arn
    "${aws_iam_policy.eks_nodes.name}" = aws_iam_policy.eks_nodes.arn
 } : {})
  # name = "KarpenterNodePolicy-${each.key}"
  role = var.karpenter != "disabled" ? aws_iam_role.karpenter_node.0.name : ""
  policy_arn = each.value
}

resource "aws_ec2_tag" "karpenter_discovery_subnets" {
  for_each = var.karpenter != "disabled" ? toset(data.aws_subnets.private.ids) : []
  resource_id = each.value
  key = "karpenter.sh/discovery"
  value = local.cluster_name_env
}

resource "aws_security_group" "one" {
  name_prefix = "${var.project_name}-eks-group-one"
  vpc_id      = data.aws_vpc.thevpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8"
    ]
  }
  # Enable master to node Metrics
  ingress {
    from_port   = 4443
    to_port     = 4443
    protocol    = "tcp"
    description = "Metric port"
    cidr_blocks = values(data.aws_subnet.private).*.cidr_block
  }
  
  # Enable usage of Prometheus with Kubernetes metrics
  ingress {
    from_port = 9090
    to_port   = 9090
    protocol  = "tcp"
    description = "Prometheus via API/proxy to EKS worker"
    cidr_blocks = ["10.0.0.0/8"]
  }

  # Enable master to Istio
  ingress {
    from_port   = 15017
    to_port     = 15017
    protocol    = "tcp"
    description = "Istiod port"
    cidr_blocks = values(data.aws_subnet.private).*.cidr_block
  }

  # Enable master to Istio
  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    description = "Istiod port"
    cidr_blocks = values(data.aws_subnet.private).*.cidr_block
  }

  # Enable master to Istio
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "Istiod port"
    cidr_blocks = values(data.aws_subnet.private).*.cidr_block
  }

  tags = var.karpenter != "disabled" ? merge({
    "karpenter.sh/discovery" = local.cluster_name_env
  }, local.common_tags) : local.common_tags
}

resource "aws_security_group" "efs" {
  count       = var.efs_enabled ? 1 : 0
  name_prefix = "${local.cluster_name_env}-efs"
  vpc_id      = data.aws_vpc.thevpc.id

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    description = "EFS File System"
    cidr_blocks = values(data.aws_subnet.private).*.cidr_block
  }

  tags = local.common_tags
}

#### KMS ####

resource "aws_kms_key" "eks_secret" {
  description             = "${upper(var.resource_business_unit)}-EKS"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy = <<EOF
{
    "Id": "${var.resource_business_unit}-eks-policy-1",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/BUAdministratorAccessRole"
                ]
            },
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
}
EOF

  tags = local.common_tags
}

# The EEC AMIs are encrypted, as such, we need to grant the 
# Auto Scaling Service Link Role access to use the KMS key so it can decrypt 
# the root volume for usage.
resource "aws_kms_grant" "eec_kms_asg_grant" {
  name              = "eec-ami-asg-grant"
  key_id            = local.eec_kms_key[data.aws_region.current.name]
  grantee_principal = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
  operations        = ["Encrypt", "Decrypt", "ReEncryptFrom", "ReEncryptTo", "GenerateDataKey", "GenerateDataKeyWithoutPlaintext", "DescribeKey", "CreateGrant"]
}

resource "aws_kms_grant" "eec_kms_karpenter_grant" {
  count = var.karpenter != "disabled" ? 1 : 0
  name              = "eec-ami-karpenter-grant"
  key_id            = local.eec_kms_key[data.aws_region.current.name]
  grantee_principal = var.karpenter != "disabled" ? aws_iam_role.karpenter_controller.0.arn : ""
  operations        = ["Encrypt", "Decrypt", "ReEncryptFrom", "ReEncryptTo", "GenerateDataKey", "GenerateDataKeyWithoutPlaintext", "DescribeKey", "CreateGrant"]
}

#### EFS ####

resource "aws_efs_file_system" "eks_file_system" {
  depends_on = [
    resource.aws_security_group.efs
  ]

  count = var.efs_enabled ? 1 : 0

  encrypted  = true

  throughput_mode = "elastic"
  
  lifecycle_policy {
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = local.common_tags
}

resource "aws_efs_backup_policy" "policy" {
  count = var.efs_enabled ? 1 : 0
  file_system_id = aws_efs_file_system.eks_file_system[count.index].id
  backup_policy {
    status = "ENABLED"
  }
}

resource "aws_efs_mount_target" "eks_file_system" {
  for_each        = var.efs_enabled ? toset(local.subnets) : []
  file_system_id  = aws_efs_file_system.eks_file_system[0].id
  subnet_id       = each.key
  security_groups = [aws_security_group.efs[0].id]
}

resource "aws_efs_file_system_policy" "policy" {
  count = var.efs_enabled ? 1 : 0
  file_system_id = aws_efs_file_system.eks_file_system[count.index].id
  bypass_policy_lockout_safety_check = true
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "elasticfilesystem:ClientRootAccess",
                "elasticfilesystem:ClientWrite",
                "elasticfilesystem:ClientMount"
            ],
            "Condition": {
                "Bool": {
                    "elasticfilesystem:AccessedViaMountTarget": "true"
                }
            },
            "Resource": "${aws_efs_file_system.eks_file_system.0.arn}"
        },
        {
            "Effect": "Deny",
            "Principal": {
                "AWS": "*"
            },
            "Action": "*",
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            },
            "Resource": "${aws_efs_file_system.eks_file_system.0.arn}"
        }
    ]
}
POLICY
}

resource "aws_s3_bucket" "eks_accesslog_bucket" {
  bucket       = local.s3_bucket_access_logs

  tags = merge(local.required_tags, {
    BucketType = "Log"
    Asset_Category = "Logs"
    Data_Category = "N/A"
    Data_Type = "N/A"
  })
}

resource "aws_s3_bucket_logging" "eks_accesslog_bucket" {
  depends_on = [ aws_s3_bucket.eks_accesslog_bucket ]
  bucket = aws_s3_bucket.eks_accesslog_bucket.bucket

  target_bucket = local.s3_bucket_access_logs
  target_prefix = "access-logs/"
}

resource "aws_s3_bucket_versioning" "eks_accesslog_bucket" {
  depends_on = [ aws_s3_bucket.eks_accesslog_bucket ]
  bucket = aws_s3_bucket.eks_accesslog_bucket.bucket
  
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "eks_accesslog_bucket" {
  depends_on = [ aws_s3_bucket.eks_accesslog_bucket ]
  bucket = aws_s3_bucket.eks_accesslog_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "eks_accesslog_bucket_policy" {
  depends_on = [aws_s3_bucket.eks_accesslog_bucket]
  bucket     = aws_s3_bucket.eks_accesslog_bucket.id
  policy     = <<EOF
{
    "Version": "2012-10-17",
    "Id": "Policy1621613846656",
    "Statement": [
       {
            "Sid": "Stmt1611277877767",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "s3:*",
            "Resource": "${aws_s3_bucket.eks_accesslog_bucket.arn}/*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::507241528517:root"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.eks_accesslog_bucket.arn}/*"
        },
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "delivery.logs.amazonaws.com"
          },
          "Action": "s3:PutObject",
          "Resource": "${aws_s3_bucket.eks_accesslog_bucket.arn}/*",
          "Condition": {
            "StringEquals": {
              "s3:x-amz-acl": "bucket-owner-full-control"
            }
          }
        },
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "delivery.logs.amazonaws.com"
          },
          "Action": "s3:GetBucketAcl",
          "Resource": "${aws_s3_bucket.eks_accesslog_bucket.arn}"
        }
    ]
}
EOF
}

resource "aws_s3_bucket_public_access_block" "eks_accesslog_bucket_access_block" {
  depends_on = [aws_s3_bucket.eks_accesslog_bucket]
  bucket     = aws_s3_bucket.eks_accesslog_bucket.id
  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}

#####

resource "aws_s3_bucket" "eks_log_bucket" {
  depends_on   = [aws_s3_bucket.eks_accesslog_bucket]
  bucket       = "se-${random_id.s3_id.hex}-${local.cluster_name_env}-metrics-logs"

  tags = merge(local.required_tags, {
    BucketType = "Log"
    Asset_Category = "Logs"
    Data_Category = "N/A"
    Data_Type = "N/A"
  })
}

resource "aws_s3_bucket_logging" "eks_log_bucket" {
  depends_on = [ aws_s3_bucket.eks_log_bucket ]
  bucket = aws_s3_bucket.eks_log_bucket.bucket

  target_bucket = aws_s3_bucket.eks_accesslog_bucket.id
  target_prefix = "metrics-logs/"
}

resource "aws_s3_bucket_versioning" "eks_log_bucket" {
  depends_on = [ aws_s3_bucket.eks_log_bucket ]
  bucket = aws_s3_bucket.eks_log_bucket.bucket
  
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "eks_log_bucket" {
  depends_on = [ aws_s3_bucket.eks_log_bucket ]
  bucket = aws_s3_bucket.eks_log_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "eks_log_bucket_policy" {
  depends_on = [aws_s3_bucket.eks_log_bucket]
  bucket     = aws_s3_bucket.eks_log_bucket.id
  policy     = <<EOF
{
    "Version": "2012-10-17",
    "Id": "Policy1621613846656",
    "Statement": [
       {
            "Sid": "Stmt1611277877767",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "s3:*",
            "Resource": "${aws_s3_bucket.eks_log_bucket.arn}/*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::507241528517:root"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.eks_log_bucket.arn}/*"
        },
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "delivery.logs.amazonaws.com"
          },
          "Action": "s3:PutObject",
          "Resource": "${aws_s3_bucket.eks_log_bucket.arn}/*",
          "Condition": {
            "StringEquals": {
              "s3:x-amz-acl": "bucket-owner-full-control"
            }
          }
        },
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "delivery.logs.amazonaws.com"
          },
          "Action": "s3:GetBucketAcl",
          "Resource": "${aws_s3_bucket.eks_log_bucket.arn}"
        }
    ]
}
EOF
}

resource "aws_s3_bucket_public_access_block" "eks_log_bucket_access_block" {
  depends_on = [aws_s3_bucket.eks_log_bucket]
  bucket     = aws_s3_bucket.eks_log_bucket.id
  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}

#####

resource "aws_s3_bucket" "eks_helm_bucket" {
  depends_on   = [aws_s3_bucket.eks_accesslog_bucket]
  bucket       = "se-${random_id.s3_id.hex}-${local.cluster_name_env}-helm-charts"

  tags = merge(local.required_tags, {
    BucketType = "Helm"
    Asset_Category = "Metadata"
    Data_Category = "N/A"
    Data_Type = "N/A"
  })
}

resource "aws_s3_bucket_logging" "eks_helm_bucket" {
  depends_on = [ aws_s3_bucket.eks_helm_bucket ]
  bucket = aws_s3_bucket.eks_helm_bucket.bucket

  target_bucket = aws_s3_bucket.eks_accesslog_bucket.id
  target_prefix = "helm-charts/"
}

resource "aws_s3_bucket_versioning" "eks_helm_bucket" {
  depends_on = [ aws_s3_bucket.eks_helm_bucket ]
  bucket = aws_s3_bucket.eks_helm_bucket.bucket
  
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "eks_helm_bucket" {
  depends_on = [ aws_s3_bucket.eks_helm_bucket ]
  bucket = aws_s3_bucket.eks_helm_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "eks_helm_bucket_policy" {
  depends_on = [aws_s3_bucket.eks_helm_bucket]
  bucket     = aws_s3_bucket.eks_helm_bucket.id
  policy     = <<EOF
{
    "Version": "2012-10-17",
    "Id": "Policy1621613846656",
    "Statement": [
       {
            "Sid": "Stmt1611277877767",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "s3:*",
            "Resource": "${aws_s3_bucket.eks_helm_bucket.arn}/*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::507241528517:root"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.eks_helm_bucket.arn}/*"
        },
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "delivery.logs.amazonaws.com"
          },
          "Action": "s3:PutObject",
          "Resource": "${aws_s3_bucket.eks_helm_bucket.arn}/*",
          "Condition": {
            "StringEquals": {
              "s3:x-amz-acl": "bucket-owner-full-control"
            }
          }
        },
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "delivery.logs.amazonaws.com"
          },
          "Action": "s3:GetBucketAcl",
          "Resource": "${aws_s3_bucket.eks_helm_bucket.arn}"
        }
    ]
}
EOF
}

resource "aws_s3_bucket_public_access_block" "eks_helm_bucket_access_block" {
  depends_on = [aws_s3_bucket.eks_helm_bucket]
  bucket     = aws_s3_bucket.eks_helm_bucket.id
  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}

#####

resource "aws_s3_bucket" "eks_backup_bucket" {
  depends_on   = [aws_s3_bucket.eks_accesslog_bucket]
  bucket       = "se-${random_id.s3_id.hex}-${local.cluster_name_env}-backup"

  tags = merge(local.required_tags, {
    BucketType = "Backup"
    Asset_Category = "Backup"
    Data_Category = "N/A"
    Data_Type = "N/A"
  })
}

resource "aws_s3_bucket_logging" "eks_backup_bucket" {
  depends_on = [ aws_s3_bucket.eks_backup_bucket ]
  bucket = aws_s3_bucket.eks_backup_bucket.bucket

  target_bucket = aws_s3_bucket.eks_accesslog_bucket.id
  target_prefix = "backup-logs/"
}

resource "aws_s3_bucket_versioning" "eks_backup_bucket" {
  depends_on = [ aws_s3_bucket.eks_backup_bucket ]
  bucket = aws_s3_bucket.eks_backup_bucket.bucket
  
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "eks_backup_bucket" {
  depends_on = [ aws_s3_bucket.eks_backup_bucket ]
  bucket = aws_s3_bucket.eks_backup_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "eks_backup_bucket_policy" {
  depends_on = [aws_s3_bucket.eks_backup_bucket]
  bucket     = aws_s3_bucket.eks_backup_bucket.id
  policy     = <<EOF
{
    "Version": "2012-10-17",
    "Id": "Policy1621613846656",
    "Statement": [
       {
            "Sid": "Stmt1611277877767",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "s3:*",
            "Resource": "${aws_s3_bucket.eks_backup_bucket.arn}/*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::507241528517:root"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.eks_backup_bucket.arn}/*"
        },
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "delivery.logs.amazonaws.com"
          },
          "Action": "s3:PutObject",
          "Resource": "${aws_s3_bucket.eks_backup_bucket.arn}/*",
          "Condition": {
            "StringEquals": {
              "s3:x-amz-acl": "bucket-owner-full-control"
            }
          }
        },
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "delivery.logs.amazonaws.com"
          },
          "Action": "s3:GetBucketAcl",
          "Resource": "${aws_s3_bucket.eks_backup_bucket.arn}"
        }
    ]
}
EOF
}

resource "aws_s3_bucket_public_access_block" "eks_backup_bucket_access_block" {
  depends_on = [aws_s3_bucket.eks_backup_bucket]
  bucket     = aws_s3_bucket.eks_backup_bucket.id
  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}

module "eks" {
  source                          = "./modules/terraform-aws-eks-18.17.0"
  # source  = "terraform-aws-modules/eks/aws"
  # version = "~> v19.21.0"

  cluster_name                    = local.cluster_name_env
  cluster_version                 = var.eks_cluster_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false

  cluster_enabled_log_types = [
    "audit",
    "api",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
      addon_version = var.eks_addons_version[var.eks_cluster_version].coredns
      configuration_values = jsonencode({
        nodeSelector = {
          Worker = "infra"
        }
      tolerations = [{
          key = "CriticalAddonsOnly"
          operator = "Exists"
        },{
          key = "node-role.kubernetes.io/control-plane"
          effect = "NoSchedule"
        },{
          key = "dedicated"
          operator = "Equal"
          value = "infra"
          effect = "NoSchedule"
        }]
      })
    }
    kube-proxy = {
      resolve_conflicts = "OVERWRITE"
      addon_version = var.eks_addons_version[var.eks_cluster_version].kube_proxy
    }
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
      addon_version = var.eks_addons_version[var.eks_cluster_version].vpc_cni
      configuration_values = jsonencode({
        env = {
          AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG = "true"
          ENABLE_PREFIX_DELEGATION = "true"
          ENI_CONFIG_LABEL_DEF = "topology.kubernetes.io/zone"
          WARM_PREFIX_TARGET = "1"
        }
      })
    }
    aws-ebs-csi-driver = {
      resolve_conflicts = "OVERWRITE"
      addon_version = var.eks_addons_version[var.eks_cluster_version].ebs_csi_driver
      configuration_values = jsonencode({
        controller = {
          nodeSelector = {
            Worker = "infra"
          }
          tolerations = [{
            "key": "CriticalAddonsOnly",
            "operator": "Exists"
          },
          {
            "effect": "NoExecute",
            "operator": "Exists",
            "tolerationSeconds": 300
          },{
            key = "dedicated"
            operator = "Equal"
            value = "infra"
            effect = "NoSchedule"
          }]
        }
      })
    }
  }

  cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.eks_secret.arn
    resources        = ["secrets"]
  }]

  tags = local.common_tags
  cluster_tags = var.karpenter != "disabled" ? merge({
    KarpenterSetupOn = var.service_request
  }, local.cluster_tags) : local.cluster_tags
  node_security_group_tags = var.karpenter != "disabled" ? {"karpenter.sh/discovery" = local.cluster_name_env} : {}

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
    ingress_cluster_dynatrace = {
      description                   = "Dynatrace API to node groups"
      protocol                      = "tcp"
      from_port                     = 8443
      to_port                       = 8443
      type                          = "ingress"
      source_cluster_security_group = true
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

  vpc_id                         = data.aws_vpc.thevpc.id
  subnet_ids                     = local.subnets
  enable_irsa                    = false
  create_iam_role                = true
  iam_role_use_name_prefix       = true

  # manage_aws_auth_configmap = true
  # aws_auth_roles = var.roles
  # aws_auth_users = var.users
  # aws_auth_accounts = [data.aws_caller_identity.current.account_id]

  iam_role_name                  = "BURoleForEksC${local.cluster_name_env}"
  cluster_encryption_policy_name = "BUPolicyForEKS-"
  iam_role_description           = "EKS Managed Cluster Group"
  iam_role_permissions_boundary  = data.aws_iam_policy.eec_boundary_policy.arn
  iam_role_tags = {
    ManagedBy = "Terraform"
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    vpc_security_group_ids        = [aws_security_group.one.id]
    iam_role_use_name_prefix      = true
    force_update_version          = true
    iam_role_name                 = "BURoleForEksN${local.cluster_name_env}"
    iam_role_description          = "EKS Managed Node Group"
    iam_role_permissions_boundary = data.aws_iam_policy.eec_boundary_policy.arn
    iam_role_additional_policies = [
      data.aws_iam_policy.ssm_instance.arn,
      data.aws_iam_policy.ebs_csi_driver.arn
    ]
    # iam_role_additional_policies = { 
    #   "AmazonSSMManagedInstanceCore" = data.aws_iam_policy.ssm_instance.arn
    #   "AmazonEBSCSIDriverPolicy" = data.aws_iam_policy.ebs_csi_driver.arn
    # }

    bootstrap_extra_args      = "--use-max-pods false  --kubelet-extra-args '--max-pods=250'"
    pre_bootstrap_user_data   = local.pre_bootstrap_user_data
    post_bootstrap_user_data  = "--//--"

    block_device_mappings = [{
      device_name = "/dev/xvda"
      ebs = {
        delete_on_termination = true
        encrypted   = true
        volume_type = "gp3"
        volume_size = 120
        iops        = 3000
        throughput  = 250
      }
    }]

    # timeouts = {
    #   create = "15 minutes"
    #   update = "60 minutes"
    #   delete = "20 minutes"
    # }
  }

  eks_managed_node_infra = {
    "${local.nodegroup_prefix}-infra" = {
      ami_id                     = local.ami_id
      enable_bootstrap_user_data = true
      instance_types            = tolist([var.eks_managed_node_infra_instance_type])
      min_size                  = 1
      max_size                  = var.eks_managed_node_infra_max_size
      desired_size              = 1
      
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

      tags = merge(local.ec2_tags, {
        Worker = "infra"
      })
    }
  }

  eks_managed_node_groups = local.nodegroups_map
}

# INFO localmente (notebook) este provider irá retornar o certificado do antivirus, quebrando o fluxo de deploy do Karpenter
data "tls_certificate" "eks" {
  url = module.eks.cluster_oidc_issuer_url
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates.0.sha1_fingerprint]
  url             = module.eks.cluster_oidc_issuer_url
}

data "template_file" "kubeconfig" {
  template = "${file("${path.module}/kubeconfig.yaml.tmpl")}"
  vars = {
    name                = data.aws_eks_cluster.cluster.name
    cluster_endpoint    = data.aws_eks_cluster.cluster.endpoint
    cluster_certificate = data.aws_eks_cluster.cluster.certificate_authority.0.data
    exec_arg_region       = data.aws_region.current.name
    exec_arg_cluster_name = local.cluster_name_env
    rolearn_params        = length(var.assume_role_arn) > 0 ? ", \"--role-arn\", \"${var.assume_role_arn}\"" : ""
  }
}

data "template_file" "eniconfig" {
  count = length(local.eniconfig_availabilityzone)
  template = "${file("${path.module}/eniconfig.yaml.tmpl")}"
  vars = {
    # resource_name      = "eniconfig-${local.eniconfig_availabilityzone[count.index].name}"
    resource_name      = local.eniconfig_availabilityzone[count.index].name
    security_group_ids = local.eniconfig_availabilityzone[count.index].security_groups
    subnet_id          = local.eniconfig_availabilityzone[count.index].subnet_id
  }
}

resource "local_file" "kubeconfig" {
  filename = "${path.module}/kubeconfig.yaml" 
  content = data.template_file.kubeconfig.rendered
}

resource "local_file" "eniconfigs" {
  filename = "${path.module}/eniconfigs.yaml" 
  content = local.eniconfig_yaml
}

resource "null_resource" "vpc_cni_eniconfigs" {
  depends_on = [ module.eks.cluster_id ]

  triggers = {
    manifest_sha1 = "${sha1("${local.eniconfig_yaml}")}"
  }

  provisioner "local-exec" {
    command = format("kubectl apply -f %s", local_file.eniconfigs.filename)
    environment = {
      KUBECONFIG = local_file.kubeconfig.filename
    }
  }
}

resource "null_resource" "vpc_cni_config" {
  depends_on = [ module.eks.cluster_id ]

  triggers = {
    manifest_sha1 = sha1("${data.aws_eks_cluster.cluster.endpoint}-${local.kubectl_cni_config_cmd}")
  }
  
  provisioner "local-exec" {
    command = format("kubectl %s", local.kubectl_cni_config_cmd)
    environment = {
      KUBECONFIG = local_file.kubeconfig.filename
    }
  }
}

resource "null_resource" "ebs_csi_proxy_vars" {
  depends_on = [
    module.eks.cluster_addons
  ]

  triggers = {
    manifest_sha1 = sha1("${module.eks.cluster_addons["aws-ebs-csi-driver"].modified_at}-${local.kubectl_proxy_cmds["aws-ebs-csi-driver"]}")
  }
  
  provisioner "local-exec" {
    command = format("kubectl %s", local.kubectl_proxy_cmds["aws-ebs-csi-driver"])
    environment = {
      KUBECONFIG = local_file.kubeconfig.filename
    }
  }
}

resource "null_resource" "wait_custom_networking" {
  depends_on = [
    module.eks,
    aws_iam_role_policy_attachment.eks_nodes,
    aws_kms_grant.eec_kms_asg_grant,
    null_resource.vpc_cni_config,
    null_resource.vpc_cni_eniconfigs,
    null_resource.ebs_csi_proxy_vars
  ]

  triggers = {
    manifest_sha1 = sha1("${data.aws_eks_cluster.cluster.endpoint}-${local.kubectl_wait}")
  }
  
  provisioner "local-exec" {
    command = format("kubectl %s", local.kubectl_wait)
    environment = {
      KUBECONFIG = local_file.kubeconfig.filename
    }
  }
}

resource "local_file" "karpenter_ec2nodeclass" {
  count = var.karpenter == "enabled+resources" ? 1 : 0
  filename = "${path.module}/karpenter_ec2nodeclass.yaml"
  content = <<EOF
apiVersion: karpenter.k8s.aws/v1beta1
kind: EC2NodeClass
metadata:
  name: servicecatalog
spec:
  amiFamily: AL2
  amiSelectorTerms:
    - id: ${local.ami_id}
  blockDeviceMappings:
    - deviceName: /dev/xvda
      ebs:
        deleteOnTermination: true
        iops: 3000
        throughput: 250
        volumeSize: 120Gi
        volumeType: gp3
  metadataOptions:
    httpEndpoint: enabled
    httpProtocolIPv6: disabled
    httpPutResponseHopLimit: 2
    httpTokens: required
  role: ${var.karpenter == "enabled+resources" ? aws_iam_role.karpenter_node.0.name : ""}
  securityGroupSelectorTerms:
    - tags:
        karpenter.sh/discovery: ${local.cluster_name_env}
  subnetSelectorTerms:
    - tags:
        karpenter.sh/discovery: ${local.cluster_name_env}
  tags:
    Name: EKS-${local.cluster_name_env}-I-karpenter
    ${indent(4, yamlencode(local.ec2_tags))}
  userData: |
    MIME-Version: 1.0
    Content-Type: multipart/mixed; boundary="//"

    ${var.use_proxy == "no-proxy" ? "" : indent(4, local.proxy_user_data)}--//--
EOF  
} # indent(4, base64decode(data.aws_launch_template.nodegroup_infra.user_data))

resource "null_resource" "karpenter_ec2nodeclass" {
  depends_on = [ helm_release.karpenter ]
  count = var.karpenter == "enabled+resources" ? 1 : 0

  triggers = {
    manifest_sha1 = "${sha1("${local_file.karpenter_ec2nodeclass.0.content}")}"
  }

  provisioner "local-exec" {
    command = "kubectl delete -f ${local_file.karpenter_ec2nodeclass.0.filename} ; kubectl create -f ${local_file.karpenter_ec2nodeclass.0.filename}"
    environment = {
      KUBECONFIG = local_file.kubeconfig.filename
    }
  }
}

data "local_file" "karpenter_nodepool" {
  count = var.karpenter == "enabled+resources" ? 1 : 0
  filename = "${path.module}/karpenter_nodepool.yaml"
}

resource "null_resource" "karpenter_nodepool" {
  depends_on = [ helm_release.karpenter ]
  count = var.karpenter == "enabled+resources" ? 1 : 0

  triggers = {
    manifest_sha1 = "${sha1("${data.local_file.karpenter_nodepool.0.content}")}"
  }

  provisioner "local-exec" {
    command = format("kubectl apply -f %s", data.local_file.karpenter_nodepool.0.filename)
    environment = {
      KUBECONFIG = local_file.kubeconfig.filename
    }
  }
}
