/**
 * EXAMPLE OF USE NOT MAINTAINED, 
 *
 * `Since we are no longer using Kubeflow, no future updates will be made in this example`
 *
 *
 * # Experian EKS module example of use 
 *
 * EKS
 *
 * ![Image](docs/Kubeflow.drawio.svg)
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
 *
 * ## Install Kubeflow
 *
 * See the instructions in this repo:  https://code.experian.local/projects/CDEAMLO/repos/k8s-infrastructure/browse/kustomize/kubeflow?at=refs%2Ftags%2Fkubeflow-v1.4.1-r0.5
 *
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
