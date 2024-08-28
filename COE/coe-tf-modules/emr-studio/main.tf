data "aws_region" "current" {}
data "aws_partition" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  partition  = data.aws_partition.current.partition
  region     = data.aws_region.current.name

  auth_mode_is_sso = var.auth_mode == "SSO"

  tags = merge(var.tags, { terraform-aws-modules = "emr" })
}

################################################################################
# Studio
################################################################################

resource "aws_emr_studio" "this" {
  count = var.create ? 1 : 0

  auth_mode                      = var.auth_mode
  default_s3_location            = var.default_s3_location
  description                    = var.description
  engine_security_group_id       = local.create_security_groups ? aws_security_group.engine[0].id : var.engine_security_group_id
  idp_auth_url                   = var.idp_auth_url
  idp_relay_state_parameter_name = var.idp_relay_state_parameter_name
  name                           = replace(lower(var.name),"_", "-")
  service_role                   = var.create_service_role ? aws_iam_role.service[0].arn : var.service_role_arn
  subnet_ids                     = data.aws_subnets.experian.ids
  user_role                      = var.create_user_role && local.auth_mode_is_sso ? aws_iam_role.user[0].arn : var.user_role_arn
  vpc_id                         = data.aws_vpc.selected.id
  workspace_security_group_id    = local.create_security_groups ? aws_security_group.workspace[0].id : var.workspace_security_group_id

  tags = local.tags
}

################################################################################
# Service IAM Role
################################################################################

locals {
  create_service_role        = var.create && var.create_service_role
  create_service_role_policy = local.create_service_role && var.create_service_role_policy

  service_role_name = coalesce(var.service_role_name, "${var.name}-service")
  service_role_policy_name = coalesce(var.service_role_policy_name, "${var.name}-service")
}

resource "aws_iam_role" "service" {
  count = local.create_service_role ? 1 : 0

  name        = var.service_role_use_name_prefix ? null : local.service_role_name
  name_prefix = var.service_role_use_name_prefix ? "${local.service_role_name}-" : null
  path        = var.service_role_path
  description = coalesce(var.service_role_description, "Service role for EMR Studio ${var.name}")

  assume_role_policy    = data.aws_iam_policy_document.service_assume[0].json
  permissions_boundary  = data.aws_iam_policy.eec_boundary_policy.arn
  force_detach_policies = true

  tags = merge(local.tags, var.service_role_tags)
}

data "aws_iam_policy_document" "service_assume" {
  count = local.create_service_role ? 1 : 0

  statement {
    sid     = "EMRAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["elasticmapreduce.${data.aws_partition.current.dns_suffix}"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:${local.partition}:elasticmapreduce:${local.region}:${local.account_id}:*"]
    }
  }
}

################################################################################
# Service IAM Role Policy
################################################################################

