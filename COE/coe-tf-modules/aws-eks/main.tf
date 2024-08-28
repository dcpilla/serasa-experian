/**
 * # Serasa EKS Cluster
 *
 * EKS cluster
 *
 * Documentation in progress
 *
 * ## Install
 *
 * `Don't Panic!`
 * 
 * Errors may happen during this process, sometimes because of your internet connection issues, and other times due to the lack some information due to the timeout, but the most important here is Don't panic! you can see the doc [docs/common-errors.md](/docs/common-errors.md) where we put the common errors found.
 *
 * In the most case, you just need to run apply again and everything gone be alright
 * 
 * ```bash
 * make init ENV=dev
 * make plan ENV=dev
 * make apply ENV=dev
 * ```
 *
 * For experts 
 *
 * ```bash
 * make install ENV=dev
 * ```
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
 *
 * ## Testing
 *
 * ### Locally
 *
 * At `docs/examples/coe-default/coe-default` replace source source = "git::https://code.experian.local/scm/esbt/coe-tf-modules.git//aws-eks?ref=aws-eks-v0.0.13" by source = "../../../" 
 *
 * ```bash
 * make testing
 * ```
 * 
 * All files related to test are inside the `test` directory
 *
 * 
 * ### Harness Pipeline
 *
 * You can use the Harness Pipeline [Validacao AMI](https://app.harness.io/ng/account/04Iq9MDcT9WOBwwS6C4oKw/ci/orgs/BRSREMLOPS/projects/Operations/pipelines/teste_AMI/pipeline-studio/?repoName=cdeamlo%2Fcoe-odin-infra.git&connectorRef=account.Global_Bitbucket_SSH&storeType=REMOTE) in the `Operations` project.
 *
 *
 * ## Common erros
 *
 * [docs/common-errors.md](/docs/common-errors.md) 
 *
 * The bucket that stores EKS logs has the following lifetime policy:
 *   - Glacier after 20 days
 *   - Delete after 1 year
 * 
 *
 *
 */
 