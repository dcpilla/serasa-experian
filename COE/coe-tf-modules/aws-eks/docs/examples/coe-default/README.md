<!-- BEGIN_TF_DOCS -->
# Experian Odin EKS

ODIN EKS

![Image](docs/odin.drawio.svg)

## Install

`Don't Panic!`

Errors may happen during this process, sometimes because of your internet connection issues, and other times due to the lack some information due to the timeout, but the most important here is Don't panic! you can see the doc [docs/common-errors.md](../common-errors.md) where we put the common errors found.

In the most case, you just need to run apply again and everything gone be alright

OK go on, first you need change the 'bucket' name in the file 'backend-config/dev.tf' to reflect you environment

Make the ajustment in the variables-dev.tfvars as well

```bash
make init ENV=dev
make plan ENV=dev
```

Check if all changes are correct and apply the terraform

```bash
make apply ENV=dev
```

You can use 'make install ENV=dev' to do all step above

If you don't have the make installed in you machine your can use the 'terraform' command directly, you can check the correct command in the [Makefile](Makefile)

## Install Kubeflow

See the instructions in this repo:  https://code.experian.local/projects/CDEAMLO/repos/k8s-infrastructure/browse/kustomize/kubeflow?at=refs%2Ftags%2Fkubeflow-v1.4.1-r0.5

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