# https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-studio-service-role.html#emr-studio-service-role-permissions-table
data "aws_iam_policy_document" "service" {
  count = local.create_service_role_policy ? 1 : 0

  statement {
    sid = "AllowEMRReadOnlyActions"
    actions = [
      "elasticmapreduce:ListInstances",
      "elasticmapreduce:DescribeCluster",
      "elasticmapreduce:ListSteps",
    ]
    resources = ["*"]
  }

  statement {
    sid = "AllowEC2ENIActionsWithEMRTags"
    actions = [
      "ec2:CreateNetworkInterfacePermission",
      "ec2:DeleteNetworkInterface",
    ]
    resources = ["arn:${local.partition}:ec2:${local.region}:${local.account_id}:network-interface/*"]
  }

  statement {
    sid     = "AllowEC2ENIAttributeAction"
    actions = ["ec2:ModifyNetworkInterfaceAttribute"]
    resources = [
      "arn:${local.partition}:ec2:${local.region}:${local.account_id}:instance/*",
      "arn:${local.partition}:ec2:${local.region}:${local.account_id}:network-interface/*",
      "arn:${local.partition}:ec2:${local.region}:${local.account_id}:security-group/*",
    ]
  }

  statement {
    sid = "AllowEC2SecurityGroupActionsWithEMRTags"
    actions = [
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:DeleteNetworkInterfacePermission",
    ]
    resources = ["*"]
  }

  statement {
    sid       = "AllowDefaultEC2SecurityGroupsCreationWithEMRTags"
    actions   = ["ec2:CreateSecurityGroup"]
    resources = ["arn:${local.partition}:ec2:${local.region}:${local.account_id}:security-group/*"]
  }

  statement {
    sid       = "AllowDefaultEC2SecurityGroupsCreationInVPCWithEMRTags"
    actions   = ["ec2:CreateSecurityGroup"]
    resources = ["arn:${local.partition}:ec2:${local.region}:${local.account_id}:vpc/*"]

  }

  statement {
    sid       = "AllowAddingEMRTagsDuringDefaultSecurityGroupCreation"
    actions   = ["ec2:CreateTags"]
    resources = ["arn:${local.partition}:ec2:${local.region}:${local.account_id}:security-group/*"]

  }

  statement {
    sid       = "AllowEC2ENICreationWithEMRTags"
    actions   = ["ec2:CreateNetworkInterface"]
    resources = ["arn:${local.partition}:ec2:${local.region}:${local.account_id}:network-interface/*"]

  }

  statement {
    sid     = "AllowEC2ENICreationInSubnetAndSecurityGroupWithEMRTags"
    actions = ["ec2:CreateNetworkInterface"]
    resources = [
      "arn:${local.partition}:ec2:${local.region}:${local.account_id}:subnet/*",
      "arn:${local.partition}:ec2:${local.region}:${local.account_id}:security-group/*"
    ]

  }

  statement {
    sid       = "AllowAddingTagsDuringEC2ENICreation"
    actions   = ["ec2:CreateTags"]
    resources = ["arn:${local.partition}:ec2:${local.region}:${local.account_id}:network-interface/*"]

  }

  statement {
    sid = "AllowEC2ReadOnlyActions"
    actions = [
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeTags",
      "ec2:DescribeInstances",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
    ]
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = length(var.service_role_secrets_manager_arns) == 0 ? [1] : []

    content {
      sid       = "AllowSecretsManagerReadOnlyActionsWithEMRTags"
      actions   = ["secretsmanager:GetSecretValue"]
      resources = ["arn:${local.partition}:secretsmanager:${local.region}:${local.account_id}:secret:*"]

    }
  }

  dynamic "statement" {
    for_each = length(var.service_role_secrets_manager_arns) > 0 ? [1] : []

    content {
      sid       = "AllowSecretsManagerReadOnlyActionsWithARNs"
      actions   = ["secretsmanager:GetSecretValue"]
      resources = var.service_role_secrets_manager_arns
    }
  }

  statement {
    sid = "AllowWorkspaceCollaboration"
    actions = [
      "iam:GetUser",
      "iam:GetRole",
      "iam:ListUsers",
      "iam:ListRoles",
      "sso:GetManagedApplicationInstance",
      "sso-directory:SearchUsers",
      "cloudformation:GetTemplateSummary"
    ]
    resources = ["*"]
  }

  statement {
    sid = "S3ReadWrite"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetEncryptionConfiguration",
      "s3:ListBucket",
      "s3:DeleteObject",
    ]
    resources = coalescelist(
      var.service_role_s3_bucket_arns,
      ["arn:${local.partition}:s3:::*"]
    )
  }
  statement {
    sid = "AllowConfigurationForWorkspaceCollaboration"
    actions = [
      "elasticmapreduce:UpdateEditor",
      "elasticmapreduce:PutWorkspaceAccess",
      "elasticmapreduce:DeleteWorkspaceAccess",
      "elasticmapreduce:ListWorkspaceAccessIdentities"
    ]
    resources = ["*"]
    
  }
  statement {
    sid = "EMRPresigned"
    actions = [
      "elasticmapreduce:CreateStudioPresignedUrl",
    ]
    resources = ["arn:aws:elasticmapreduce:${local.region}:${local.account_id}:studio/*"]
    
  }
  dynamic "statement" {
    for_each = var.service_role_statements

    content {
      sid           = try(statement.value.sid, null)
      actions       = try(statement.value.actions, null)
      not_actions   = try(statement.value.not_actions, null)
      effect        = try(statement.value.effect, null)
      resources     = try(statement.value.resources, null)
      not_resources = try(statement.value.not_resources, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = try(statement.value.not_principals, [])

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }
    }
  }
}

