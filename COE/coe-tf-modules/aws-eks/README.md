
<!-- BEGIN_TF_DOCS -->
# Serasa EKS Cluster

EKS cluster

Documentation in progress

## Install

`Don't Panic!`

Errors may happen during this process, sometimes because of your internet connection issues, and other times due to the lack some information due to the timeout, but the most important here is Don't panic! you can see the doc [docs/common-errors.md](/docs/common-errors.md) where we put the common errors found.

In the most case, you just need to run apply again and everything gone be alright

```bash
make init ENV=dev
make plan ENV=dev
make apply ENV=dev
```

For experts

```bash
make install ENV=dev
```

## Upgrade

```bash
make upgrade ENV=dev
```

## Environment

- sandbox
- dev
- uat
- prod

***NOTE***

For each environment that you create you should create two files
- First in the root path called variables-ENV.tfvars
- Second into the backend-config/ENV.tf

Take files already insides theses places as example to create your own

## Generate Documentation

```bash
make gen-doc
```

## Testing

### Locally

At `docs/examples/coe-default/coe-default` replace source source = "git::https://code.experian.local/scm/esbt/coe-tf-modules.git//aws-eks?ref=aws-eks-v0.0.13" by source = "../../../"

```bash
make testing
```

All files related to test are inside the `test` directory

### Harness Pipeline

