locals {
  
  name   = var.team != "" ? "experian-emr-studio-${var.team}-${var.env}" : "experian-emr-studio-${var.env}"

  default_tags = var.team != "" ? {
    ManagedBy   = "Terraform"
    Application = "${var.application_name}"
    Project     = "${var.project_name}"
    Environment = "${var.env}"
    CostString = "${var.cost_string}"
    AppID = "${var.gearr_id}"
    Team        = "${var.team}"
    RepositoryURL  = "${data.git_remote.remote.urls[0]}"
    RepositoryPath = "tf/${basename(path.cwd)}"
  } : {
    ManagedBy   = "Terraform"
    Application = "${var.application_name}"
    Project     = "${var.project_name}"
    Environment = "${var.env}"
    CostString = "${var.cost_string}"
    AppID = "${var.gearr_id}"
    RepositoryURL  = "${data.git_remote.remote.urls[0]}"
    RepositoryPath = "tf/${basename(path.cwd)}"
  }

  default_mutables_tags = {
    CommitID         = "${data.git_commit.head_shortcut.sha1}"
    LanIDExecutor    = "${data.git_commit.head_shortcut.committer.email}"
    LastExcutionTime = "${data.git_commit.head_shortcut.committer.timestamp}"
  }

  data_cluster_workspace_metadata_tags = {
    Asset_Category  = var.emr_studio_bucket_category
    Data_Category   = "Metadata"
    Data_Type       = "NA"
    Asset_Category  = var.emr_studio_bucket_category
    Data_Category   = "Metadata"
    Data_Type       = "NA"
  }

  additional_user_policy = {
    prd = {}
    uat = {}
    dev = data.aws_iam_policy_document.additional_user_dev_policy.json
    sbx = {}
  }

  aws_emr_role_policy = {
    prd = {}
    uat = {}
    dev = data.aws_iam_policy_document.aws_emr_role_dev_policy.json
    sbx = {}
  }
}