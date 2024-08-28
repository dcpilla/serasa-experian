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
| [aws_db_instance.rds_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.rds_db_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_iam_policy.db-palantir-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.db-palantir-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.db-palantir-attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.rds_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy.eec_boundary_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_kms_alias.kms_rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_alias) | data source |
| [aws_subnets.subnets_rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_id"></a> [app\_id](#input\_app\_id) | The new Experian standard cloud resources tag “AppID” (also known as a GEARR “App ID” ) is a unique global identification number assigned to each business application registered in APM. Ex.: 12345 | `string` | n/a | yes |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | Name of the application that will cosume this Database | `string` | `""` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"sa-east-1"` | no |
| <a name="input_bu"></a> [bu](#input\_bu) | BU name ex. CS/CI, CS/BI, DA, PME, ECS, eI, M, Datalab, Agro, Data Strategy, Finanças, Vendas, TI, Jurídico, Marketing | `string` | n/a | yes |
| <a name="input_category_asset"></a> [category\_asset](#input\_category\_asset) | Asset category for data hosted in this RDS, options are: Model Developing, Logs , Cache , Metadata, Backup, N/A | `string` | n/a | yes |
| <a name="input_category_data"></a> [category\_data](#input\_category\_data) | Data category,options are: Register, Behavioral, Negative, Positive, Transactional, Finance, N/D | `string` | n/a | yes |
| <a name="input_cost_string"></a> [cost\_string](#input\_cost\_string) | This value can be used for tag-based cost reports, budgets, cost-tracking, etc.. Please consult with the finance contact for your Cost String to see if tag based cost reporting is being used. Ex.: 1111.CC.222.3333333 | `string` | n/a | yes |
| <a name="input_db_allocated_storage"></a> [db\_allocated\_storage](#input\_db\_allocated\_storage) | When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance. Configuring this will automatically ignore differences to allocated\_storage. Must be greater than or equal to allocated\_storage or 0 to disable Storage Autoscaling | `number` | n/a | yes |
| <a name="input_db_allow_major_version_upgrade"></a> [db\_allow\_major\_version\_upgrade](#input\_db\_allow\_major\_version\_upgrade) | Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible. | `bool` | `false` | no |
| <a name="input_db_apply_immediately"></a> [db\_apply\_immediately](#input\_db\_apply\_immediately) | Specifies whether any database modifications are applied immediately, or during the next maintenance window | `bool` | `true` | no |
| <a name="input_db_auto_minor_version_upgrade"></a> [db\_auto\_minor\_version\_upgrade](#input\_db\_auto\_minor\_version\_upgrade) | Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window | `bool` | `true` | no |
| <a name="input_db_availability_zone"></a> [db\_availability\_zone](#input\_db\_availability\_zone) | The AZ for the RDS instance | `string` | `""` | no |
| <a name="input_db_backup_retention_period"></a> [db\_backup\_retention\_period](#input\_db\_backup\_retention\_period) | The days to retain backups for. Must be between 0 and 35. Must be greater than 0 if the database is used as a source for a Read Replica | `number` | `0` | no |
| <a name="input_db_backup_window"></a> [db\_backup\_window](#input\_db\_backup\_window) | n/a | `string` | `"The daily time range (in UTC) during which automated backups are created if they are enabled. Example: 09:46-10:16. Must not overlap with maintenance_window."` | no |
| <a name="input_db_deletion_protection"></a> [db\_deletion\_protection](#input\_db\_deletion\_protection) | If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to true | `bool` | `false` | no |
| <a name="input_db_engine"></a> [db\_engine](#input\_db\_engine) | The database engine to use. For supported values, see the Engine parameter in API action CreateDBInstance. Cannot be specified for a replica. Note that for Amazon Aurora instances the engine must match the DB cluster's engine'. | `string` | n/a | yes |
| <a name="input_db_engine_version"></a> [db\_engine\_version](#input\_db\_engine\_version) | The engine version to use. If auto\_minor\_version\_upgrade is enabled, you can provide a prefix of the version such as 5.7 (for 5.7.10). The actual engine version used is returned in the attribute engine\_version\_actual | `string` | n/a | yes |
| <a name="input_db_iam_database_authentication_enabled"></a> [db\_iam\_database\_authentication\_enabled](#input\_db\_iam\_database\_authentication\_enabled) | Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled. | `bool` | `true` | no |
| <a name="input_db_instance_class"></a> [db\_instance\_class](#input\_db\_instance\_class) | The RDS instance class. | `string` | n/a | yes |
| <a name="input_db_iops"></a> [db\_iops](#input\_db\_iops) | The amount of provisioned IOPS. Setting this implies a storage\_type of io1. | `number` | `0` | no |
| <a name="input_db_maintenance_window"></a> [db\_maintenance\_window](#input\_db\_maintenance\_window) | The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00' | `string` | `""` | no |
| <a name="input_db_max_allocated_storage"></a> [db\_max\_allocated\_storage](#input\_db\_max\_allocated\_storage) | When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance. Configuring this will automatically ignore differences to allocated\_storage. Must be greater than or equal to allocated\_storage or 0 to disable Storage Autoscaling | `number` | `0` | no |
| <a name="input_db_monitoring_interval"></a> [db\_monitoring\_interval](#input\_db\_monitoring\_interval) | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60. | `number` | `0` | no |
| <a name="input_db_multi_az"></a> [db\_multi\_az](#input\_db\_multi\_az) | Specifies if the RDS instance is multi-AZ | `bool` | `false` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | The database name. | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file | `string` | n/a | yes |
| <a name="input_db_performance_insights_enabled"></a> [db\_performance\_insights\_enabled](#input\_db\_performance\_insights\_enabled) | Specifies whether Performance Insights are enabled. | `bool` | `false` | no |
| <a name="input_db_performance_insights_kms_key_id"></a> [db\_performance\_insights\_kms\_key\_id](#input\_db\_performance\_insights\_kms\_key\_id) | The ARN for the KMS key to encrypt Performance Insights data. When specifying db\_performance\_insights\_kms\_key\_id, db\_performance\_insights\_enabled needs to be set to true. Once KMS key is set, it can never be changed. | `string` | `""` | no |
| <a name="input_db_performance_insights_retention_period"></a> [db\_performance\_insights\_retention\_period](#input\_db\_performance\_insights\_retention\_period) | The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years). When specifying db\_performance\_insights\_retention\_period, db\_performance\_insights\_enabled needs to be set to true | `number` | `0` | no |
| <a name="input_db_port"></a> [db\_port](#input\_db\_port) | The port on which the DB accepts connections. | `number` | n/a | yes |
| <a name="input_db_security_group_ids"></a> [db\_security\_group\_ids](#input\_db\_security\_group\_ids) | Id of de Security Group to be associate to new RDS | `list(any)` | n/a | yes |
| <a name="input_db_skip_final_snapshot"></a> [db\_skip\_final\_snapshot](#input\_db\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final\_snapshot\_identifier | `bool` | `true` | no |
| <a name="input_db_storage_type"></a> [db\_storage\_type](#input\_db\_storage\_type) | One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'gp2' if not. | `string` | `"gp2"` | no |
| <a name="input_db_tags"></a> [db\_tags](#input\_db\_tags) | A map of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Username for the master DB user. Cannot be specified for a replica. | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment sbx\|dev\|tst\|uat\|stg\|prd | `string` | `"dev"` | no |
| <a name="input_kms_alias"></a> [kms\_alias](#input\_kms\_alias) | KMS alias to be used by RDS. By default this module will create new KMS for used if you let this values to blank | `string` | `""` | no |
| <a name="input_kms_deletion_window_in_days"></a> [kms\_deletion\_window\_in\_days](#input\_kms\_deletion\_window\_in\_days) | The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive. If you do not specify a value, it defaults to 30. If the KMS key is a multi-Region primary key with replicas, the waiting period begins when the last of its replica keys is deleted. Otherwise, the waiting period begins immediately. | `string` | `"10"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of project | `string` | `""` | no |
| <a name="input_type_data"></a> [type\_data](#input\_type\_data) | Type of the data, options are: PP (physical person), LP (legal person), PP/LP, N/D | `string` | n/a | yes |
| <a name="input_vpc_tag_for_select"></a> [vpc\_tag\_for\_select](#input\_vpc\_tag\_for\_select) | Tag for select the VPC | `map(string)` | <pre>{<br>  "AWS_Solutions": "LandingZoneStackSet"<br>}</pre> | no |
| <a name="input_vpc_tag_for_select_subnets"></a> [vpc\_tag\_for\_select\_subnets](#input\_vpc\_tag\_for\_select\_subnets) | Tag for select the Subnets | `map(string)` | <pre>{<br>  "Network": "Private"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_rds_arn"></a> [kms\_rds\_arn](#output\_kms\_rds\_arn) | The Amazon Resource Name (ARN) of the key. |
| <a name="output_palantir_informations"></a> [palantir\_informations](#output\_palantir\_informations) | Palantir Information |
| <a name="output_palantir_postgres_query"></a> [palantir\_postgres\_query](#output\_palantir\_postgres\_query) | Palantir Query to create Palantir user |
| <a name="output_rds_address"></a> [rds\_address](#output\_rds\_address) | The hostname of the RDS instance. See also endpoint and port. |
| <a name="output_rds_allocated_storage"></a> [rds\_allocated\_storage](#output\_rds\_allocated\_storage) | The amount of allocated storage. |
| <a name="output_rds_arn"></a> [rds\_arn](#output\_rds\_arn) | The ARN of the RDS instance. |
| <a name="output_rds_availability_zone"></a> [rds\_availability\_zone](#output\_rds\_availability\_zone) | The availability zone of the instance. |
| <a name="output_rds_backup_retention_period"></a> [rds\_backup\_retention\_period](#output\_rds\_backup\_retention\_period) | The backup retention period. |
| <a name="output_rds_backup_window"></a> [rds\_backup\_window](#output\_rds\_backup\_window) | The backup window. |
| <a name="output_rds_ca_cert_identifier"></a> [rds\_ca\_cert\_identifier](#output\_rds\_ca\_cert\_identifier) | Specifies the identifier of the CA certificate for the DB instance. |
| <a name="output_rds_character_set_name"></a> [rds\_character\_set\_name](#output\_rds\_character\_set\_name) | The character set (collation) used on Oracle and Microsoft SQL instances. |
| <a name="output_rds_db_name"></a> [rds\_db\_name](#output\_rds\_db\_name) | The database name. |
| <a name="output_rds_domain"></a> [rds\_domain](#output\_rds\_domain) | The ID of the Directory Service Active Directory domain the instance is joined to |
| <a name="output_rds_domain_iam_role_name"></a> [rds\_domain\_iam\_role\_name](#output\_rds\_domain\_iam\_role\_name) | The name of the IAM role to be used when making API calls to the Directory Service. |
| <a name="output_rds_endpoint"></a> [rds\_endpoint](#output\_rds\_endpoint) | The connection endpoint in address:port format. |
| <a name="output_rds_engine"></a> [rds\_engine](#output\_rds\_engine) | The database engine. |
| <a name="output_rds_engine_version_actual"></a> [rds\_engine\_version\_actual](#output\_rds\_engine\_version\_actual) | The running version of the database. |
| <a name="output_rds_hosted_zone_id"></a> [rds\_hosted\_zone\_id](#output\_rds\_hosted\_zone\_id) | The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record). |
| <a name="output_rds_id"></a> [rds\_id](#output\_rds\_id) | The RDS instance ID. |
| <a name="output_rds_instance_class"></a> [rds\_instance\_class](#output\_rds\_instance\_class) | The RDS instance class. |
| <a name="output_rds_latest_restorable_time"></a> [rds\_latest\_restorable\_time](#output\_rds\_latest\_restorable\_time) | The latest time, in UTC RFC3339 format, to which a database can be restored with point |
| <a name="output_rds_maintenance_window"></a> [rds\_maintenance\_window](#output\_rds\_maintenance\_window) | The instance maintenance window. |
| <a name="output_rds_multi_az"></a> [rds\_multi\_az](#output\_rds\_multi\_az) | If the RDS instance is multi AZ enabled. |
| <a name="output_rds_name"></a> [rds\_name](#output\_rds\_name) | The database name. |
| <a name="output_rds_port"></a> [rds\_port](#output\_rds\_port) | The database port. |
| <a name="output_rds_resource_id"></a> [rds\_resource\_id](#output\_rds\_resource\_id) | The RDS Resource ID of this instance. |
| <a name="output_rds_status"></a> [rds\_status](#output\_rds\_status) | The RDS instance status. |
| <a name="output_rds_storage_encrypted"></a> [rds\_storage\_encrypted](#output\_rds\_storage\_encrypted) | Specifies whether the DB instance is encrypted. |
| <a name="output_rds_tags_all"></a> [rds\_tags\_all](#output\_rds\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. |
| <a name="output_rds_username"></a> [rds\_username](#output\_rds\_username) | The master username for the database. |
<!-- END_TF_DOCS -->