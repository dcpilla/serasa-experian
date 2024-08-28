<!-- BEGIN_TF_DOCS -->
# AWS CoE Base

Install the default infrastructure on the AWS accounts

## Install

Make the ajustment in the variables-dev.tfvars

```bash
make first-run-init ENV=dev
make plan ENV=dev
```

Check if all changes are correct and apply the terraform

```bash
make apply ENV=dev
```

In the first time that you are running this script you need run the below command to migrate the TF state from your local machine to S3 bucket

```bash
make first-run-change-to-init-s3 ENV=dev
```

This will show the bellow messsage, just type yes and press enter

```
Initializing the backend...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "s3" backend. No existing state was found in the newly
  configured "s3" backend. Do you want to copy this state to the new "s3"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value:
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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | = 4.22.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_coe_base"></a> [aws\_coe\_base](#module\_aws\_coe\_base) | ../../ | n/a |

## Resources

No resources.

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
| <a name="output_s3_tf_state"></a> [s3\_tf\_state](#output\_s3\_tf\_state) | Name of S3 to store TF state |
<!-- END_TF_DOCS -->