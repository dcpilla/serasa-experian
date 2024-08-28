<!-- BEGIN_TF_DOCS -->
# AWS LOAD BALANCER CONTROLLER

Install controller to manager load balancer from EKS cluster

```hcl
module "aws-load-balancer-controller" {
source = "./modules/aws-load-balancer-controller"

env                   = var.env
eks_cluster_name      = var.eks_cluster_name
project_name          = var.project_name
tags                  = local.default_tags
oidc_provider_arn     = module.eks.oidc_provider_arn
eks_cluster_id        = module.eks.cluster_id
resources_aws_account = var.resources_aws_account
eec_boundary_policy   = data.aws_iam_policy.eec_boundary_policy.arn

depends_on = [
  helm_release.metrics-server
]
*}
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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.BUPolicyForAwsLoadbalanceController](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.BURoleForAwsLoadbalanceController](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.BURoleForAwsLoadbalanceController](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [helm_release.aws-load-balancer-controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_ecr_authorization_token.token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_authorization_token) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eec_boundary_policy"></a> [eec\_boundary\_policy](#input\_eec\_boundary\_policy) | ARN EEC boundary policy | `string` | n/a | yes |
| <a name="input_eks_cluster_id"></a> [eks\_cluster\_id](#input\_eks\_cluster\_id) | EKS cluster ID | `any` | n/a | yes |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of EKS cluster | `string` | n/a | yes |
| <a name="input_eks_namespace"></a> [eks\_namespace](#input\_eks\_namespace) | Namespace to install coe-argocd | `string` | `"kube-system"` | no |
| <a name="input_env"></a> [env](#input\_env) | Name of environment (dev\|uat\|sandbox) | `string` | n/a | yes |
| <a name="input_helm_version"></a> [helm\_version](#input\_helm\_version) | Version of the Helm Coe Argo | `string` | `"1.4.7"` | no |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | OIDC EKS provider | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project Name | `string` | n/a | yes |
| <a name="input_resources_aws_account"></a> [resources\_aws\_account](#input\_resources\_aws\_account) | AWS Account with the basic resources | `string` | `"837714169011"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Default Tags to put in all resources | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN Role |
<!-- END_TF_DOCS -->