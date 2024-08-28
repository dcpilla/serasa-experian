################################################################################
# EMR Studio
################################################################################

module "emr_studio_iam" {
  source = "git::https://code.experian.local/scm/esbt/coe-tf-modules.git//emr-studio?ref=aws-emr-studio-v0.0.1"

  name                               = "${local.name}-iam"
  auth_mode                          = "IAM"
  default_s3_location                = "s3://${aws_s3_bucket.app_bucket_studio-workspace.id}/workspace"
  s3_emr_cluster_logs                = aws_s3_bucket.app_bucket_studio-workspace.id
  s3_cfn_template                    = var.team != "" ? replace(lower("serasaexperian-${var.project_name}-cfn-tmpl-${var.team}-${var.env}"), "_", "-") : replace(lower("serasaexperian-${var.project_name}-cfn-tmpl-${var.env}"), "_", "-")
  tags                               = merge(local.default_tags, local.default_mutables_tags)
  security_group_name                = var.project_name
  service_role_name                  = "BURoleForEMRStudioServiceRole"
  service_role_policy_name           = "BUPolicyForEMRStudioServiceRole"
  project_name                       = var.project_name
  team                               = var.team
  buckets_name_allow_emr_studio_role = var.buckets_name_allow_emr_studio_role
  buckets_name_deny_emr_studio_role  = var.buckets_name_deny_emr_studio_role
  team_list                          = var.team_list
  maximum_capacity_units             = var.maximum_capacity_units
  maximum_core_capacity_units        = var.maximum_core_capacity_units
  maximum_ondemand_capacity_units    = var.maximum_ondemand_capacity_units
  minimum_capacity_units             = var.minimum_capacity_units
  allowed_applications               = var.allowed_applications
  emr_cluster_configurations         = var.emr_cluster_configurations
  allowed_instance_types             = var.allowed_instance_types
  bootstrap_script_path              = var.bootstrap_script_path != "" ? "${path.cwd}/${var.bootstrap_script_path}" : ""
  emr-subnet                         = var.emr-subnet

  #Role that will be used for Data Engineers needs to create AD Group to be accessed
  user_role_name         = replace("BURoleForDataEngineer${var.team}", "_", "")
  user_role_policy_name  = "BUPolicyForEMRStudioUserRole"
  additional_user_policy = var.additional_user_policy_control == true ? local.additional_user_policy[var.env] : ""
  service_role_tags      = var.team != "" ? { Team = "${var.team}" } : {}
  gearr_id               = var.AppID
  cluster_role_name      = aws_iam_role.BURoleForEMR.name
  cost_string            = var.cost_string
}

