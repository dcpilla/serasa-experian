data "aws_caller_identity" "current" {}
## VPC
data "aws_vpc" "selected" {
  tags = {
    AWS_Solutions = "LandingZoneStackSet"
  }
}

data "aws_subnets" "experian" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    Network = var.emr-subnet
  }
}


data "aws_iam_policy" "eec_boundary_policy" {
  name = "BUAdminBasePolicy"
}

data "aws_iam_role" "role_admin" {
  name = "BUAdministratorAccessRole"
}

data "template_file" "cf-template-emr" {
  template = file("${path.module}/cf-templates/EMR_CloudFormation.yml")
  vars ={
    account_id = data.aws_caller_identity.current.account_id
    emr_job_flow_role_name = var.cluster_role_name
    vpd_id = data.aws_vpc.selected.id
    s3_emr_cluster_logs = var.s3_emr_cluster_logs
    env = var.env
    app_id = var.gearr_id
    cost_string = var.cost_string
    project_name = var.project_name
    allowed_instance_types = jsonencode(var.allowed_instance_types)
    allowed_applications = jsonencode(var.allowed_applications)
    emr_cluster_configurations =  jsonencode(var.emr_cluster_configurations)
    team = var.team
    fmt_team= lower(replace(var.team,"_","-"))
    bootstrap_script_path = "s3://${aws_s3_bucket.cloudformation_template_bucket.id}/${aws_s3_object.bootstrap_script_object.id}"
    maximum_capacity_unit = var.maximum_capacity_units
    maximum_core_capacity_units = var.maximum_core_capacity_units
    maximum_ondemand_capacity_units = var.maximum_ondemand_capacity_units
    minimum_capacity_units = var.minimum_capacity_units
  }
}

data "template_file" "bootstrap_script" {
  template = var.bootstrap_script_path != "" ? file("${var.bootstrap_script_path}") : "#!/bin/sh \n echo ----- No bootstrap actions ----- \n sudo yum list installed"
}
