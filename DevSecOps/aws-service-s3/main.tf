provider "aws" {
  access_key = "${var.access}"
  secret_key = "${var.secret}"
  region = "${var.region}"
  profile = "default"

}
{# terraform {
 backend "s3" {
 encrypt = true
 bucket = "secdevops-terraform-prd-tfstates"
 region = "sa-east-1"
 key = "jenkins/@@OM@@.tfstate"
 access_key = "{{ s3_terraform_bucket_key_id_prd }}"
 secret_key = "{{ s3_terraform_bucket_access_key_prd }}"
 }
} #}



module "s3_bucket" {
{#     source                      = "git::https://code.experian.local/scm/scib/terraform-resources.git//aws/s3/s3_bucket_complete/" #}
    source                       = terraform-aws-modules/s3-bucket/aws
    version                      = 4.2.1
    enabled                      = true
    region                       = var.region
    stage                        = var.stage
    name                         = var.name
    acl                          = var.acl
    force_destroy                = var.force_destroy
    versioning_enabled           = var.versioning_enabled
    allow_encrypted_uploads_only = var.allow_encrypted_uploads_only
    allowed_bucket_actions       = var.allowed_bucket_actions
}
