<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.40.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.40.0 |
| <a name="provider_git"></a> [git](#provider\_git) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.kafka_broker_scaling_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.kafka_storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_kms_alias.msk_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.encryption_at_rest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_msk_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster) | resource |
| [aws_msk_configuration.kafka](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_configuration) | resource |
| [aws_msk_scram_secret_association.kafka_scram_secret_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_scram_secret_association) | resource |
| [aws_security_group.msk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_kms_key.kafka](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_subnet.eec_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.experian](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [git_commit.head_shortcut](https://registry.terraform.io/providers/hashicorp/git/latest/docs/data-sources/commit) | data source |
| [git_remote.remote](https://registry.terraform.io/providers/hashicorp/git/latest/docs/data-sources/remote) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_ports"></a> [allowed\_ports](#input\_allowed\_ports) | A map of port numbers to allow on the cluster. If authentication is enabled this variable must be passed with the appropriate port numbers - Brokers = 9092 (plaintext), 9094 (TLS), 9096 (SASL/SCRAM), 9098 (IAM). Zookeeper = 2181 (plaintext), 2182 (TLS) | `map(number)` | <pre>{<br>  "plain": 9092,<br>  "tls": 9094,<br>  "zookeeper": 2181<br>}</pre> | no |
| <a name="input_certificate_authority_arns"></a> [certificate\_authority\_arns](#input\_certificate\_authority\_arns) | List of ACM Certificate Authority Amazon Resource Names (ARNs) to be used for TLS client authentication | `list(string)` | `[]` | no |
| <a name="input_client_broker_encryption"></a> [client\_broker\_encryption](#input\_client\_broker\_encryption) | n/a | `string` | `"TLS_PLAINTEXT"` | no |
| <a name="input_client_sasl_iam_enabled"></a> [client\_sasl\_iam\_enabled](#input\_client\_sasl\_iam\_enabled) | Enables client authentication via IAM policies (cannot be set to `true` at the same time as `client_sasl_scram_enabled`). | `bool` | `false` | no |
| <a name="input_client_sasl_scram_enabled"></a> [client\_sasl\_scram\_enabled](#input\_client\_sasl\_scram\_enabled) | Enables SCRAM client authentication via AWS Secrets Manager (cannot be set to `true` at the same time as `client_tls_auth_enabled`). | `bool` | `false` | no |
| <a name="input_client_sasl_scram_secret_association_arns"></a> [client\_sasl\_scram\_secret\_association\_arns](#input\_client\_sasl\_scram\_secret\_association\_arns) | List of AWS Secrets Manager secret ARNs for scram authentication. | `list(string)` | `[]` | no |
| <a name="input_client_tls_auth_enabled"></a> [client\_tls\_auth\_enabled](#input\_client\_tls\_auth\_enabled) | Set `true` to enable the Client TLS Authentication | `bool` | `false` | no |
| <a name="input_config"></a> [config](#input\_config) | MSK cluster configuration, see Kafka server properties for valid options | `string` | `""` | no |
| <a name="input_config_version"></a> [config\_version](#input\_config\_version) | Bump this each time you modify the config or cluster version | `string` | `"1"` | no |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Set to true to create a KMS key for this cluster | `bool` | `false` | no |
| <a name="input_ebs_volume_size"></a> [ebs\_volume\_size](#input\_ebs\_volume\_size) | n/a | `any` | n/a | yes |
| <a name="input_enable_cloudwatch_log_delivery"></a> [enable\_cloudwatch\_log\_delivery](#input\_enable\_cloudwatch\_log\_delivery) | Set to true to enable log delivery to CloudWatch | `bool` | `false` | no |
| <a name="input_enable_storage_autoscaling"></a> [enable\_storage\_autoscaling](#input\_enable\_storage\_autoscaling) | Set to true to enable storage autoscaling | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of this environment / AWS account.  Corresponds to top-level directories in this repo. | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `any` | n/a | yes |
| <a name="input_kafka_version"></a> [kafka\_version](#input\_kafka\_version) | n/a | `any` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | MSK / Kafka vars | `any` | n/a | yes |
| <a name="input_number_of_brokers"></a> [number\_of\_brokers](#input\_number\_of\_brokers) | n/a | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region. | `string` | `"sa-east-1"` | no |
| <a name="input_scaling_max_capacity"></a> [scaling\_max\_capacity](#input\_scaling\_max\_capacity) | Max allowed capacity in GiB of EBS Volume. This can be set up to 16 TiB per broker. | `number` | `5000` | no |
| <a name="input_scaling_target_value"></a> [scaling\_target\_value](#input\_scaling\_target\_value) | Target value in percent for KafkaBrokerStorageUtilization metric to trigger storage scaling | `number` | `60` | no |
| <a name="input_storage_mode"></a> [storage\_mode](#input\_storage\_mode) | Set broker storage to be LOCAL or TIERED, requires kafka\_version to have the .tiered suffix | `string` | `"LOCAL"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_bootstrap_brokers"></a> [bootstrap\_brokers](#output\_bootstrap\_brokers) | Plaintext connection host:port pairs for brokers |
| <a name="output_bootstrap_brokers_sasl_iam"></a> [bootstrap\_brokers\_sasl\_iam](#output\_bootstrap\_brokers\_sasl\_iam) | IAM connection host:port pairs for brokers |
| <a name="output_bootstrap_brokers_sasl_scram"></a> [bootstrap\_brokers\_sasl\_scram](#output\_bootstrap\_brokers\_sasl\_scram) | SCRAM connection host:port pairs for brokers |
| <a name="output_bootstrap_brokers_tls"></a> [bootstrap\_brokers\_tls](#output\_bootstrap\_brokers\_tls) | TLS connection host:port pairs for brokers |
| <a name="output_current_version"></a> [current\_version](#output\_current\_version) | n/a |
| <a name="output_zookeeper_connect_string"></a> [zookeeper\_connect\_string](#output\_zookeeper\_connect\_string) | Plaintext connection host:port pairs for zookeeper |
| <a name="output_zookeeper_connect_string_tls"></a> [zookeeper\_connect\_string\_tls](#output\_zookeeper\_connect\_string\_tls) | TLS connection host:port pairs for zookeeper |
<!-- END_TF_DOCS -->