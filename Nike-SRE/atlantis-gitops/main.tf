module "ecr_atlantis" {
  source = "git::https://code.experian.local/scm/nikesre/terraform-ecr.git?ref=v1.0.1"

  env                  = local.common_tags.Environment
  name                 = "atlantis"
  policy               = file("policy.json")
  ecr_scanning_enabled = true
  scan_rules = [
    {
      scan_frequency = "SCAN_ON_PUSH"
      filters = [
        {
          filter = "atlantis"
        }
      ]
    }
  ]
}

resource "docker_registry_image" "this" {
  name          = docker_image.this.name
  keep_remotely = true
}

resource "docker_image" "this" {
  name = "${module.ecr_atlantis.ecr_repository_url}:chainguard"
  build {
    context = "${path.cwd}/dockerfile/"
  }
}

module "atlantis_bitbucket_webhook_secret" {
  source = "git::https://code.experian.local/scm/nikesre/terraform-secrets-manager.git?ref=v1.0.5"

  env           = local.common_tags.Environment
  name          = "atlantis_bitbucket_webhook_secret"
  secret_string = var.atlantis_bitbucket_webhook_secret
  role_arns     = ["arn:aws:iam::564593125549:role/ReadOnlyAccessRole"]
}

module "bitbucket_token" {
  source = "git::https://code.experian.local/scm/nikesre/terraform-secrets-manager.git?ref=v1.0.5"
  env           = local.common_tags.Environment
  name          = "bitbucket_token"
  secret_string = var.bitbucket_token
  role_arns     = ["arn:aws:iam::564593125549:role/ReadOnlyAccessRole"]
}
#
#module "ecs_atlantis" {
#  source     = "git::https://code.experian.local/scm/nikesre/terraform-ecs.git"
#  task_image = docker_image.this.name
#  tags       = local.common_tags
#  ecs_cluster_name = "atlantis02"
#  container_port = 4141
#  service_num = 1
#  environment = [
#    {
#      name  = "ATLANTIS_PORT"
#      value = "4141"
#    },
#    {
#      name  = "ATLANTIS_API_SECRET"
#      valeu = "secret"
#    },
#    {
#      name  = "ATLANTIS_ATLANTIS_URL"
#      value = "http://atlantis.nike-sre.br.experian.eeca"
#    },
#    {
#      name  = "ATLANTIS_REPO_ALLOWLIST"
#      value = "code.experian.local/EITS nikesre/atlantis-*,code.experian.local/EITS nikesre/iac-*"
#    },
#    {
#      name  = "ATLANTIS_BITBUCKET_BASE_URL"
#      value = "https://code.experian.local"
#    },
#    {
#      name  = "ATLANTIS_BITBUCKET_USER"
#      value = "c11824q"
#    },
#    {
#      name      = "ATLANTIS_BITBUCKET_WEBHOOK_SECRET"
#      value = "module.atlantis_bitbucket_webhook_secret.secretsmanager_secret_arn"
#    },
#    {
#      name      = "ATLANTIS_BITBUCKET_TOKEN"
#      value = "module.bitbucket_token.secretsmanager_secret_arn"
#    },
#    {
#      name  = "ATLANTIS_REPO_CONFIG_JSON"
#      value = jsonencode(yamldecode(file("${path.module}/config/repos.yaml")))
#    },
#    {
#      name  = "ATLANTIS_DATA_DIR"
#      value = "/home/atlantis/data"
#    },
#    {
#      name  = "ATLANTIS_CONFIG"
#      value = "/config/atlantis.yaml"
#    },
#    {
#      name  = "ATLANTIS_CHECKOUT_STRATEGY"
#      value = "merge"
#    },
#    {
#      name  = "ATLANTIS_CHECKOUT_DEPTH"
#      value = "0"
#    },
#    {
#      name  = "ATLANTIS_AUTOMERGE"
#      value = "true"
#    },
#  ]
#}
