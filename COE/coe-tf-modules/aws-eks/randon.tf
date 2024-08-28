resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "random_password" "oidc_argo_password" {
  length  = 64
  special = false
}

resource "random_password" "oidc_monitoring_password" {
  length  = 64
  special = false
}

