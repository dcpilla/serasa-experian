/**
 * # Experian RDS module example of use
 *
 * ## Examples
 *
 * [Create a MYSQL Database](examples/mysql)
 * 
 * [Create a POSTGRES Database](examples/postgres)
 *
 *
 * ![Image](docs/aws-rds.drawio.svg)
 * ## Environment
 *
 * - sandbox
 * - dev
 * - uat
 * - prod
 * 
 * 
 * ## Storage Autoscaling
 * 
 * To enable Storage Autoscaling with instances that support the feature, define the db_max_allocated_storage argument higher than the db_allocated_storage argument. Terraform will automatically hide differences with the db_allocated_storage argument value if autoscaling occurs.
 * 
 * To more information please visit: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
 * 
 * ```terraform
 * module "experian_rds" {
 *   source = "git::https://code.experian.local/scm/esbt/coe-tf-modules.git//aws-rds?ref=aws-rds-v1.0.0"
 *   # ... other configuration ...
 * 
 *   allocated_storage     = 50
 *   max_allocated_storage = 100
 * }
 * ```
 * 
 * ***NOTE***
 *
 * For each environment that you create you should create two files
 * - First in the root path called variables-ENV.tfvars
 * - Second into the backend-config/ENV.tf
 *
 * Take files already insides theses places as example to create your own
 *
 * ## Generate Documentation
 *
 * ```bash
 * make gen-doc
 * ```
 *
 */
