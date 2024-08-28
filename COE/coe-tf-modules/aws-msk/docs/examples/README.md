<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.40.0 |
| <a name="requirement_git"></a> [git](#requirement\_git) | 2023.2.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.40.0 |
| <a name="provider_git"></a> [git](#provider\_git) | 2023.2.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_coe-msk"></a> [coe-msk](#module\_coe-msk) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_kms_key.kafka](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [git_commit.head_shortcut](https://registry.terraform.io/providers/metio/git/2023.2.3/docs/data-sources/commit) | data source |
| [git_remote.remote](https://registry.terraform.io/providers/metio/git/2023.2.3/docs/data-sources/remote) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | Your application name | `string` | `"msk"` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment name | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The project name | `string` | `"data-platform"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region. | `string` | `"sa-east-1"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->