resource "aws_iam_policy" "service" {
  count = local.create_service_role_policy ? 1 : 0

  name        = var.service_role_use_name_prefix ? null : local.service_role_policy_name
  name_prefix = var.service_role_use_name_prefix ? "${local.service_role_policy_name}-" : null
  path        = var.service_role_path
  description = coalesce(var.service_role_description, "Service role policy for EMR Studio ${var.name}")

  policy = data.aws_iam_policy_document.service[0].json

  tags = merge(local.tags, var.service_role_tags)
}

resource "aws_iam_role_policy_attachment" "service" {
  count = local.create_service_role_policy ? 1 : 0

  policy_arn = aws_iam_policy.service[0].arn
  role       = aws_iam_role.service[0].name
}

resource "aws_iam_role_policy_attachment" "service_additional" {
  for_each = { for k, v in var.service_role_policies : k => v if local.create_service_role }

  policy_arn = each.value
  role       = aws_iam_role.service[0].name
}

################################################################################
# Studio Session Mapping
################################################################################

resource "aws_emr_studio_session_mapping" "this" {
  for_each = { for k, v in var.session_mappings : k => v if var.create && local.auth_mode_is_sso }

  identity_id        = try(each.value.identity_id, null)
  identity_name      = try(each.value.identity_name, null)
  identity_type      = each.value.identity_type
  session_policy_arn = try(each.value.session_policy_arn, aws_iam_policy.user[0].arn)
  studio_id          = aws_emr_studio.this[0].id
}

################################################################################
# User IAM Role
################################################################################

locals {
  create_user_role = var.create && var.create_user_role

  user_role_name = var.user_role_name
  user_role_policy_name = coalesce(var.user_role_policy_name, "${var.name}-user")
}

resource "aws_iam_role" "user" {
  count = local.create_user_role ? 1 : 0

  name        = local.user_role_name
  #name_prefix = var.user_role_use_name_prefix ? "${local.user_role_name}" : null
  path        = var.user_role_path
  description = var.user_role_description

  assume_role_policy    = data.aws_iam_policy_document.user_assume[0].json
  permissions_boundary  = data.aws_iam_policy.eec_boundary_policy.arn
  force_detach_policies = true

  tags = merge(local.tags, var.user_role_tags)
}

