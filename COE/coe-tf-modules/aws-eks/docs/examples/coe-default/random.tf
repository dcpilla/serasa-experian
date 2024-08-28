resource "random_password" "oidc_argo_password" {
  length  = 64
  special = false
}
