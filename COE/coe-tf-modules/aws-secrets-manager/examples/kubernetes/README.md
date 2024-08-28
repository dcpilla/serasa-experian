<!-- BEGIN_TF_DOCS -->
# Experian Secrets Manager module example of use

Secrets Manager with Kubernetes integration

## Install

First you need change the 'bucket' name in the file 'backend-config/dev.tf' to reflect you environment

Make the ajustment in the variables-dev.tfvars as well

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
| <a name="module_experian_sm"></a> [experian\_sm](#module\_experian\_sm) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/4.22.0/docs/data-sources/caller_identity) | data source |

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
| <a name="output_sm_arn"></a> [sm\_arn](#output\_sm\_arn) | ARN of the secret |
<!-- END_TF_DOCS -->