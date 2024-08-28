module "aws_coe_base" {
  source                  = "git::https://code.experian.local/scm/esbt/coe-tf-modules.git//aws-coe-base?ref=aws-coe-base-CHECK-THE-LATEST-VERSION"
  application_name        = var.application_name
  project_name            = var.project_name
  aws_region              = var.aws_region
  env                     = var.env
  path_documentation_file = path.module
  bu_name                 = "EITS"
  tags                    = local.default_tags
}