You can use the Harness Pipeline [Validacao AMI](https://app.harness.io/ng/account/04Iq9MDcT9WOBwwS6C4oKw/ci/orgs/BRSREMLOPS/projects/Operations/pipelines/teste_AMI/pipeline-studio/?repoName=cdeamlo%2Fcoe-odin-infra.git&connectorRef=account.Global_Bitbucket_SSH&storeType=REMOTE) in the `Operations` project.

## Common erros

[docs/common-errors.md](/docs/common-errors.md)

The bucket that stores EKS logs has the following lifetime policy:
  - Glacier after 20 days
  - Delete after 1 year

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.45 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.5.1 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.14 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 2.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.45 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.5.1 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | >= 1.14 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws-load-balancer-controller"></a> [aws-load-balancer-controller](#module\_aws-load-balancer-controller) | ./modules/aws-load-balancer-controller | n/a |
| <a name="module_coe-argocd"></a> [coe-argocd](#module\_coe-argocd) | ./modules/coe-tf-argocd | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | ./modules/terraform-aws-eks-19.15.3 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.clusterAutoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ebs_csi_driver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.externaldns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.lokiS3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_kms_grant.eec_kms_asg_grant](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant) | resource |
| [aws_kms_key.eks_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.eks_log_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.bucket_config_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.eks_log_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.eks_log_bucket_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.eks_log_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.eks_log_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_security_group.eks_managed_node_group_secondary_additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.one](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.eks_managed_node_group_secondary_additional_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [helm_release.cluster-autoscaler](https://registry.terraform.io/providers/hashicorp/helm/2.5.1/docs/resources/release) | resource |
| [helm_release.external-dns](https://registry.terraform.io/providers/hashicorp/helm/2.5.1/docs/resources/release) | resource |
| [helm_release.istio-base](https://registry.terraform.io/providers/hashicorp/helm/2.5.1/docs/resources/release) | resource |
| [helm_release.istio-discovery](https://registry.terraform.io/providers/hashicorp/helm/2.5.1/docs/resources/release) | resource |
| [helm_release.istio-gateway](https://registry.terraform.io/providers/hashicorp/helm/2.5.1/docs/resources/release) | resource |
| [helm_release.metrics-server](https://registry.terraform.io/providers/hashicorp/helm/2.5.1/docs/resources/release) | resource |
| [helm_release.secrets-store-csi-driver](https://registry.terraform.io/providers/hashicorp/helm/2.5.1/docs/resources/release) | resource |
| [helm_release.secrets-store-csi-driver-provider-aws](https://registry.terraform.io/providers/hashicorp/helm/2.5.1/docs/resources/release) | resource |
| [kubectl_manifest.cluster_role_binding_readonly](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.cluster_role_readonly](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.eni_config](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.istio_envoy_filter](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [local_file.environment](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.disable_az_rebalance_on_asgs](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_password.oidc_argo_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.oidc_monitoring_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_ami.eec_bottlerocket_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_ecr_authorization_token.token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_authorization_token) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy.ec2_container](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.eec_boundary_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.ssm_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_kms_alias.kms_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_alias) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnet.eec_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.internal_pods](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.experian](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.internal_pods](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad_domain"></a> [ad\_domain](#input\_ad\_domain) | Used by AMI instance post build automation to join machine to the domain #DEPRECATED use default\_tags\_ec2 instead. | `string` | `"br.experian.local"` | no |
| <a name="input_ad_group"></a> [ad\_group](#input\_ad\_group) | Set administrator/sudo permissions for the specific AD group. If multiple groups need to be setup they can be separated by commas #DEPRECATED use default\_tags\_ec2 instead. | `string` | `""` | no |
| <a name="input_ami_bottlerocket"></a> [ami\_bottlerocket](#input\_ami\_bottlerocket) | Bottlerocket AMI ID or AUTO to get the latest AMI version | `string` | `"auto"` | no |
| <a name="input_appid"></a> [appid](#input\_appid) | AppID of your project | `string` | n/a | yes |
| <a name="input_argocd-app-installer_helm_version"></a> [argocd-app-installer\_helm\_version](#input\_argocd-app-installer\_helm\_version) | Version of the Helm Argo app installer | `string` | `"v1.0.0-34-gf91dcd0"` | no |
| <a name="input_assume_role_arn"></a> [assume\_role\_arn](#input\_assume\_role\_arn) | Role used by Service Catalog automation | `string` | `""` | no |
| <a name="input_auth_system_ldap_config"></a> [auth\_system\_ldap\_config](#input\_auth\_system\_ldap\_config) | Config for DEX Ldap Connector | `any` | <pre>{<br>  "groupSearch": {<br>    "baseDN": "dc=serasa,dc=intranet",<br>    "filter": "(objectClass=group)",<br>    "groupAttr": "member",<br>    "nameAttr": "name",<br>    "userAttr": "DN"<br>  },<br>  "host": "ldapss.serasa.intranet:389",<br>  "insecureNoSSL": true,<br>  "insecureSkipVerify": true,<br>  "startTLS": false,<br>  "userSearch": {<br>    "baseDN": "dc=serasa,dc=intranet",<br>    "emailAttr": "mail",<br>    "filter": "(|(memberOf=CN=APP-coe-data-platform-sre-access,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(memberOf=CN=aws-mlops-odin-airflow-dev-viewer,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(memberOf=CN=aws-mlops-odin-airflow-dev-user,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(memberOf=CN=aws-mlops-odin-airflow-dev-op,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet)(memberOf=CN=aws-mlops-odin-airflow-dev-admin,OU=OktaSync,OU=Application Groups,OU=Groups,DC=serasa,DC=intranet))",<br>    "idAttr": "DN",<br>    "nameAttr": "sAMAccountName",<br>    "username": "sAMAccountName"<br>  },<br>  "usernamePrompt": "Username"<br>}</pre> | no |
| <a name="input_auth_system_ldap_password"></a> [auth\_system\_ldap\_password](#input\_auth\_system\_ldap\_password) | LDAP Password to be setup in DEX | `string` | n/a | yes |
| <a name="input_auth_system_ldap_user"></a> [auth\_system\_ldap\_user](#input\_auth\_system\_ldap\_user) | LDAP User for DEX Connector | `string` | `"CN=sist_mlcoe_unix_01,OU=Red Accounts,OU=Accounts,DC=serasa,DC=intranet"` | no |
| <a name="input_aws_auth_roles"></a> [aws\_auth\_roles](#input\_aws\_auth\_roles) | List of role maps to add to the aws-auth configmap | `list(any)` | `[]` | no |
| <a name="input_aws_auth_users"></a> [aws\_auth\_users](#input\_aws\_auth\_users) | List of user maps to add to the aws-auth configmap. | `list(any)` | `[]` | no |
| <a name="input_aws_cni_configuration_values"></a> [aws\_cni\_configuration\_values](#input\_aws\_cni\_configuration\_values) | Additional configuration to be set in AWS-CNI, Default: Will alocate 2 x /28 (32) ip per node and will will request more when the remaining number of IPs is below 5. | `map(any)` | <pre>{<br>  "env": {<br>    "AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG": "true",<br>    "ENABLE_PREFIX_DELEGATION": "true",<br>    "ENI_CONFIG_LABEL_DEF": "topology.kubernetes.io/zone",<br>    "WARM_PREFIX_TARGET": "1"<br>  }<br>}</pre> | no |
| <a name="input_aws_cni_custom_network"></a> [aws\_cni\_custom\_network](#input\_aws\_cni\_custom\_network) | Enable or not the Secondary subnet with ip range 100.0/16 | `bool` | `true` | no |
| <a name="input_aws_cni_extra_vars"></a> [aws\_cni\_extra\_vars](#input\_aws\_cni\_extra\_vars) | List of extra var to be setup in AWS CNI. | `list(string)` | `[]` | no |
| <a name="input_aws_ebs_csi_driver_values"></a> [aws\_ebs\_csi\_driver\_values](#input\_aws\_ebs\_csi\_driver\_values) | Additional configuration to be set in AWS EBS CSI | `map(any)` | <pre>{<br>  "controller": {<br>    "extraVolumeTags": {<br>      "AppID": "appid",<br>      "Environment": "Dev",<br>      "Project": "Finance"<br>    }<br>  }<br>}</pre> | no |
| <a name="input_aws_subnets_experian_filter_tags"></a> [aws\_subnets\_experian\_filter\_tags](#input\_aws\_subnets\_experian\_filter\_tags) | additional tag for filter subnets | `map(any)` | `{}` | no |
| <a name="input_aws_vpc_cni_most_recent"></a> [aws\_vpc\_cni\_most\_recent](#input\_aws\_vpc\_cni\_most\_recent) | Get most recent AWS CNI version, default: false. | `bool` | `false` | no |
| <a name="input_aws_vpc_cni_version"></a> [aws\_vpc\_cni\_version](#input\_aws\_vpc\_cni\_version) | Set AWS CNI version, default v1.16.2-eksbuild.1 | `string` | `"v1.16.2-eksbuild.1"` | no |
| <a name="input_centrify_unix_role"></a> [centrify\_unix\_role](#input\_centrify\_unix\_role) | The Unix Role that will be used to grant access and authorization to the Linux instance #DEPRECATED use default\_tags\_ec2 instead. | `string` | `""` | no |
| <a name="input_coe_argocd_eks_namespace"></a> [coe\_argocd\_eks\_namespace](#input\_coe\_argocd\_eks\_namespace) | Namespace to install coe-argocd | `string` | `"deploy-system"` | no |
| <a name="input_coe_argocd_enabled"></a> [coe\_argocd\_enabled](#input\_coe\_argocd\_enabled) | Enable Argocd in the clusterr | `bool` | `true` | no |
| <a name="input_coe_argocd_git_repository_branch"></a> [coe\_argocd\_git\_repository\_branch](#input\_coe\_argocd\_git\_repository\_branch) | Name of the Git Branch to use | `string` | `""` | no |
| <a name="input_coe_argocd_git_repository_path"></a> [coe\_argocd\_git\_repository\_path](#input\_coe\_argocd\_git\_repository\_path) | Git path in repository were are hosted default apps for this cluster Ex. app/cluster-01 | `string` | n/a | yes |
| <a name="input_coe_argocd_git_repository_url"></a> [coe\_argocd\_git\_repository\_url](#input\_coe\_argocd\_git\_repository\_url) | Git url to the repository were are the all default apps for the cluster | `string` | n/a | yes |
| <a name="input_coe_argocd_global_ssh_git_repository_url"></a> [coe\_argocd\_global\_ssh\_git\_repository\_url](#input\_coe\_argocd\_global\_ssh\_git\_repository\_url) | Global git repository for the BU team Ex: ssh://git@code.experian.local/cdeamlot | `string` | n/a | yes |
| <a name="input_coe_argocd_helm_version"></a> [coe\_argocd\_helm\_version](#input\_coe\_argocd\_helm\_version) | Version of the Helm Coe Argo | `string` | `"v1.0.0-35-g4d7195b"` | no |
| <a name="input_coredns_version"></a> [coredns\_version](#input\_coredns\_version) | CoreDNS Version | `string` | `"1.19.0"` | no |
| <a name="input_coststring"></a> [coststring](#input\_coststring) | Cost Center (CostString) of your project | `string` | n/a | yes |
| <a name="input_custom_oidc_thumbprints"></a> [custom\_oidc\_thumbprints](#input\_custom\_oidc\_thumbprints) | Additional list of server certificate thumbprints for the OpenID Connect (OIDC) identity provider's server certificate(s) | `list(string)` | <pre>[<br>  "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"<br>]</pre> | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default Tags to put in all Cluster resources | `map(any)` | `{}` | no |
| <a name="input_default_tags_ec2"></a> [default\_tags\_ec2](#input\_default\_tags\_ec2) | Default tag to EC2 instance - # https://pages.experian.com/pages/viewpage.action?pageId=400041906 | `map(any)` | `{}` | no |
| <a name="input_dex_static_passwords_hash"></a> [dex\_static\_passwords\_hash](#input\_dex\_static\_passwords\_hash) | Hashed password to use as SRE user in DEX, set blank SRE will not be created, Gen hash (echo password \| htpasswd -BinC 10 admin \| cut -d: -f2) | `string` | `""` | no |
| <a name="input_documention"></a> [documention](#input\_documention) | Aditional documentation to be joined with the default create by this moduele | `string` | `""` | no |
| <a name="input_eks_cluster_ad_group_access_admin"></a> [eks\_cluster\_ad\_group\_access\_admin](#input\_eks\_cluster\_ad\_group\_access\_admin) | AD group name to be associated with admin role at Dex | `string` | n/a | yes |
| <a name="input_eks_cluster_ad_group_access_view"></a> [eks\_cluster\_ad\_group\_access\_view](#input\_eks\_cluster\_ad\_group\_access\_view) | AD group name to be associated with admin role at Dex | `string` | n/a | yes |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of EKS cluster | `string` | n/a | yes |
| <a name="input_eks_cluster_node_ipclass"></a> [eks\_cluster\_node\_ipclass](#input\_eks\_cluster\_node\_ipclass) | IP Class for the Worker Nodes. Can be '10' (default) or '100' (used by EKS cluster for kubeflow) | `number` | `10` | no |
| <a name="input_eks_cluster_version"></a> [eks\_cluster\_version](#input\_eks\_cluster\_version) | Kubernetes Version | `string` | `"1.29"` | no |
| <a name="input_eks_managed_node_group_additional_sgs"></a> [eks\_managed\_node\_group\_additional\_sgs](#input\_eks\_managed\_node\_group\_additional\_sgs) | Additional Security Groups ID to be add to all node Groups | `list(any)` | `[]` | no |
| <a name="input_eks_managed_node_group_secondary_additional_rules"></a> [eks\_managed\_node\_group\_secondary\_additional\_rules](#input\_eks\_managed\_node\_group\_secondary\_additional\_rules) | List of additional security group rules to add to the Pods security group created, Secondary Network | `any` | `{}` | no |
| <a name="input_eks_managed_node_groups"></a> [eks\_managed\_node\_groups](#input\_eks\_managed\_node\_groups) | Map of EKS managed node group definitions to create | `any` | `{}` | no |
| <a name="input_eks_managed_node_infra_instance_types"></a> [eks\_managed\_node\_infra\_instance\_types](#input\_eks\_managed\_node\_infra\_instance\_types) | List of instance type for EKS Infra nodes | `list(string)` | <pre>[<br>  "m5a.large"<br>]</pre> | no |
| <a name="input_eks_managed_node_infra_max_size"></a> [eks\_managed\_node\_infra\_max\_size](#input\_eks\_managed\_node\_infra\_max\_size) | Max size to node group | `number` | `6` | no |
| <a name="input_env"></a> [env](#input\_env) | Name of environment (dev\|uat\|sandbox) | `string` | n/a | yes |
| <a name="input_external_dns_domain_filters"></a> [external\_dns\_domain\_filters](#input\_external\_dns\_domain\_filters) | Limit possible target zones by domain suffixes | `list(string)` | `[]` | no |
| <a name="input_external_dns_extra_args"></a> [external\_dns\_extra\_args](#input\_external\_dns\_extra\_args) | Extra arguments to pass to the external-dns container, these are needed for provider specific arguments | `list(string)` | `[]` | no |
| <a name="input_external_dns_logLevel"></a> [external\_dns\_logLevel](#input\_external\_dns\_logLevel) | External DNS log Level (panic, debug, info, warning, error, fatal | `string` | `"info"` | no |
| <a name="input_external_dns_provider"></a> [external\_dns\_provider](#input\_external\_dns\_provider) | DNS provider where the DNS records will be created | `string` | `"aws"` | no |
| <a name="input_external_dns_source"></a> [external\_dns\_source](#input\_external\_dns\_source) | K8s resources type to be observed for new DNS entries | `list(string)` | `[]` | no |
| <a name="input_external_dns_version"></a> [external\_dns\_version](#input\_external\_dns\_version) | Verion of the ExternalDNS | `string` | `"1.14.3"` | no |
| <a name="input_global_max_pods_per_node"></a> [global\_max\_pods\_per\_node](#input\_global\_max\_pods\_per\_node) | Set the maximum number of pods per node. Default is auto | `string` | `"auto"` | no |
| <a name="input_iam_role_additional_policies"></a> [iam\_role\_additional\_policies](#input\_iam\_role\_additional\_policies) | Additional policies to be added to the IAM role | `map(string)` | `{}` | no |
| <a name="input_istio_ingress_annotation"></a> [istio\_ingress\_annotation](#input\_istio\_ingress\_annotation) | Annotion used in service object | `map(string)` | `{}` | no |
| <a name="input_istio_ingress_enabled"></a> [istio\_ingress\_enabled](#input\_istio\_ingress\_enabled) | Enable or disable istio, default yes | `bool` | `true` | no |
| <a name="input_istio_ingress_force_update"></a> [istio\_ingress\_force\_update](#input\_istio\_ingress\_force\_update) | Force istio stack update, default false | `bool` | `false` | no |
| <a name="input_istio_ingress_loadBalancerSourceRanges"></a> [istio\_ingress\_loadBalancerSourceRanges](#input\_istio\_ingress\_loadBalancerSourceRanges) | IPs to allow connection to 443 loadbalancer | `list(string)` | `[]` | no |
| <a name="input_istio_ingress_loadbalancerclass"></a> [istio\_ingress\_loadbalancerclass](#input\_istio\_ingress\_loadbalancerclass) | Set Network Load Balance class for k8s service | `string` | `"service.k8s.aws/nlb"` | no |
| <a name="input_istio_ingress_nlb_proxy_enabled"></a> [istio\_ingress\_nlb\_proxy\_enabled](#input\_istio\_ingress\_nlb\_proxy\_enabled) | Enable or not the NLB proxy, Default is True. | `bool` | `"true"` | no |
| <a name="input_istio_ingress_pod_disruption_budget"></a> [istio\_ingress\_pod\_disruption\_budget](#input\_istio\_ingress\_pod\_disruption\_budget) | This value is used to configure a Kubernetes PodDisruptionBudget for the gateway | `number` | `1` | no |
| <a name="input_istio_ingress_ports"></a> [istio\_ingress\_ports](#input\_istio\_ingress\_ports) | Ports to be listen at new Loadbalances | `list(map(string))` | <pre>[<br>  {}<br>]</pre> | no |
| <a name="input_istio_ingress_replica_count"></a> [istio\_ingress\_replica\_count](#input\_istio\_ingress\_replica\_count) | Define replica set to Istio-ingress container, for prod  minimum recommended is 2 | `number` | `2` | no |
| <a name="input_istio_ingress_version"></a> [istio\_ingress\_version](#input\_istio\_ingress\_version) | Istio version | `string` | `"1.20.2"` | no |
| <a name="input_kms_alias"></a> [kms\_alias](#input\_kms\_alias) | KMS alias to be used by EKS. By default this module will create new KMS for used if you let this values to blank | `string` | `""` | no |
| <a name="input_map_server_id"></a> [map\_server\_id](#input\_map\_server\_id) | AWS Map Migration Server Id | `string` | `""` | no |
| <a name="input_metrics_server_containerPort"></a> [metrics\_server\_containerPort](#input\_metrics\_server\_containerPort) | Port for the metrics-server container | `number` | n/a | yes |
| <a name="input_metrics_server_hostNetwork_enabled"></a> [metrics\_server\_hostNetwork\_enabled](#input\_metrics\_server\_hostNetwork\_enabled) | If true, start metric-server in hostNetwork mode. You would require this enabled if you use alternate overlay networking for pods and API server unable to communicate with metrics-server. As an example, this is required if you use Weave network on EKS | `bool` | n/a | yes |
| <a name="input_metrics_server_replicas"></a> [metrics\_server\_replicas](#input\_metrics\_server\_replicas) | Number of Metrics Server replicas to run | `number` | n/a | yes |
| <a name="input_metrics_server_version"></a> [metrics\_server\_version](#input\_metrics\_server\_version) | Version of Metrics Server | `string` | `"3.12.0"` | no |
| <a name="input_node_group_on_demand_4xlarger_max_size"></a> [node\_group\_on\_demand\_4xlarger\_max\_size](#input\_node\_group\_on\_demand\_4xlarger\_max\_size) | Max size to node group | `any` | `6` | no |
| <a name="input_node_group_on_demand_8xlarger_max_size"></a> [node\_group\_on\_demand\_8xlarger\_max\_size](#input\_node\_group\_on\_demand\_8xlarger\_max\_size) | Max size to node group | `any` | `6` | no |
| <a name="input_node_group_on_demand_c59xlarger_max_size"></a> [node\_group\_on\_demand\_c59xlarger\_max\_size](#input\_node\_group\_on\_demand\_c59xlarger\_max\_size) | Max size to node group | `any` | `6` | no |
| <a name="input_node_group_on_demand_general_larger_max_size"></a> [node\_group\_on\_demand\_general\_larger\_max\_size](#input\_node\_group\_on\_demand\_general\_larger\_max\_size) | Max size to node group | `number` | `6` | no |
| <a name="input_node_group_on_demand_general_medium_max_size"></a> [node\_group\_on\_demand\_general\_medium\_max\_size](#input\_node\_group\_on\_demand\_general\_medium\_max\_size) | Max size to node group | `number` | `6` | no |
| <a name="input_node_group_on_demand_general_small"></a> [node\_group\_on\_demand\_general\_small](#input\_node\_group\_on\_demand\_general\_small) | Max size to node group | `any` | `{}` | no |
| <a name="input_node_group_on_demand_general_small_max_size"></a> [node\_group\_on\_demand\_general\_small\_max\_size](#input\_node\_group\_on\_demand\_general\_small\_max\_size) | Max size to node group | `number` | `6` | no |
| <a name="input_node_group_spot_general_mixed_max_size"></a> [node\_group\_spot\_general\_mixed\_max\_size](#input\_node\_group\_spot\_general\_mixed\_max\_size) | Max size to node group | `number` | `6` | no |
| <a name="input_node_groups_multi_az"></a> [node\_groups\_multi\_az](#input\_node\_groups\_multi\_az) | If set to true will replicate each node group in all AZ set by node\_group\_regions | `bool` | `false` | no |
| <a name="input_node_groups_regions"></a> [node\_groups\_regions](#input\_node\_groups\_regions) | Regions to be used by node\_groups\_multi\_az | `list(any)` | <pre>[<br>  "sa-east-1a",<br>  "sa-east-1b",<br>  "sa-east-1c"<br>]</pre> | no |
| <a name="input_oidc_dex_grafana_callback_monitoring"></a> [oidc\_dex\_grafana\_callback\_monitoring](#input\_oidc\_dex\_grafana\_callback\_monitoring) | Grafana URL to callback after login user ex: https://monitoring-mlops-odin-03.dev-mlops.br.experian.eeca/login/generic_oauth, Default auto. | `string` | `"auto"` | no |
| <a name="input_path_documentation_file"></a> [path\_documentation\_file](#input\_path\_documentation\_file) | Path to create doc file path\_documentation\_file/docs/ENV.md, if empty the doc do not will be created | `string` | `""` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project Name | `string` | n/a | yes |
| <a name="input_rapid7_tag"></a> [rapid7\_tag](#input\_rapid7\_tag) | Tag used to activate Rapid7 and monitor the assets based on the BU which is building the instances #DEPRECATED use default\_tags\_ec2 instead | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"sa-east-1"` | no |
| <a name="input_resource_business_unit"></a> [resource\_business\_unit](#input\_resource\_business\_unit) | Required EEC: Business Unit name #DEPRECATED use default\_tags\_ec2 instead | `string` | `""` | no |
| <a name="input_resource_name"></a> [resource\_name](#input\_resource\_name) | Name of the EC2 instance (fully qualified domain name). The approved AMIs will also use this tag to configure hostname and hosts file in the machine #DEPRECATED use default\_tags\_ec2 instead | `string` | `""` | no |
| <a name="input_resource_owner"></a> [resource\_owner](#input\_resource\_owner) | Team Distribution List that owns the EC2 instance. This email will also be used to notify the Distribution List about any errors found in the AMI post-build phase #DEPRECATED use default\_tags\_ec2 instead | `string` | `""` | no |
| <a name="input_resources_aws_account"></a> [resources\_aws\_account](#input\_resources\_aws\_account) | AWS Account with the basic resources | `string` | `"837714169011"` | no |
| <a name="input_roles"></a> [roles](#input\_roles) | List of Roles name to grant Admin access to cluster. | `list(string)` | <pre>[<br>  "BUAdministratorAccessRole"<br>]</pre> | no |
| <a name="input_users"></a> [users](#input\_users) | List of Users to grant Admin access to cluster. | `list(string)` | `[]` | no |
| <a name="input_vpc_cni_patch_version"></a> [vpc\_cni\_patch\_version](#input\_vpc\_cni\_patch\_version) | Version of CoE SRE VPC CNI Patch | `string` | `"v0.1.6-37"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_VPC_CIDR"></a> [VPC\_CIDR](#output\_VPC\_CIDR) | CIDR Account Range |
| <a name="output_argo_url"></a> [argo\_url](#output\_argo\_url) | Coe-argocd URL |
| <a name="output_auth_url"></a> [auth\_url](#output\_auth\_url) | Coe-argocd URL |
| <a name="output_aws_auth_configmap_yaml"></a> [aws\_auth\_configmap\_yaml](#output\_aws\_auth\_configmap\_yaml) | Formatted yaml output for base aws-auth configmap containing roles used in cluster node groups/fargate profiles |
| <a name="output_bucket_log_name"></a> [bucket\_log\_name](#output\_bucket\_log\_name) | Bucket used for log purpose. IMPORTANT: If EKS is deleted, this bucket must not be deleted. We need to keep the data for at least 1 year according to the civil |
| <a name="output_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#output\_cloudwatch\_log\_group\_arn) | Arn of cloudwatch log group created |
| <a name="output_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#output\_cloudwatch\_log\_group\_name) | Name of cloudwatch log group created |
| <a name="output_cluster_addons"></a> [cluster\_addons](#output\_cluster\_addons) | Map of attribute maps for all EKS cluster addons enabled |
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | The Amazon Resource Name (ARN) of the cluster |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | Base64 encoded certificate data required to communicate with the cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint for your Kubernetes API server |
| <a name="output_cluster_iam_role_arn"></a> [cluster\_iam\_role\_arn](#output\_cluster\_iam\_role\_arn) | IAM role ARN of the EKS cluster |
| <a name="output_cluster_iam_role_name"></a> [cluster\_iam\_role\_name](#output\_cluster\_iam\_role\_name) | IAM role name of the EKS cluster |
| <a name="output_cluster_iam_role_unique_id"></a> [cluster\_iam\_role\_unique\_id](#output\_cluster\_iam\_role\_unique\_id) | Stable and unique string identifying the IAM role |
| <a name="output_cluster_identity_providers"></a> [cluster\_identity\_providers](#output\_cluster\_identity\_providers) | Map of attribute maps for all EKS identity providers enabled |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Kubernetes Cluster Name |
| <a name="output_cluster_name_from_module"></a> [cluster\_name\_from\_module](#output\_cluster\_name\_from\_module) | The name of the EKS cluster. Will block on cluster creation until the cluster is really ready |
| <a name="output_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#output\_cluster\_oidc\_issuer\_url) | The URL on the EKS cluster for the OpenID Connect identity provider |
| <a name="output_cluster_platform_version"></a> [cluster\_platform\_version](#output\_cluster\_platform\_version) | Platform version for the cluster |
| <a name="output_cluster_primary_security_group_id"></a> [cluster\_primary\_security\_group\_id](#output\_cluster\_primary\_security\_group\_id) | Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console |
| <a name="output_cluster_security_group_arn"></a> [cluster\_security\_group\_arn](#output\_cluster\_security\_group\_arn) | Amazon Resource Name (ARN) of the cluster security group |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | ID of the cluster security group |
| <a name="output_cluster_status"></a> [cluster\_status](#output\_cluster\_status) | Status of the EKS cluster. One of `CREATING`, `ACTIVE`, `DELETING`, `FAILED` |
| <a name="output_cluster_version"></a> [cluster\_version](#output\_cluster\_version) | The Kubernetes version for the cluster |
| <a name="output_deploy_aws_secrets_manager"></a> [deploy\_aws\_secrets\_manager](#output\_deploy\_aws\_secrets\_manager) | Name of the AWS Secrets Manager use by Deploy system setup repositories |
| <a name="output_deploy_iam_role_arn"></a> [deploy\_iam\_role\_arn](#output\_deploy\_iam\_role\_arn) | Role to be used in Deploy service Account |
| <a name="output_deploy_pub_key"></a> [deploy\_pub\_key](#output\_deploy\_pub\_key) | Pub key to setup Bitbuckek for Argocd integration |
| <a name="output_dex_iam_role_arn"></a> [dex\_iam\_role\_arn](#output\_dex\_iam\_role\_arn) | Role to be used in DEX service Account |
| <a name="output_eks_managed_node_group_infra"></a> [eks\_managed\_node\_group\_infra](#output\_eks\_managed\_node\_group\_infra) | Map of attribute maps for all EKS managed node INFRA groups created |
| <a name="output_eks_managed_node_groups"></a> [eks\_managed\_node\_groups](#output\_eks\_managed\_node\_groups) | Map of attribute maps for all EKS managed node groups created |
| <a name="output_eks_managed_node_groups_autoscaling_group_names"></a> [eks\_managed\_node\_groups\_autoscaling\_group\_names](#output\_eks\_managed\_node\_groups\_autoscaling\_group\_names) | List of the autoscaling group names created by EKS managed node groups |
| <a name="output_grafana_password"></a> [grafana\_password](#output\_grafana\_password) | Grafana Password |
| <a name="output_node_security_group_arn"></a> [node\_security\_group\_arn](#output\_node\_security\_group\_arn) | Amazon Resource Name (ARN) of the node shared security group |
| <a name="output_node_security_group_id"></a> [node\_security\_group\_id](#output\_node\_security\_group\_id) | ID of the node shared security group |
| <a name="output_oidc_provider"></a> [oidc\_provider](#output\_oidc\_provider) | The OpenID Connect identity provider (issuer URL without leading `https://`) |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | The ARN of the OIDC Provider if `enable_irsa = true` |
| <a name="output_region"></a> [region](#output\_region) | AWS region |
| <a name="output_self_managed_node_groups"></a> [self\_managed\_node\_groups](#output\_self\_managed\_node\_groups) | Map of attribute maps for all self managed node groups created |
| <a name="output_self_managed_node_groups_autoscaling_group_names"></a> [self\_managed\_node\_groups\_autoscaling\_group\_names](#output\_self\_managed\_node\_groups\_autoscaling\_group\_names) | List of the autoscaling group names created by self-managed node groups |
<!-- END_TF_DOCS -->