*## Install Feature Proxy no AWS NLB
Add the boolean variable istio\_ingress\_nlb\_proxy\_enabled to enable or disable the Proxy feature in NLB in variables.tf
Add the annotation: "service.beta.kubernetes.io/aws-load-balancer-proxy-protocol" in  helm.tf
Envoy filter created in kubect.tf

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.45 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_experian_eks"></a> [experian\_eks](#module\_experian\_eks) | ../../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.oidc_argo_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad_domain"></a> [ad\_domain](#input\_ad\_domain) | Used by AMI instance post build automation to join machine to the domain. | `string` | `"br.experian.local"` | no |
| <a name="input_ad_group"></a> [ad\_group](#input\_ad\_group) | Set administrator/sudo permissions for the specific AD group. If multiple groups need to be setup they can be separated by commas. | `string` | `""` | no |
| <a name="input_ami_bottlerocket"></a> [ami\_bottlerocket](#input\_ami\_bottlerocket) | Bottlerocket AMI ID or AUTO to get the latest AMI version | `string` | `"auto"` | no |
| <a name="input_appid"></a> [appid](#input\_appid) | AppID of your project | `string` | n/a | yes |
| <a name="input_assume_role_arn"></a> [assume\_role\_arn](#input\_assume\_role\_arn) | Role used by Service Catalog automation | `string` | `""` | no |
| <a name="input_auth_system_ldap_config"></a> [auth\_system\_ldap\_config](#input\_auth\_system\_ldap\_config) | Config for DEX Ldap Connector | `any` | n/a | yes |
| <a name="input_auth_system_ldap_password"></a> [auth\_system\_ldap\_password](#input\_auth\_system\_ldap\_password) | LDAP Password to be setup in DEX | `string` | n/a | yes |
| <a name="input_auth_system_ldap_user"></a> [auth\_system\_ldap\_user](#input\_auth\_system\_ldap\_user) | LDAP User for DEX Connector | `string` | `"CN=sist_mlcoe_unix_01,OU=Red Accounts,OU=Accounts,DC=serasa,DC=intranet"` | no |
| <a name="input_aws_auth_roles"></a> [aws\_auth\_roles](#input\_aws\_auth\_roles) | List of role maps to add to the aws-auth configmap | `list(any)` | `[]` | no |
| <a name="input_aws_auth_users"></a> [aws\_auth\_users](#input\_aws\_auth\_users) | List of user maps to add to the aws-auth configmap. | `list(any)` | `[]` | no |
| <a name="input_aws_cni_configuration_values"></a> [aws\_cni\_configuration\_values](#input\_aws\_cni\_configuration\_values) | Additional configuration to be set in AWS-CNI | `map(any)` | `null` | no |
| <a name="input_aws_cni_extra_vars"></a> [aws\_cni\_extra\_vars](#input\_aws\_cni\_extra\_vars) | List of extra var to be setup in AWS CNI. | `list(string)` | `[]` | no |
| <a name="input_centrify_unix_role"></a> [centrify\_unix\_role](#input\_centrify\_unix\_role) | The Unix Role that will be used to grant access and authorization to the Linux instance. | `string` | `""` | no |
| <a name="input_coe_argocd_eks_namespace"></a> [coe\_argocd\_eks\_namespace](#input\_coe\_argocd\_eks\_namespace) | Namespace to install coe-argocd | `string` | `"deploy-system"` | no |
| <a name="input_coe_argocd_git_repository_branch"></a> [coe\_argocd\_git\_repository\_branch](#input\_coe\_argocd\_git\_repository\_branch) | Name of the Git Branch to use | `string` | `""` | no |
| <a name="input_coe_argocd_git_repository_path"></a> [coe\_argocd\_git\_repository\_path](#input\_coe\_argocd\_git\_repository\_path) | Git path in repository were are hosted default apps for this cluster Ex. app/cluster-01 | `string` | n/a | yes |
| <a name="input_coe_argocd_git_repository_url"></a> [coe\_argocd\_git\_repository\_url](#input\_coe\_argocd\_git\_repository\_url) | Git url to the repository were are the all default apps for the cluster | `string` | n/a | yes |
| <a name="input_coe_argocd_global_ssh_git_repository_url"></a> [coe\_argocd\_global\_ssh\_git\_repository\_url](#input\_coe\_argocd\_global\_ssh\_git\_repository\_url) | Global git repository for the BU team Ex: ssh://git@code.experian.local/cdeamlot | `string` | n/a | yes |
| <a name="input_coe_argocd_helm_version"></a> [coe\_argocd\_helm\_version](#input\_coe\_argocd\_helm\_version) | Version of the Helm Coe Argo, try not use it, let the module choose the best version for you | `string` | `null` | no |
| <a name="input_coredns_version"></a> [coredns\_version](#input\_coredns\_version) | CoreDNS Version | `string` | `"1.19.0"` | no |
| <a name="input_coststring"></a> [coststring](#input\_coststring) | Cost Center (CostString) of your project | `string` | n/a | yes |
| <a name="input_custom_oidc_thumbprints"></a> [custom\_oidc\_thumbprints](#input\_custom\_oidc\_thumbprints) | Additional list of server certificate thumbprints for the OpenID Connect (OIDC) identity provider's server certificate(s) | `list(string)` | `[]` | no |
| <a name="input_default_tags_ec2"></a> [default\_tags\_ec2](#input\_default\_tags\_ec2) | Default tag to EC2 instance - # https://pages.experian.com/pages/viewpage.action?pageId=400041906 | `map(any)` | `{}` | no |
| <a name="input_deploy_project_name"></a> [deploy\_project\_name](#input\_deploy\_project\_name) | Name of the Project in the APPS repository, default is PROJECT\_NAME | `string` | `""` | no |
| <a name="input_dex_static_passwords_hash"></a> [dex\_static\_passwords\_hash](#input\_dex\_static\_passwords\_hash) | Hashed password to use as SRE user in DEX, set blank SRE will not be created, Gen hash (echo password \| htpasswd -BinC 10 admin \| cut -d: -f2) | `string` | `""` | no |
| <a name="input_eks_cluster_ad_group_access_admin"></a> [eks\_cluster\_ad\_group\_access\_admin](#input\_eks\_cluster\_ad\_group\_access\_admin) | AD group name to be associated with admin role at Dex | `string` | n/a | yes |
| <a name="input_eks_cluster_ad_group_access_view"></a> [eks\_cluster\_ad\_group\_access\_view](#input\_eks\_cluster\_ad\_group\_access\_view) | AD group name to be associated with admin role at Dex | `string` | n/a | yes |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of EKS cluster | `string` | n/a | yes |
| <a name="input_eks_cluster_node_ipclass"></a> [eks\_cluster\_node\_ipclass](#input\_eks\_cluster\_node\_ipclass) | IP Class for the Worker Nodes. Can be '10' (default) or '100' (used by EKS cluster for kubeflow) | `number` | `10` | no |
| <a name="input_eks_managed_node_groups"></a> [eks\_managed\_node\_groups](#input\_eks\_managed\_node\_groups) | Map of EKS managed node group definitions to create | `map(any)` | `{}` | no |
| <a name="input_eks_managed_node_infra_instance_types"></a> [eks\_managed\_node\_infra\_instance\_types](#input\_eks\_managed\_node\_infra\_instance\_types) | List of instance type for EKS Infra nodes | `list(string)` | <pre>[<br>  "m5.large"<br>]</pre> | no |
| <a name="input_eks_managed_node_infra_max_size"></a> [eks\_managed\_node\_infra\_max\_size](#input\_eks\_managed\_node\_infra\_max\_size) | Max size to node group | `number` | `6` | no |
| <a name="input_env"></a> [env](#input\_env) | Name of environment (dev\|uat\|sandbox) | `string` | n/a | yes |
| <a name="input_external_dns_domain_filters"></a> [external\_dns\_domain\_filters](#input\_external\_dns\_domain\_filters) | Limit possible target zones by domain suffixes, the first element of the list will be used in AUTH system url | `list(string)` | `[]` | no |
| <a name="input_external_dns_extra_args"></a> [external\_dns\_extra\_args](#input\_external\_dns\_extra\_args) | Extra arguments to pass to the external-dns container, these are needed for provider specific arguments | `list(string)` | `[]` | no |
| <a name="input_external_dns_logLevel"></a> [external\_dns\_logLevel](#input\_external\_dns\_logLevel) | External DNS log Level (panic, debug, info, warning, error, fatal | `string` | `"info"` | no |
| <a name="input_external_dns_provider"></a> [external\_dns\_provider](#input\_external\_dns\_provider) | DNS provider where the DNS records will be created | `string` | `"aws"` | no |
| <a name="input_external_dns_source"></a> [external\_dns\_source](#input\_external\_dns\_source) | K8s resources type to be observed for new DNS entries | `list(string)` | `[]` | no |
| <a name="input_external_dns_version"></a> [external\_dns\_version](#input\_external\_dns\_version) | Verion of the ExternalDNS | `string` | `"1.7.1"` | no |
| <a name="input_global_max_pods_per_node"></a> [global\_max\_pods\_per\_node](#input\_global\_max\_pods\_per\_node) | Set the maximum number of pods per node. Default is auto | `string` | `"auto"` | no |
| <a name="input_istio_ingress_annotation"></a> [istio\_ingress\_annotation](#input\_istio\_ingress\_annotation) | Annotion used in service object | `map(string)` | `{}` | no |
| <a name="input_istio_ingress_enabled"></a> [istio\_ingress\_enabled](#input\_istio\_ingress\_enabled) | Enable or disable istio, default yes | `bool` | `true` | no |
| <a name="input_istio_ingress_force_update"></a> [istio\_ingress\_force\_update](#input\_istio\_ingress\_force\_update) | Force istio stack update, default false | `bool` | `false` | no |
| <a name="input_istio_ingress_loadBalancerSourceRanges"></a> [istio\_ingress\_loadBalancerSourceRanges](#input\_istio\_ingress\_loadBalancerSourceRanges) | IPs to allow connection to 443 loadbalancer | `list(string)` | `[]` | no |
| <a name="input_istio_ingress_ports"></a> [istio\_ingress\_ports](#input\_istio\_ingress\_ports) | Ports to be listen at new Loadbalances | `list(map(string))` | <pre>[<br>  {}<br>]</pre> | no |
| <a name="input_istio_ingress_replica_count"></a> [istio\_ingress\_replica\_count](#input\_istio\_ingress\_replica\_count) | Define replica set to Istio-ingress container, for prod  minimum recommended is 2 | `number` | `2` | no |
| <a name="input_istio_ingress_version"></a> [istio\_ingress\_version](#input\_istio\_ingress\_version) | Istio version | `string` | `"1.12.2"` | no |
| <a name="input_map_server_id"></a> [map\_server\_id](#input\_map\_server\_id) | AWS Map Migration Server Id | `string` | `""` | no |
| <a name="input_metrics_server_containerPort"></a> [metrics\_server\_containerPort](#input\_metrics\_server\_containerPort) | Port for the metrics-server container | `number` | n/a | yes |
| <a name="input_metrics_server_hostNetwork_enabled"></a> [metrics\_server\_hostNetwork\_enabled](#input\_metrics\_server\_hostNetwork\_enabled) | If true, start metric-server in hostNetwork mode. You would require this enabled if you use alternate overlay networking for pods and API server unable to communicate with metrics-server. As an example, this is required if you use Weave network on EKS | `bool` | n/a | yes |
| <a name="input_metrics_server_replicas"></a> [metrics\_server\_replicas](#input\_metrics\_server\_replicas) | Number of Metrics Server replicas to run | `number` | n/a | yes |
| <a name="input_metrics_server_version"></a> [metrics\_server\_version](#input\_metrics\_server\_version) | Version of Metrics Server | `string` | `"3.8.0"` | no |
| <a name="input_node_group_on_demand_4xlarger_max_size"></a> [node\_group\_on\_demand\_4xlarger\_max\_size](#input\_node\_group\_on\_demand\_4xlarger\_max\_size) | Max size to node group | `any` | `6` | no |
| <a name="input_node_group_on_demand_8xlarger_max_size"></a> [node\_group\_on\_demand\_8xlarger\_max\_size](#input\_node\_group\_on\_demand\_8xlarger\_max\_size) | Max size to node group | `any` | `6` | no |
| <a name="input_node_group_on_demand_c59xlarger_max_size"></a> [node\_group\_on\_demand\_c59xlarger\_max\_size](#input\_node\_group\_on\_demand\_c59xlarger\_max\_size) | Max size to node group | `any` | `6` | no |
| <a name="input_node_group_on_demand_general_larger_max_size"></a> [node\_group\_on\_demand\_general\_larger\_max\_size](#input\_node\_group\_on\_demand\_general\_larger\_max\_size) | Max size to node group | `number` | `6` | no |
| <a name="input_node_group_on_demand_general_medium_max_size"></a> [node\_group\_on\_demand\_general\_medium\_max\_size](#input\_node\_group\_on\_demand\_general\_medium\_max\_size) | Max size to node group | `number` | `6` | no |
| <a name="input_node_group_on_demand_general_small"></a> [node\_group\_on\_demand\_general\_small](#input\_node\_group\_on\_demand\_general\_small) | Max size to node group | `any` | `{}` | no |
| <a name="input_node_group_on_demand_general_small_max_size"></a> [node\_group\_on\_demand\_general\_small\_max\_size](#input\_node\_group\_on\_demand\_general\_small\_max\_size) | Max size to node group | `number` | `6` | no |
| <a name="input_node_group_on_demand_r5n2xlarge_max_size"></a> [node\_group\_on\_demand\_r5n2xlarge\_max\_size](#input\_node\_group\_on\_demand\_r5n2xlarge\_max\_size) | Max size to node group | `any` | `6` | no |
| <a name="input_node_group_spot_general_mixed_max_size"></a> [node\_group\_spot\_general\_mixed\_max\_size](#input\_node\_group\_spot\_general\_mixed\_max\_size) | Max size to node group | `number` | `6` | no |
| <a name="input_node_groups_multi_az"></a> [node\_groups\_multi\_az](#input\_node\_groups\_multi\_az) | If set to true will replicate each node group in all AZ set by node\_group\_regions | `bool` | `false` | no |
| <a name="input_node_groups_regions"></a> [node\_groups\_regions](#input\_node\_groups\_regions) | Regions to be used by node\_groups\_multi\_az | `list(any)` | <pre>[<br>  "sa-east-1a",<br>  "sa-east-1b",<br>  "sa-east-1c"<br>]</pre> | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project Name | `string` | n/a | yes |
| <a name="input_rapid7_tag"></a> [rapid7\_tag](#input\_rapid7\_tag) | Tag used to activate Rapid7 and monitor the assets based on the BU which is building the instances | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"sa-east-1"` | no |
| <a name="input_resource_business_unit"></a> [resource\_business\_unit](#input\_resource\_business\_unit) | Required EEC: Business Unit name # https://pages.experian.com/display/SC/How+to+build+EC2+instances+using+the+Experian+Golden+AMIs | `string` | `""` | no |
| <a name="input_resource_name"></a> [resource\_name](#input\_resource\_name) | Name of the EC2 instance (fully qualified domain name). The approved AMIs will also use this tag to configure hostname and hosts file in the machine | `string` | `""` | no |
| <a name="input_resource_owner"></a> [resource\_owner](#input\_resource\_owner) | Team Distribution List that owns the EC2 instance. This email will also be used to notify the Distribution List about any errors found in the AMI post-build phase | `string` | `""` | no |
| <a name="input_resources_aws_account"></a> [resources\_aws\_account](#input\_resources\_aws\_account) | AWS Account with the basic resources | `string` | `"837714169011"` | no |
| <a name="input_roles"></a> [roles](#input\_roles) | List of Roles name to grant Admin access to cluster. | `list(string)` | <pre>[<br>  "BUAdministratorAccessRole"<br>]</pre> | no |
| <a name="input_users"></a> [users](#input\_users) | List of Users to grant Admin access to cluster. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_deploy_pub_key"></a> [deploy\_pub\_key](#output\_deploy\_pub\_key) | Pub key to setup Bitbuckek for Argocd integration |
<!-- END_TF_DOCS -->