/**
 * # Experian RDS module example of use
 *
 * RDS MYSQL
 *
 * ## Install
 *
 * First you need change the 'bucket' name in the file 'backend-config/dev.tf' to reflect you environment
 *
 * Make the ajustment in the variables-dev.tfvars as well
 * 
 * ```bash
 * make init ENV=dev
 * make plan ENV=dev
 * ```
 *
 * Check if all changes are correct and apply the terraform
 *
 * ```bash
 * make apply ENV=dev
 * ``` 
 * 
 * You can use 'make install ENV=dev' to do all step above
 *
 * If you don't have the make installed in you machine your can use the 'terraform' command directly, you can check the correct command in the [Makefile](Makefile)
 *
 * ## Upgrade
 *
 * ```bash
 * make upgrade ENV=dev
 * ```
 * 
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
