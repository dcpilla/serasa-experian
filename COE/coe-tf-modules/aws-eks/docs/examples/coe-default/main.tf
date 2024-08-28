/**
 * # Experian Odin EKS
 *
 * ODIN EKS
 *
 * ![Image](docs/odin.drawio.svg)
 *
 * ## Install
 *
 * `Don't Panic!`
 * 
 * Errors may happen during this process, sometimes because of your internet connection issues, and other times due to the lack some information due to the timeout, but the most important here is Don't panic! you can see the doc [docs/common-errors.md](../common-errors.md) where we put the common errors found.
 *
 * In the most case, you just need to run apply again and everything gone be alright
 *
 * OK go on, first you need change the 'bucket' name in the file 'backend-config/dev.tf' to reflect you environment
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
 *## Install Feature Proxy no AWS NLB
* Add the boolean variable istio_ingress_nlb_proxy_enabled to enable or disable the Proxy feature in NLB in variables.tf
* Add the annotation: "service.beta.kubernetes.io/aws-load-balancer-proxy-protocol" in  helm.tf 
* Envoy filter created in kubect.tf
 */
