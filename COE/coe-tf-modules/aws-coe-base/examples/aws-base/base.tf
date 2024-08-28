module "aws_coe_base" {
  source                         = "git::https://code.experian.local/scm/esbt/coe-tf-modules.git//aws-coe-base?ref=aws-coe-base-CHECK-THE-LATEST-VERSION"
  application_name               = var.application_name
  project_name                   = var.project_name
  aws_region                     = var.aws_region
  env                            = var.env
  path_documentation_file        = path.module
  bu_name                        = "EITS"
  bucket_tf_state_end_name       = "tf-state"
  aws_security_group_description = "Allow 443 to endpoints"
  key_pair_create                = true
  tags                           = local.default_tags
  sub_domain                     = "${var.env}-${var.sub_domain}"
  aws_endpoints_urls_enabled     = false
  s3_logs_expiration_days        = var.s3_logs_expiration_days
  s3_logs_transition_days        = var.s3_logs_transition_days

}
