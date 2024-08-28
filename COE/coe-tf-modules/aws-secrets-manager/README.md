<!-- BEGIN_TF_DOCS -->
# Experian RDS module example of use

## Examples

[Create a MYSQL Database](examples/mysql)

[Create a POSTGRES Database](examples/postgres)

![Image](docs/aws-rds.drawio.svg)
## Environment

- sandbox
- dev
- uat
- prod

## Storage Autoscaling

To enable Storage Autoscaling with instances that support the feature, define the db\_max\_allocated\_storage argument higher than the db\_allocated\_storage argument. Terraform will automatically hide differences with the db\_allocated\_storage argument value if autoscaling occurs.

To more information please visit: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance

```terraform
module "experian_rds" {
  source = "git::https://code.experian.local/scm/esbt/coe-tf-modules.git//aws-rds?ref=aws-rds-v1.0.0"
  # ... other configuration ...

  allocated_storage     = 50
  max_allocated_storage = 100
}
```

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

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | Name of the application that will cosume this Secrets Manager | `string` | `""` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"sa-east-1"` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | (Optional) Key-value map of user-defined tags that are attached to all reource created with this module. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(any)` | `{}` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment sandbox\|dev\|uat\|prod | `string` | `"Dev"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of project | `string` | `""` | no |
| <a name="input_sm_description"></a> [sm\_description](#input\_sm\_description) | (Optional) Description of the secret. | `string` | `""` | no |
| <a name="input_sm_force_overwrite_replica_secret"></a> [sm\_force\_overwrite\_replica\_secret](#input\_sm\_force\_overwrite\_replica\_secret) | (Optional) Accepts boolean value to specify whether to overwrite a secret with the same name in the destination Region. | `bool` | `false` | no |
| <a name="input_sm_kms_key_id"></a> [sm\_kms\_key\_id](#input\_sm\_kms\_key\_id) | (Optional) ARN or Id of the AWS KMS key to be used to encrypt the secret values in the versions stored in this secret. If you don't specify this value, then Secrets Manager defaults to using the AWS account's default KMS key (the one named aws/secretsmanager). If the default KMS key with that name doesn't yet exist, then AWS Secrets Manager creates it for you automatically the first time. | `string` | `null` | no |
| <a name="input_sm_name_prefix"></a> [sm\_name\_prefix](#input\_sm\_name\_prefix) | (Optional) Creates a unique name beginning with the specified prefix. Conflicts with name. | `string` | `null` | no |
| <a name="input_sm_policy"></a> [sm\_policy](#input\_sm\_policy) | (Optional) Valid JSON document representing a resource policy. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide. Removing policy from your configuration or setting policy to null or an empty string (i.e., policy = "") will not delete the policy since it could have been set by aws\_secretsmanager\_secret\_policy. | `string` | `null` | no |
| <a name="input_sm_recovery_window_in_days"></a> [sm\_recovery\_window\_in\_days](#input\_sm\_recovery\_window\_in\_days) | (Optional) Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. | `number` | `30` | no |
| <a name="input_sm_replica"></a> [sm\_replica](#input\_sm\_replica) | (Optional) Configuration block to support secret replication. | `string` | `null` | no |
| <a name="input_smv_secret_binary"></a> [smv\_secret\_binary](#input\_smv\_secret\_binary) | (Optional) Specifies binary data that you want to encrypt and store in this version of the secret. This is required if smv\_secret\_string is not set. Needs to be encoded to base64. | `string` | `null` | no |
| <a name="input_smv_secret_string"></a> [smv\_secret\_string](#input\_smv\_secret\_string) | (Optional) Specifies text data that you want to encrypt and store in this version of the secret. This is required if smv\_secret\_binary is not set. | `string` | `null` | no |
| <a name="input_smv_version_stages"></a> [smv\_version\_stages](#input\_smv\_version\_stages) | (Optional) Specifies a list of staging labels that are attached to this version of the secret. A staging label must be unique to a single version of the secret. If you specify a staging label that's already associated with a different version of the same secret then that staging label is automatically removed from the other version and attached to this version. If you do not specify a value, then AWS Secrets Manager automatically moves the staging label AWSCURRENT to this new version on creation. | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sm_arn"></a> [sm\_arn](#output\_sm\_arn) | ARN of the secret |
| <a name="output_sm_id"></a> [sm\_id](#output\_sm\_id) | ARN of the secret |
| <a name="output_sm_replica"></a> [sm\_replica](#output\_sm\_replica) | Replica Status |
| <a name="output_sm_rotation_enabled"></a> [sm\_rotation\_enabled](#output\_sm\_rotation\_enabled) | Whether automatic rotation is enabled for this secret. |
| <a name="output_smv_arn"></a> [smv\_arn](#output\_smv\_arn) | The ARN of the secret. |
| <a name="output_smv_id"></a> [smv\_id](#output\_smv\_id) | A pipe delimited combination of secret ID and version ID. |
| <a name="output_smv_version_id"></a> [smv\_version\_id](#output\_smv\_version\_id) | The unique identifier of the version of the secret. |
<!-- END_TF_DOCS -->