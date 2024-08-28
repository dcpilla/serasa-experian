data "aws_caller_identity" "current" {}


resource "random_password" "password" {
  length  = 16
  special = false
}

module "experian_sm" {
  source = "../../"

  sm_description    = "Description Example"
  application_name  = var.application_name
  smv_secret_string = <<EOF
  {
    "username": "teste",
    "password": "${random_password.password.result}"
   }
  EOF
}
