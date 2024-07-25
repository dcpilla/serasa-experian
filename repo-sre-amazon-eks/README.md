terraform init -backend-config=backend-config/dev.tf
terraform plan --var-file=variables-dev.tfvars  -out=dev.plan
<!-- BEGIN_TF_DOCS -->
# Serasa EKS Cluster

EKS cluster

Documentation in progress

## Install

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
- backend-config/ENV.tf - S3 Backend configuration for Terraform
- variables-ENV.tfvars - Your cluster's deploy configuration

Take files already insides theses places as example to create your own

## Generate Documentation

```bash
make gen-doc
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | = 3.73.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 2.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.73.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.5.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 18.17.1 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.clusterAutoscaler](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.externaldns](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.lokiS3](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.clusterAutoscaler](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.externaldns](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lokiS3](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_grant.eec_kms_asg_grant](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/resources/kms_grant) | resource |
| [aws_kms_key.eks_secret](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/resources/kms_key) | resource |
| [aws_s3_bucket.eks_accesslog_bucket](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.eks_helm_bucket](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.eks_log_bucket](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.eks_accesslog_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.eks_helm_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.eks_log_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.eks_accesslog_bucket_access_block](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.eks_helm_bucket_access_block](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.eks_log_bucket_access_block](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_security_group.one](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/resources/security_group) | resource |
| [helm_release.aws-vpc-cni-patch](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cluster-autoscaler](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.external-dns](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio-base](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio-discovery](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio-gateway](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.kube-prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.loki-stack](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.metrics-server](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [random_id.s3_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_ami.eec_bottlerocket_ami](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy.ec2_container](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.eec_boundary_policy](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.ssm_instance](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/data-sources/iam_policy) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/data-sources/region) | data source |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/data-sources/subnet) | data source |
| [aws_subnet_ids.internal-pods](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/data-sources/subnet_ids) | data source |
| [aws_subnet_ids.pods](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/3.73.0/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_bottlerocket"></a> [ami\_bottlerocket](#input\_ami\_bottlerocket) | Bottlerocket AMI ID or AUTO to get the latest AMI version | `string` | `"auto"` | no |
| <a name="input_assume_role_arn"></a> [assume\_role\_arn](#input\_assume\_role\_arn) | Role used by Service Catalog automation | `string` | `""` | no |
| <a name="input_coredns_version"></a> [coredns\_version](#input\_coredns\_version) | CoreDNS Version | `string` | `"1.19.0"` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of EKS cluster | `string` | n/a | yes |
| <a name="input_eks_cluster_version"></a> [eks\_cluster\_version](#input\_eks\_cluster\_version) | Kubernetes Version | `string` | `"1.21"` | no |
| <a name="input_eks_managed_node_infra_max_size"></a> [eks\_managed\_node\_infra\_max\_size](#input\_eks\_managed\_node\_infra\_max\_size) | Max size to node group | `number` | `6` | no |
| <a name="input_env"></a> [env](#input\_env) | Name of environment (dev\|uat\|sandbox) | `string` | n/a | yes |
| <a name="input_external_dns_domain_filters"></a> [external\_dns\_domain\_filters](#input\_external\_dns\_domain\_filters) | Limit possible target zones by domain suffixes | `list(string)` | `[]` | no |
| <a name="input_external_dns_extra_args"></a> [external\_dns\_extra\_args](#input\_external\_dns\_extra\_args) | Extra arguments to pass to the external-dns container, these are needed for provider specific arguments | `list(string)` | `[]` | no |
| <a name="input_external_dns_logLevel"></a> [external\_dns\_logLevel](#input\_external\_dns\_logLevel) | External DNS log Level (panic, debug, info, warning, error, fatal | `string` | `"info"` | no |
| <a name="input_external_dns_provider"></a> [external\_dns\_provider](#input\_external\_dns\_provider) | DNS provider where the DNS records will be created | `string` | `"aws"` | no |
| <a name="input_external_dns_source"></a> [external\_dns\_source](#input\_external\_dns\_source) | K8s resources type to be observed for new DNS entries | `list(string)` | `[]` | no |
| <a name="input_external_dns_version"></a> [external\_dns\_version](#input\_external\_dns\_version) | Verion of the ExternalDNS | `string` | `"1.7.1"` | no |
| <a name="input_istio_ingress_annotation"></a> [istio\_ingress\_annotation](#input\_istio\_ingress\_annotation) | Annotion used in service object | `map(string)` | `{}` | no |
| <a name="input_istio_ingress_enabled"></a> [istio\_ingress\_enabled](#input\_istio\_ingress\_enabled) | Enable or disable istio, default yes | `bool` | `true` | no |
| <a name="input_istio_ingress_force_update"></a> [istio\_ingress\_force\_update](#input\_istio\_ingress\_force\_update) | Force istio stack update, default false | `bool` | `false` | no |
| <a name="input_istio_ingress_loadBalancerSourceRanges"></a> [istio\_ingress\_loadBalancerSourceRanges](#input\_istio\_ingress\_loadBalancerSourceRanges) | IPs to allow connection to 443 loadbalancer | `list(string)` | `[]` | no |
| <a name="input_istio_ingress_ports"></a> [istio\_ingress\_ports](#input\_istio\_ingress\_ports) | Ports to be listen at new Loadbalances | `list(map(string))` | n/a | yes |
| <a name="input_istio_ingress_version"></a> [istio\_ingress\_version](#input\_istio\_ingress\_version) | Istio version | `string` | `"1.12.2"` | no |
| <a name="input_map_server_id"></a> [map\_server\_id](#input\_map\_server\_id) | AWS Map Migration Server Id | `string` | `""` | no |
| <a name="input_metrics_server_containerPort"></a> [metrics\_server\_containerPort](#input\_metrics\_server\_containerPort) | Port for the metrics-server container | `number` | n/a | yes |
| <a name="input_metrics_server_hostNetwork_enabled"></a> [metrics\_server\_hostNetwork\_enabled](#input\_metrics\_server\_hostNetwork\_enabled) | If true, start metric-server in hostNetwork mode. You would require this enabled if you use alternate overlay networking for pods and API server unable to communicate with metrics-server. As an example, this is required if you use Weave network on EKS | `bool` | n/a | yes |
| <a name="input_metrics_server_replicas"></a> [metrics\_server\_replicas](#input\_metrics\_server\_replicas) | Number of Metrics Server replicas to run | `number` | n/a | yes |
| <a name="input_metrics_server_version"></a> [metrics\_server\_version](#input\_metrics\_server\_version) | Version of Metrics Server | `string` | `"3.8.0"` | no |
| <a name="input_node_group_on_demand_general_larger_max_size"></a> [node\_group\_on\_demand\_general\_larger\_max\_size](#input\_node\_group\_on\_demand\_general\_larger\_max\_size) | Max size to node group | `number` | `6` | no |
| <a name="input_node_group_on_demand_general_medium_max_size"></a> [node\_group\_on\_demand\_general\_medium\_max\_size](#input\_node\_group\_on\_demand\_general\_medium\_max\_size) | Max size to node group | `number` | `6` | no |
| <a name="input_node_group_on_demand_general_small"></a> [node\_group\_on\_demand\_general\_small](#input\_node\_group\_on\_demand\_general\_small) | Max size to node group | `any` | `{}` | no |
| <a name="input_node_group_on_demand_general_small_max_size"></a> [node\_group\_on\_demand\_general\_small\_max\_size](#input\_node\_group\_on\_demand\_general\_small\_max\_size) | Max size to node group | `number` | `6` | no |
| <a name="input_node_group_spot_general_mixed_max_size"></a> [node\_group\_spot\_general\_mixed\_max\_size](#input\_node\_group\_spot\_general\_mixed\_max\_size) | Max size to node group | `number` | `6` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project Name | `string` | n/a | yes |
| <a name="input_proxy_env_vars"></a> [proxy\_env\_vars](#input\_proxy\_env\_vars) | Serasa Experian Proxy | `list` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"sa-east-1"` | no |
| <a name="input_resource_business_unit"></a> [resource\_business\_unit](#input\_resource\_business\_unit) | Required EEC: Business Unit name # https://pages.experian.com/display/SC/How+to+build+EC2+instances+using+the+Experian+Golden+AMIs | `string` | n/a | yes |
| <a name="input_resource_name"></a> [resource\_name](#input\_resource\_name) | Name of the EC2 instance (fully qualified domain name). The approved AMIs will also use this tag to configure hostname and hosts file in the machine | `string` | n/a | yes |
| <a name="input_resource_owner"></a> [resource\_owner](#input\_resource\_owner) | Team Distribution List that owns the EC2 instance. This email will also be used to notify the Distribution List about any errors found in the AMI post-build phase | `string` | n/a | yes |
| <a name="input_roles"></a> [roles](#input\_roles) | List of Roles name to grant Admin access to cluster. | `list(string)` | <pre>[<br>  "BUAdministratorAccessRole"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_VPC_CIDR"></a> [VPC\_CIDR](#output\_VPC\_CIDR) | CIDR Account Range |
| <a name="output_bucket_helm_name"></a> [bucket\_helm\_name](#output\_bucket\_helm\_name) | Bucket used to store PiaaS Helm Charts for deployments |
| <a name="output_bucket_log_name"></a> [bucket\_log\_name](#output\_bucket\_log\_name) | Bucket used for log purpose |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint for EKS control plane. |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | EKS Cluster ID. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Kubernetes Cluster Name |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | Security group ids attached to the cluster control plane. |
| <a name="output_grafana_password"></a> [grafana\_password](#output\_grafana\_password) | Grafana Password |
| <a name="output_region"></a> [region](#output\_region) | AWS Region |
<!-- END_TF_DOCS -->
