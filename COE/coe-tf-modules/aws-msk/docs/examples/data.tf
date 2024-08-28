# get GIT URL
data "git_remote" "remote" {
  directory = "../../../../"
  name      = "origin"
}

# get commit by parent
data "git_commit" "head_shortcut" {
  directory = "../../../../"
  revision  = "@"
}
