<!-- BEGIN_TF_DOCS -->
# Experian RDS module example of use

RDS POSTGRES

## Install

First you need change the 'bucket' name in the file 'backend-config/prod.tf' to reflect you environment

Make the ajustment in the variables-prod.tfvars as well

```bash
make init ENV=dev
make plan ENV=dev
```

Check if all changes are correct and apply the terraform

```bash
make apply ENV=dev
```

You can use 'make install ENV=dev' to do all step above

If you don't have the make installed in you machine your can use the 'terraform' command directly, you can check the correct command in the [Makefile](Makefile)

## Upgrade

```bash
make upgrade ENV=dev
```

## Environment

- sandbox
- dev
- uat
- prod

***NOTE***

For each environment that you create you should create two files
- First in the root path called variables-ENV.tfvars
- Second into the backend-config/ENV.tf

Take files already insides theses places as example to create your own

## Generate Documentation

```bash
make gen-doc
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.22.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.22.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.3.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_experian_rds"></a> [experian\_rds](#module\_experian\_rds) | git::https://code.experian.local/scm/esbt/coe-tf-modules.git//aws-rds | aws-rds-v1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.rds_secret](https://registry.terraform.io/providers/hashicorp/aws/4.22.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.sversion](https://registry.terraform.io/providers/hashicorp/aws/4.22.0/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.one](https://registry.terraform.io/providers/hashicorp/aws/4.22.0/docs/resources/security_group) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/4.22.0/docs/data-sources/caller_identity) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/4.22.0/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | application\_name | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"sa-east-1"` | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | `"Dev"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | project\_name | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_secretsmanager_secret_version_arn"></a> [aws\_secretsmanager\_secret\_version\_arn](#output\_aws\_secretsmanager\_secret\_version\_arn) | You can get the RDS password at this AWS Secret Manage ARN |
| <a name="output_rds_db_name"></a> [rds\_db\_name](#output\_rds\_db\_name) | The database name. |
| <a name="output_rds_endpoint"></a> [rds\_endpoint](#output\_rds\_endpoint) | The connection endpoint in address:port format. |
| <a name="output_rds_username"></a> [rds\_username](#output\_rds\_username) | The master username for the database. |
<!-- END_TF_DOCS -->