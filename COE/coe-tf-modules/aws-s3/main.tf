/**
 * # AWS CoE Base 
 *
 * Install the default infrastructure on the AWS accounts
 *
 * * ## Examples
 *
 * [AWS Base](examples/aws-base)
 * 
 * ![Image](docs/aws-coe-base.drawio.svg)
 * ## Environment
 *
 * - sandbox
 * - dev
 * - uat
 * - prod
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
