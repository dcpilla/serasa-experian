<!-- BEGIN_TF_DOCS -->
# Coe TF Argocd

Install Argocd in their component

```hcl
module "coe-argocd" {
 source = "./modules/coe-tf-argocd"

 env                               = var.env
 eks_cluster_name                  = var.eks_cluster_name
 project_name                      = var.project_name
 external_dns_domain               = var.external_dns_domain_filters[0]
 tags                              = local.default_tags
 oidc_provider_arn                 = module.eks.oidc_provider_arn
 auth_system_ldap_password         = var.auth_system_ldap_password
 eks_cluster_id                    = module.eks.cluster_id
 git_repository_url                = var.coe_argocd_git_repository_url
 git_repository_path               = var.coe_argocd_git_repository_path
 global_ssh_git_repository_url     = var.coe_argocd_global_ssh_git_repository_url
 git_repository_branch             = var.coe_argocd_git_repository_branch
 eks_namespace                     = var.coe_argocd_eks_namespace
 helm_version                      = var.coe_argocd_helm_version
 eks_cluster_ad_group_access_admin = var.eks_cluster_ad_group_access_admin
 eks_cluster_ad_group_access_view  = var.eks_cluster_ad_group_access_view
 resources_aws_account             = var.resources_aws_account
 oidc_dex_secret                   = random_password.oidc_argo_password.result
 auth_system_ldap_user             = var.auth_system_ldap_user
 auth_system_ldap_config           = var.auth_system_ldap_config
 dex_static_passwords_hash         = var.dex_static_passwords_hash
 argocd-app-installer_helm_version = var.argocd-app-installer_helm_version

 depends_on = [
   helm_release.istio-gateway,
   helm_release.secrets-store-csi-driver-provider-aws
 ]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.72 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.72 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.BURoleForDeployAccessSecretsManager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.BURoleForDexAccessSecretsManager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.BURoleForDeployAccessSecretsManager-attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.BURoleForDexAccessSecretsManager-attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_secretsmanager_secret.cluster_argocd](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.cluster_dex](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.cluster_argocd_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.cluster_dex_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [helm_release.argocd-app-installer](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.coe-argo-rollout](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.coe-argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.coe-dex](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [null_resource.dex_secret_manager](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_integer.iam_role](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [tls_private_key.argocd-rsa-4096](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_ecr_authorization_token.token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_authorization_token) | data source |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_iam_policy.eec_boundary_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [template_file.argo_rollout_values](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.argo_values](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.argocd-app-installer_values](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.dex_values](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argo-rollouts_helm_version"></a> [argo-rollouts\_helm\_version](#input\_argo-rollouts\_helm\_version) | Version of the Helm Argo Rollout | `string` | `"2.22.2"` | no |
| <a name="input_argocd-app-installer_helm_version"></a> [argocd-app-installer\_helm\_version](#input\_argocd-app-installer\_helm\_version) | Version of the Helm Argo app installer | `string` | `"1.0.1"` | no |
| <a name="input_auth_system_ldap_config"></a> [auth\_system\_ldap\_config](#input\_auth\_system\_ldap\_config) | Config for DEX Ldap Connector | `any` | <pre>{<br>  "groupSearch": {<br>    "baseDN": "dc=serasa,dc=intranet",<br>    "filter": "(|(distinguishedName=CN=aws-mlops-odin-airflow-dev-viewer,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(distinguishedName=CN=aws-mlops-odin-airflow-dev-user,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(distinguishedName=CN=aws-mlops-odin-airflow-dev-op,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(distinguishedName=CN=aws-mlops-odin-airflow-dev-admin,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet))",<br>    "groupAttr": "member",<br>    "nameAttr": "name",<br>    "userAttr": "DN"<br>  },<br>  "host": "ldapss.serasa.intranet:389",<br>  "insecureNoSSL": true,<br>  "insecureSkipVerify": true,<br>  "startTLS": false,<br>  "userSearch": {<br>    "baseDN": "dc=serasa,dc=intranet",<br>    "emailAttr": "mail",<br>    "filter": "(|(memberOf=CN=aws-mlops-odin-airflow-dev-viewer,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(memberOf=CN=aws-mlops-odin-airflow-dev-user,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(memberOf=CN=aws-mlops-odin-airflow-dev-op,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(memberOf=CN=aws-mlops-odin-airflow-dev-admin,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet))",<br>    "idAttr": "DN",<br>    "nameAttr": "sAMAccountName",<br>    "username": "sAMAccountName"<br>  },<br>  "usernamePrompt": "Username"<br>}</pre> | no |
| <a name="input_auth_system_ldap_password"></a> [auth\_system\_ldap\_password](#input\_auth\_system\_ldap\_password) | LDAP Password to be setup in DEX | `string` | n/a | yes |
| <a name="input_auth_system_ldap_user"></a> [auth\_system\_ldap\_user](#input\_auth\_system\_ldap\_user) | LDAP User for DEX Connector | `string` | `"CN=sist_mlcoe_unix_01,OU=Red Accounts,OU=Accounts,DC=serasa,DC=intranet"` | no |
| <a name="input_dex_eks_namespace"></a> [dex\_eks\_namespace](#input\_dex\_eks\_namespace) | Namespace to install DEX | `string` | `"auth-system"` | no |
| <a name="input_dex_helm_version"></a> [dex\_helm\_version](#input\_dex\_helm\_version) | Version of the Helm DEX | `string` | `"0.9.0"` | no |
| <a name="input_dex_static_passwords_hash"></a> [dex\_static\_passwords\_hash](#input\_dex\_static\_passwords\_hash) | Hashed password to use as SRE user in DEX, set blank SRE will not be created, Gen hash (echo password \| htpasswd -BinC 10 admin \| cut -d: -f2) | `string` | `""` | no |
| <a name="input_eks_cluster_ad_group_access_admin"></a> [eks\_cluster\_ad\_group\_access\_admin](#input\_eks\_cluster\_ad\_group\_access\_admin) | AD group name to be associated with admin role at Dex | `string` | n/a | yes |
| <a name="input_eks_cluster_ad_group_access_view"></a> [eks\_cluster\_ad\_group\_access\_view](#input\_eks\_cluster\_ad\_group\_access\_view) | AD group name to be associated with admin role at Dex | `string` | n/a | yes |
| <a name="input_eks_cluster_id"></a> [eks\_cluster\_id](#input\_eks\_cluster\_id) | EKS cluster ID | `any` | n/a | yes |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of EKS cluster | `string` | n/a | yes |
| <a name="input_eks_namespace"></a> [eks\_namespace](#input\_eks\_namespace) | Namespace to install coe-argocd | `string` | `"deploy-system"` | no |
| <a name="input_env"></a> [env](#input\_env) | Name of environment (dev\|uat\|sandbox) | `string` | n/a | yes |
| <a name="input_external_dns_domain"></a> [external\_dns\_domain](#input\_external\_dns\_domain) | Domain name to use in external DNS url | `string` | n/a | yes |
| <a name="input_git_repository_branch"></a> [git\_repository\_branch](#input\_git\_repository\_branch) | Name of the Git Branch to use | `string` | `""` | no |
| <a name="input_git_repository_path"></a> [git\_repository\_path](#input\_git\_repository\_path) | Git path in repository were are hosted default apps for this cluster Ex. app/cluster-01 | `string` | n/a | yes |
| <a name="input_git_repository_url"></a> [git\_repository\_url](#input\_git\_repository\_url) | Git url repository were are hosted default apps for this cluster Ex. https://code.experian.local/projects/CDEAMLO/repos/coe-data-platform-infra | `string` | n/a | yes |
| <a name="input_global_ssh_git_repository_url"></a> [global\_ssh\_git\_repository\_url](#input\_global\_ssh\_git\_repository\_url) | Global git repository for the BU team Ex: ssh://git@code.experian.local/cdeamlot | `string` | `"ssh://git@code.experian.local/cdeamlot"` | no |
| <a name="input_helm_version"></a> [helm\_version](#input\_helm\_version) | Version of the Helm Coe Argo | `string` | `"1.0.0"` | no |
| <a name="input_oidc_dex_secret"></a> [oidc\_dex\_secret](#input\_oidc\_dex\_secret) | Secret to setup DEX app for Argo cd | `string` | n/a | yes |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | OIDC EKS provider | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project Name | `string` | n/a | yes |
| <a name="input_resources_aws_account"></a> [resources\_aws\_account](#input\_resources\_aws\_account) | AWS Account with the basic resources | `string` | `"837714169011"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Default Tags to put in all resources | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_argo_url"></a> [argo\_url](#output\_argo\_url) | Coe-argocd URL |
| <a name="output_auth_url"></a> [auth\_url](#output\_auth\_url) | Coe-argocd URL |
| <a name="output_deploy_aws_secrets_manager"></a> [deploy\_aws\_secrets\_manager](#output\_deploy\_aws\_secrets\_manager) | Name of the AWS Secrets Manager use by Deploy system setup repositories |
| <a name="output_deploy_iam_role_arn"></a> [deploy\_iam\_role\_arn](#output\_deploy\_iam\_role\_arn) | Role to be used in Deploy service Account |
| <a name="output_deploy_pub_key"></a> [deploy\_pub\_key](#output\_deploy\_pub\_key) | Pub key to setup Bitbuckek for Argocd integration |
| <a name="output_dex_iam_role_arn"></a> [dex\_iam\_role\_arn](#output\_dex\_iam\_role\_arn) | Role to be used in DEX service Account |
<!-- END_TF_DOCS -->