data "aws_iam_policy_document" "user_assume" {
  count = local.create_user_role ? 1 : 0

  statement {
    sid     = "EMRAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["elasticmapreduce.${data.aws_partition.current.dns_suffix}"]
    }
  }
    statement {
     sid     = "SAML"
    actions = ["sts:AssumeRoleWithSAML"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${local.account_id}:saml-provider/OktaSSO"]
    }
    condition {
      test     = "StringEquals"
      variable = "SAML:aud"
      values   = ["https://signin.aws.amazon.com/saml"]
    }
  }
  statement {
    sid     = "AccountAssumeRole"
    actions = ["sts:AssumeRole"]
  principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "user_additional" {
  for_each = { for k, v in var.user_role_policies : k => v if local.create_user_role }

  policy_arn = each.value
  role       = aws_iam_role.user[0].name
}

################################################################################
# User IAM Role Policy
################################################################################

locals {
  create_user_role_policy = var.create && var.create_user_role_policy
  
  team_name = lower(join("-", split("_", var.team)))

}

data "aws_iam_policy_document" "user" {
  count = local.create_user_role_policy ? 1 : 0
  statement {
    sid = "AllowCloudshellBasicActions"
    actions = [
      "cloudshell:CreateEnvironment",
      "cloudshell:DeleteEnvironment",
      "cloudshell:CreateSession",
      "cloudshell:GetEnvironmentStatus",
      "cloudshell:StartEnvironment",
      "cloudshell:StopEnvironment",
      "cloudshell:PutCredentials",
    ]
    resources = ["*"]
  }

  statement {
    sid = "AllowEMRTerminate"
    actions = [ 
      "elasticmapreduce:TerminateJobFlows"
    ]
    resources = [ 
      "*"
    ]
    condition {
      test = "StringEqualsIfExists"
      variable = "elasticmapreduce:ResourceTag/Team"
      values =[var.team]
    }
  }
 statement {
    sid = "AllowEMRBasicActions"
    actions = [
      "elasticmapreduce:CreateRepository",
      "elasticmapreduce:DescribeRepository",
      "elasticmapreduce:DeleteRepository",
      "elasticmapreduce:ListRepositories",
      "elasticmapreduce:LinkRepository",
      "elasticmapreduce:UnlinkRepository",
      "elasticmapreduce:CreatePersistentAppUI",
      "elasticmapreduce:DescribePersistentAppUI",
      "elasticmapreduce:GetPersistentAppUIPresignedURL",
      "elasticmapreduce:GetOnClusterAppUIPresignedURL",
      "elasticmapreduce:AddTags"
    ]
    resources = ["*"]
  }

  statement {
    sid = "AllowDescribeEMRStudio"
    actions = [
      "elasticmapreduce:DescribeStudio"
    ]
    resources =  ["arn:${local.partition}:elasticmapreduce:${local.region}:${local.account_id}:studio/*", aws_emr_studio.this[0].arn]
    
    condition {
      test = "StringEqualsIfExists"
      variable = "elasticmapreduce:ResourceTag/Team"
      values =[var.team]

    }
  }

  statement {
    sid = "AllowCreateEditor"
    effect = "Allow"
    actions = [
      "elasticmapreduce:CreateEditor"
    ]

    resources =  ["*"]
    
    condition {
      test = "StringEqualsIfExists"
      variable = "elasticmapreduce:ResourceTag/Team"
      values =[var.team]
    }

  }

  statement {
    sid = "AllowBasicActionsEMREditor"
    actions =[
      "elasticmapreduce:DescribeEditor",
      "elasticmapreduce:StartEditor",
      "elasticmapreduce:StopEditor",
      "elasticmapreduce:DeleteEditor",
      "elasticmapreduce:UpdateEditor",
      "elasticmapreduce:OpenEditorInConsole",
      "elasticmapreduce:AttachEditor",
      "elasticmapreduce:DetachEditor"
    ]

    resources =  ["*"]
    
  
  }

  statement {
    sid = "AllowListEMRClustersConfiguration"
    actions = [
      "elasticmapreduce:DescribeCluster", 
      "elasticmapreduce:ListStudioSessionMappings",
      "elasticmapreduce:ListSteps", 
      "elasticmapreduce:ListInstanceGroups",
      "elasticmapreduce:ListBootstrapActions" 
    ]
    resources =  ["*"]

    condition {
      test = "StringEqualsIfExists"
      variable = "elasticmapreduce:ResourceTag/Team"
      values =[var.team]
    }
    
  }

  statement {
    sid = "AllowListEMRServices"
    actions = [
      "elasticmapreduce:ListStudios",
      "elasticmapreduce:ListEditors",
      "elasticmapreduce:ListClusters",
      "emr-serverless:*" 

    ]
    resources =  ["*"]
    
  }

  statement {
    sid       = "AllowSecretManagerListSecrets"
    actions   = ["secretsmanager:ListSecrets"]
    resources = ["*"]
  }

  statement {
    sid       = "AllowSecretCreationWithEMRTagsAndEMRStudioPrefix"
    actions   = ["secretsmanager:CreateSecret"]
    resources = ["arn:${local.partition}:secretsmanager:${local.region}:${local.account_id}:secret:emr-studio-*", ]
  }

  statement {
    sid       = "AllowAddingTagsOnSecretsWithEMRStudioPrefix"
    actions   = ["secretsmanager:TagResource"]
    resources = ["arn:${local.partition}:secretsmanager:${local.region}:${local.account_id}:secret:emr-studio-*"]
  }

  statement {
    sid = "AllowClusterTemplateRelatedIntermediateActions"
    actions = [
      "servicecatalog:DescribeProduct",
      "servicecatalog:DescribeProductView",
      "servicecatalog:DescribeProvisioningParameters",
      "servicecatalog:ProvisionProduct",
      "servicecatalog:UpdateProvisionedProduct",
      "servicecatalog:ListProvisioningArtifacts",
      "servicecatalog:ListLaunchPaths"
    ]
    resources = ["*"]

    condition {
      test = "StringEqualsIfExists" 
      variable = "servicecatalog:ResourceTag/Team"
      values =[var.team]
    }
  }

  statement {
    sid = "AllowCloudFormationTemplateRelatedActions"
    actions = [
      "cloudformation:DescribeStackResources",
      "cloudformation:GetTemplateSummary",
      "servicecatalog:DescribeRecord"
    ]
    resources = ["*"]
  }

  statement {
    sid = "AllowSearchProductsCatalog"
    actions = [
      "servicecatalog:SearchProducts",
      "servicecatalog:SearchProvisionedProducts"
    ]
    resources =  ["*"]
  }


  statement {
    sid = "AllowCloudformationActions"
    actions = [
      
      "cloudformation:CreateStack"
    ]
    resources = ["arn:aws:cloudformation:${local.region}:${local.account_id}:stack/SC-${local.account_id}-*"]
  }
  statement {
    sid       = "AllowEMRCreateClusterAdvancedActions"
    actions   = ["elasticmapreduce:RunJobFlow"]
    resources = ["*"]
  }

  statement {
    sid     = "AllowPassingServiceRoleForWorkspaceCreation"
    actions = ["iam:PassRole"]
    resources = [
      var.create_service_role ? aws_iam_role.service[0].arn : var.service_role_arn,
      "arn:${local.partition}:iam::${local.account_id}:role/${var.cluster_role_name}",
      "arn:${local.partition}:iam::${local.account_id}:role/BURoleForEMREC2DefaultRole",
      "arn:${local.partition}:iam::${local.account_id}:role/BURoleForEMREC2Role",
      "arn:${local.partition}:iam::${local.account_id}:role/eec-aws-standard-emr-defaultrole",

    ]
  }

  statement {
    sid = "AllowConfigurationForWorkspaceCollaboration"
    actions = [
      "elasticmapreduce:UpdateEditor",
      "elasticmapreduce:PutWorkspaceAccess",
      "elasticmapreduce:DeleteWorkspaceAccess",
      "elasticmapreduce:ListWorkspaceAccessIdentities",
    ]
    resources = ["*"]
  }

  statement {
    sid = "DescribeNetwork"
    actions = [
      "ec2:DescribeVpcs",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
    ]
    resources = ["*"]
  }

  statement {
    sid       = "ListIAMRoles"
    actions   = ["iam:ListRoles"]
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = var.user_role_statements

    content {
      sid           = try(statement.value.sid, null)
      actions       = try(statement.value.actions, null)
      not_actions   = try(statement.value.not_actions, null)
      effect        = try(statement.value.effect, null)
      resources     = try(statement.value.resources, null)
      not_resources = try(statement.value.not_resources, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = try(statement.value.not_principals, [])

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

    }
  }
  statement {
    sid = "EMRPresigned"
    actions = [
      "elasticmapreduce:CreateStudioPresignedUrl",
    ]
    resources = ["arn:aws:elasticmapreduce:${local.region}:${local.account_id}:studio/*"]

      condition {
      test = "StringEqualsIfExists"
      variable = "elasticmapreduce:ResourceTag/Team"
      values =[var.team]
    }
    
  }
  depends_on = [ aws_s3_bucket.cloudformation_template_bucket ]
}


locals {

  buckets_arns_allow = flatten([ for name in var.buckets_name_allow_emr_studio_role : ["arn:aws:s3:::${name}", "arn:aws:s3:::${name}/*"] ])

  buckets_arns_deny = flatten([[ for name in var.buckets_name_deny_emr_studio_role : ["arn:aws:s3:::${name}", "arn:aws:s3:::${name}/*"] ], 
                               [ for name in var.team_list : ["arn:aws:s3:::serasaexperian-da-${var.project_name}-${name}-${var.env}", 
                                                                    "arn:aws:s3:::serasaexperian-da-${var.project_name}-${name}-${var.env}/*",
                                                                    "arn:aws:s3:::*-workspace-${name}-${var.env}",
                                                                    "arn:aws:s3:::*-workspace-${name}-${var.env}/*",
                                                                    "arn:aws:s3:::*-cfn-tmpl-${name}-${var.env}",
                                                                    "arn:aws:s3:::*-cfn-tmpl-${name}-${var.env}/*"] if name != local.team_name ]])

  buckets_prefix = flatten([ for name in var.team_list: 
                              [ for name_prefix in var.team_list: ["arn:aws:s3:::*ift-dev/${name}/${name_prefix}/*"] 
                                if name != name_prefix  && name_prefix != local.team_name ] 
                           if name != local.team_name ] 
                          ) 
}

data "aws_iam_policy_document" "bucket_actions_allow" {

  statement {
    sid = "AllowS3ListAllBuckets"
    actions = [
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      "s3:GetObject"
    ]
    resources =  ["*"]
  }

  statement {
    sid = "AllowS3ListAndLocationPermissions"
    actions = [
      "s3:GetBucketLocation",
      "s3:PutObject"
    ]

    resources = coalescelist(
      var.user_role_s3_bucket_arns,
      concat(["arn:aws:s3:::${var.s3_emr_cluster_logs}" ,"arn:aws:s3:::${var.s3_emr_cluster_logs}/*"])
    )
  }

  dynamic "statement" {
    for_each = local.buckets_arns_allow != "" ? [1] : [] 
    content {
      sid = "AllowS3PutDeleteOperations"
      
      actions = [
        "s3:GetBucketLocation",
        "s3:PutObject*",
        "s3:DeleteObject*"
      ]
    
      resources = local.buckets_arns_allow      
    }
  }

  dynamic "statement" {
    for_each = var.team != "" ? [1] : []

    content {
      sid = "AllowS3BasiActionAreaObjects"
      actions = [
      "s3:PutObject",
      "s3:DeleteObject"
      ]
      resources = ["arn:aws:s3:::serasaexperian-da-datascience-data-ift-dev/${local.team_name}/*",
                 "arn:aws:s3:::serasaexperian-da-datascience-data-ift-dev/${local.team_name}"] 

    }
  }

}

resource "aws_iam_policy" "bucket_actions_allow" {
  name = replace("BUPolicyForS3AllowAccess${var.team}","_","")
  policy =  data.aws_iam_policy_document.bucket_actions_allow.json
  tags = merge(local.tags, var.user_role_tags)
}

data "aws_iam_policy_document" "bucket_actions_deny" {

  statement {
    sid = "DenyS3Buckets"
    effect = "Deny"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    
    resources =  local.buckets_arns_deny
                  
  }

  dynamic "statement" {
    for_each = var.team != "" ? [1] : []

    content {
      sid = "DenyS3ListAreaFolderObjects"
      effect = "Deny"
      actions = [
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject"
    ]
      resources =  local.buckets_prefix
    }
  }

}

resource "aws_iam_policy" "bucket_actions_deny" {
  name = replace("BUPolicyForS3DenyAccess${var.team}","_","")
  policy =  data.aws_iam_policy_document.bucket_actions_deny.json
  tags = merge(local.tags, var.user_role_tags)
}

resource "aws_iam_policy" "additional_user_policy" {
  count = var.additional_user_policy != "" ? 1 : 0
  name = replace("BUPolicyForCustomAccess${var.team}","_","")
  policy =  var.additional_user_policy
  tags = merge(local.tags, var.user_role_tags)
}


resource "aws_iam_policy" "user" {
  count = local.create_user_role_policy ? 1 : 0

  name        = var.user_role_use_name_prefix ? null : local.user_role_policy_name
  name_prefix = var.user_role_use_name_prefix ? "${local.user_role_policy_name}-" : null
  path        = var.user_role_path
  description = coalesce(var.user_role_description, "User role policy for EMR Studio ${var.name}")

  policy = data.aws_iam_policy_document.user[0].json

  tags = merge(local.tags, var.user_role_tags)
}

resource "aws_iam_role_policy_attachment" "user" {
  count = local.create_user_role && local.create_user_role_policy ? 1 : 0

  policy_arn = aws_iam_policy.user[0].arn
  role       = aws_iam_role.user[0].name
}

resource "aws_iam_role_policy_attachment" "bucket_actions_allow" {
  policy_arn = aws_iam_policy.bucket_actions_allow.arn
  role = aws_iam_role.user[0].name
}

resource "aws_iam_role_policy_attachment" "bucket_actions_deny" {
  policy_arn = aws_iam_policy.bucket_actions_deny.arn
  role = aws_iam_role.user[0].name
}

resource "aws_iam_role_policy_attachment" "additional_user_policy" {
  count = var.additional_user_policy != "" ? 1 : 0
  policy_arn = aws_iam_policy.additional_user_policy[0].arn
  role = aws_iam_role.user[0].name
}

################################################################################
# Engine Security Group
################################################################################

locals {
  create_security_groups = var.create && var.create_security_groups
  security_group_name    = try(coalesce(var.security_group_name, var.name), "")

  engine_security_group_name = "${local.security_group_name}-engine"
  engine_security_group_rules = { for k, v in merge(
    var.engine_security_group_rules,
    {
      workspace_ingress = {
        protocol                 = "tcp"
        from_port                = 18888
        to_port                  = 18888
        type                     = "ingress"
        description              = "Allow traffic from any resources in the Workspace security group for EMR Studio"
        source_security_group_id = try(aws_security_group.workspace[0].id, null)
      }
    },

  ) : k => v if local.create_security_groups }
}

resource "aws_security_group" "engine" {
  count = local.create_security_groups ? 1 : 0

  name        = var.security_group_use_name_prefix ? null : local.engine_security_group_name
  name_prefix = var.security_group_use_name_prefix ? "${local.engine_security_group_name}-" : null
  description = var.engine_security_group_description
  vpc_id      = data.aws_vpc.selected.id

  tags = merge(
    local.tags,
    var.security_group_tags,
    { "Name" = local.engine_security_group_name },
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "engine" {
  for_each = { for k, v in local.engine_security_group_rules : k => v if local.create_security_groups }

  # Required
  security_group_id = aws_security_group.engine[0].id
  protocol          = try(each.value.protocol, "tcp")
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  type              = try(each.value.type, "egress")

  # Optional
  description              = lookup(each.value, "description", null)
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  self                     = lookup(each.value, "self", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}

################################################################################
# Workspace Security Group
################################################################################

locals {
  workspace_security_group_name = "${local.security_group_name}-workspace"
  workspace_security_group_rules = { for k, v in merge(
    var.workspace_security_group_rules,
    {
      engine_egress = {
        protocol                 = "tcp"
        from_port                = 18888
        to_port                  = 18888
        description              = "Allow traffic to any resources in the Engine security group for EMR Studio"
        source_security_group_id = try(aws_security_group.engine[0].id, null)
      }
      https_egress = {
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
        description = "Allow traffic to the internet to link publicly hosted Git repositories to Workspaces"
        cidr_blocks = ["0.0.0.0/0"]
      }
    },

  ) : k => v if local.create_security_groups }
}

resource "aws_security_group" "workspace" {
  count = local.create_security_groups ? 1 : 0

  name        = var.security_group_use_name_prefix ? null : local.workspace_security_group_name
  name_prefix = var.security_group_use_name_prefix ? "${local.workspace_security_group_name}-" : null
  description = var.workspace_security_group_description
  vpc_id      = data.aws_vpc.selected.id

  tags = merge(
    local.tags,
    var.security_group_tags,
    { "Name" = local.workspace_security_group_name },
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "workspace" {
  for_each = { for k, v in local.workspace_security_group_rules : k => v if local.create_security_groups }

  # Required
  security_group_id = aws_security_group.workspace[0].id
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  type              = "egress"

  # Optional
  description              = lookup(each.value, "description", null)
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  self                     = lookup(each.value, "self", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}
