provider "aws" {
  access_key = "${var.access}"
  secret_key = "${var.secret}"
  region = "${var.region}"
  profile = "default"

}
#terraform {
# backend "s3" {
# encrypt = true
# bucket = "secdevops-terraform-prd-tfstates"
# region = "sa-east-1"
# key = "jenkins/@@OM@@.tfstate"
# access_key = "{{ s3_terraform_bucket_key_id_prd }}"
# secret_key = "{{ s3_terraform_bucket_access_key_prd }}"
# }
#} #}



module "s3_bucket" {
#     source                      = "git::https://code.experian.local/scm/scib/terraform-resources.git//aws/s3/s3_bucket_complete/"
    source                       = "terraform-aws-modules/s3-bucket/aws"
#    enabled                      = true
#    region                       = var.region
#    stage                        = var.stage
    bucket                        = var.name
    force_destroy                 = true
}
