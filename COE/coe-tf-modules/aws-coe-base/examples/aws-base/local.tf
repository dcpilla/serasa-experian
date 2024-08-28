locals {
  default_tags = {
    ManagedBy        = "Terraform"
    Application      = "${var.application_name}"
    Project          = "${var.project_name}"
    Environment      = "${var.env}"
    RepositoryURL    = "${data.git_remote.remote.urls[0]}"
    RepositoryPath   = "tf/${basename(path.cwd)}"
    CommitID         = "${data.git_commit.head_shortcut.sha1}"
    LanIDExecutor    = "${data.git_commit.head_shortcut.committer.email}"
    LastExcutionTime = "${data.git_commit.head_shortcut.committer.timestamp}"
  }
}
