/**
 * # AWS CoE Base 
 *
 * Install the default infrastructure on the AWS accounts
 *
 * ## Install
 *
 *
 * Make the ajustment in the variables-dev.tfvars
 * 
 * ```bash
 * make first-run-init ENV=dev
 * make plan ENV=dev
 * ```
 *
 * Check if all changes are correct and apply the terraform
 *
 * ```bash
 * make apply ENV=dev
 * ``` 
 * 
 * In the first time that you are running this script you need run the below command to migrate the TF state from your local machine to S3 bucket
 * 
 * ```bash
 * make first-run-change-to-init-s3 ENV=dev
 * ``` 
 *
 * This will show the bellow messsage, just type yes and press enter
 * 
 * ```
 * Initializing the backend...
 * Do you want to copy existing state to the new backend?
 *   Pre-existing state was found while migrating the previous "local" backend to the
 *   newly configured "s3" backend. No existing state was found in the newly
 *   configured "s3" backend. Do you want to copy this state to the new "s3"
 *   backend? Enter "yes" to copy and "no" to start with an empty state.
 * 
 *   Enter a value:
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
