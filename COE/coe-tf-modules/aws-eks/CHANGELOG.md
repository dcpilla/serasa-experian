# Changelog

All notable changes to this project will be documented in this file.

### [aws-eks-1.29-v0.0.3](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-eks-1.29-v0.0.10&sourceBranch=refs%2Ftags%2Faws-eks-1.27-v0.0.11) (2024-05-08)

### Features

- Added OIDC setup for Grafana authentication
- Updated App-installer to v1.0.0-34-gf91dcd0
- Change Group filter to DEX, now we retrieve all group associated with the user
- Add global to app-to-app values
- Added support for GPU node groups

### [aws-eks-1.29-v0.0.2](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-eks-1.29-v0.0.10&sourceBranch=refs%2Ftags%2Faws-eks-1.27-v0.0.11) (2024-05-01)

### Fix

- Fix component to disable az_rebalance

### [aws-eks-1.29-v0.0.1](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-eks-1.29-v0.0.10&sourceBranch=refs%2Ftags%2Faws-eks-1.27-v0.0.11) (2024-01-17)

### Features

- Updated EKS from 1.27 to 1.29
- Updated metrics-server from 0.6.3 to 0.7.0 (HELM form 3.10.0 to 3.12.0)
- Updated cluster-autoscaler from 1.27.2 to 1.29.0 (HELM from 9.29.1 to 9.35.0)
- Updated secrets-store-csi-driver from 1.3.1 to 1.4.1
- Updated secrets-provider-aws from 0.2.0 to 0.3.5
- Updated Istio from 1.18.0 to 1.20.2
- Updated external_dns_version from 0.13.5 to 0.14.0 (HELM from 1.13.0 to 1.14.3)
- Updated argo-rollout v1.4.0 to v1.6.6 (HELM 2.22.2 from to 2.34.3)
- Updated aws-load-balancer-controller v2.4.6 to v2.7.1 (HELM 1.47 to 1.7.1)
- Updated ArgoCD from v2.9.0 to v2.9.5 (HELM to v1.0.0-35-g4d7195b)
- Added support to use AMI Bottlerocket from AWS vendor (044060155884), to use a AWS AMI just set the AMI ID in the variable "ami_bottlerocket"
- Replaced usage of EnvoyFilter to enable PROXY protocol on the ingress gateways by the gatewayTopology field in ProxyConfig.
- Set istio_ingress_replica_count to 2
- Added new mandatory tags:
  - coststring
  - appid
- Added mandatory tags to SG and LoadBalancer created by Istio
- Added aws_vpc_cni_most_recent and aws_vpc_cni_version variable to set AWS CNI
- Added aws_ebs_csi_driver_values to send parameters to AWS EBS CSI drive
- Changed "WARM_PREFIX_TARGET" and removed "MINIMUM_IP_TARGET", for let more ips available per node.
- Added "istio_ingress_loadbalancerclass" for migration purpose.Set it to "null" only if you already have a NLB created in your environment.
- Create infra node group ASG in all AZ

### FiX

- When executing the updates process, the Istio gateway returned the error "loadBalancerClass cannot be changed after applied". Because of this, following the guide provided to Istio maintainers, we applied the fix using a Helm post-render patch.
- Due to incompatibilities between EKS 1.29 and kubectl\*manifest, we switched to managing the ENI configuration using a kubernetes\*manifest resource, _`Pay attention on upgrade process`_
- AZ Rebalance cannot get the correct ASG name when multi AZ is enabled

### Upgrade

#### Requirements

_`Connect on AWS account`_

_`Connect on EKS that you will upgrade`_

_`Ensure that the upgrade is compatible with your environment bellow command line, run it using istio 1.20.2 or above`_

```
istioctl x precheck
```

Update the variables-ENV.tfvars

```
istio_ingress_loadBalancerSourceRanges = [
  "10.0.0.0/8",
  "100.64.0.0/16",
  "100.65.0.0/16"
]

# AMI table (Please always check the latest version in AWS)
# 1.27 = ami-0fc45f04b46a7cf3f
# 1.28 = ami-0fa04575b2cddfe4a
# 1.29 = ami-0713af20315be3377
ami_bottlerocket = "ami-0713af20315be3377"

```

Set the mandatory tags in `module "experian_eks"` within eks.tf

```
istio_ingress_loadbalancerclass = null
coststring = "1800.BR.640.402057"
appid      = "example-viwer"
```

You can set it as variables if you want :)

#### Command lines

```
ulimit -n unlimited

kubectl patch hpa istio-ingress -p '{"spec":{"minReplicas": 2}}' -n istio-system

kubectl patch deployment istio-ingress -n istio-system -p '{"spec":{"template":{"spec":{"affinity":{"podAntiAffinity":{"requiredDuringSchedulingIgnoredDuringExecution":[{"labelSelector":{"matchExpressions":[{"key":"app","operator":"In","values":["istio-ingress"]}]},"topologyKey":"kubernetes.io/hostname"}]}}}}}}'

kubectl patch deployment istio-ingress -n istio-system  -p '{"spec":{"template":{"metadata":{"labels":{"istio-version":"1.18"}}}}}'

kubectl patch deployment istiod -n istio-system -p '{"spec":{"template":{"spec":{"affinity":{"podAntiAffinity":{"requiredDuringSchedulingIgnoredDuringExecution":[{"labelSelector":{"matchExpressions":[{"key":"app","operator":"In","values":["istiod"]}]},"topologyKey":"kubernetes.io/hostname"}]}}}}}}'

# Wait until all pods in the istio-system namespace are running before continuing.
#
# Helm does not upgrade or delete CRDs when performing an upgrade. Because of this restriction, an additional step is required when upgrading Istio with Helm.
#
# Run make init ENV=env to initialize/fetch/update the new aws-eks. Then, run the following command:
#

kubectl apply -f .terraform/modules/experian_eks/aws-eks/files/istio-1.20.2-crds

#Cordon all infra nodes, the bellow command give all the command needed to do it
kubectl  get node --show-labels | awk ' /node_group_on_demand_infra/ {printf"kubectl cordon %s\n",$1}'

```

**`WARNING:` AWS EKS does not support upgrading more than one version at a time. Therefore, if you are running a different version than 1.28, please take the actions described below.**

- Run all previous steps and additionally change the EKS version in `module "experian_eks"` within eks.tf

```
eks_cluster_version = "1.28" # Where 1.28 is the next AWS EKS version for your environment

```

- Apply terraform, repeat last step until arrive in AWS EKS 1.28, so remove the `eks_cluster_version` put in `module "experian_eks"` and re-run "make apply ENV=env"

### [aws-eks-1.27-v0.0.11](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-eks-1.27-v0.0.10&sourceBranch=refs%2Ftags%2Faws-eks-1.27-v0.0.11) (2024-01-17)

### FIX

- Tags set in eks_managed_node_groups have not been set correctly in the final node group due to issue logic for setting default tags in nodegroup.tf. These tags have now been merged with the default tags.

### WARNING

- This change will recreate all node groups, if the application is not prepared, outage is expected

### [aws-eks-1.27-v0.0.10](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-eks-1.27-v0.0.10&sourceBranch=refs%2Ftags%2Faws-eks-1.27-v0.0.9) (2023-11-21)

### FIX

- By default, the disk size increase will target /dev/xvdb. If you need to increase the size of /dev/xvda instead, make the change directly in the node_group.tf file within your code.

  `/dev/xvda is used to hold the operating system itself and contains the active & passive partitions, the bootloader, the dm-verity data, and the data store for the Bottlerocket API. /dev/xvdb is used for all of the things you run on top of Bottlerocket: container images, storage for running containers, and persistent storage/volumes.`

- Put the terraform-aws-eks-19.15.3 module inside this module. This was needed to fix git clone error in MAC M1

### [aws-eks-1.27-v0.0.9](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faaws-eks-1.27-v0.0.8&sourceBranch=refs%2Ftags%2Faws-eks-1.27-v0.0.9) (2023-11-21)

### Features

- Now you can disable ASG (AWS Scaling Group) AZ re-balance by setting the option "az_rebalance = false" in the node group configuration.

### NOTES

- Once set up "az_rebalance = false", the best way to re-enable it, is creating a new one node group and delete the old

### [aws-eks-1.27-v0.0.8](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faaws-eks-1.27-v0.0.7&sourceBranch=refs%2Ftags%2Faws-eks-1.27-v0.0.8) (2023-10-31)

### Features

- Add the boolean variable istio_ingress_nlb_proxy_enabled to enable or disable the Proxy feature in NLB
- Add the annotation: "service.beta.kubernetes.io/aws-load-balancer-proxy-protocol"
- Envoy filter created

### Fix

- Resolved BUG terraform template_file in arm64 - this function was replaced templatefile

### [aws-eks-1.27-v0.0.7](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faaws-eks-1.27-v0.0.7&sourceBranch=refs%2Ftags%2Faws-eks-1.27-v0.0.6) (2023-10-30)

### Features

- Bucket lifecycle policy setting for 20 days to go to Glacier and 356 days to expire.
- Set force_destroy = false so bucket is not deleted in case of EKS deletion
- Add AppID, CostString and Environment tags

### [aws-eks-1.27-v0.0.6](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faaws-eks-1.27-v0.0.6&sourceBranch=refs%2Ftags%2Faws-eks-1.27-v0.0.5) (2023-10-25)

### Features

- Upgrade ArgoCD version to 2.9.0
- Added test to check check if the version of the ArgoCD is equal the version set up in "coe_argocd_helm_version"

### [aws-eks-1.27-v0.0.5](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faaws-eks-1.27-v0.0.4&sourceBranch=refs%2Ftags%2Faws-eks-1.27-v0.0.5) (2023-08-24)

### Features

- Add variable aws_subnets_experian_filter_tags for additional subnets filter

### [aws-eks-1.27-v0.0.4](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faaws-eks-1.27-v0.0.4&sourceBranch=refs%2Ftags%2Faws-eks-1.27-v0.0.3) (2023-08-21)

### Features

- Add ECR auth for ArgoCD

### [aws-eks-1.27-v0.0.3](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faaws-eks-1.27-v0.0.1&sourceBranch=refs%2Ftags%2Faws-eks-1.27-v0.0.3) (2023-07-21)

### Fix

- Remove Docker proxy from Datalab Nexus

### [aws-eks-1.27-v0.0.2](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faaws-eks-1.27-v0.0.1&sourceBranch=refs%2Ftags%2Faws-eks-1.27-v0.0.2) (2023-07-04)

### Features

- Update documentation about node creation inside coe-default example
- Added group "readonly" to aws-auth

### Fix

- When using custom LT the right place to set disck size is inside the
- Add new extras policies needed by ClusterAutoScaler

### [aws-eks-1.27-v0.0.1](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-eks-1.27-v0.13.0&sourceBranch=refs%2Ftags%2Faws-eks-v0.0.13) (2023-05-29)

### Features

- Upgrade EKS cluster version to 1.27
- Upgrade the Istio version to 1.18.0
- Upgrade Metric Server version to 3.10.0
- Upgrade Cluster Autoscaler version to 9.29.1
- Upgrade External DNS version to 1.13.0
- Upgrade terraform aws-eks version to 19.15.3
- Upgrade DEX helm version to v1.0.0-9-g110984e
- Upgrade AWS-CNI version to v1.13.0-eksbuild.1
- Removed monitoring stack options, this should be installed using an external tool like ArgoCD or yaml files
- Upgrade minimum 4.45
- cluster_name - The cluster_id currently set by the AWS provider is the cluster name, but in the future, this will change and there will be a distinction between the cluster_name and cluster_id so we replace all cluster_id used for cluster_name in our IaC.
- Removed these default variables from the doc example
  - eks_cluster_version
  - metrics_server_version
  - istio_ingress_version
  - external_dns_version
- Add new default_tags_ec2 to set default tag to ec2
- The below variables are deprecated, instead, use default_tags_ec2.
  - resource_business_unit
  - resource_owner
  - resource_name
  - rapid7_tag
  - ad_group
  - ad_domain
  - centrify_unix_role
- Removed variable roles, now to grant access to a new role use aws_auth_roles.
- Removed variable users, now to grant access to new users use aws_auth_users.
- Added new tag to nodes, now they have the Worker = "Node|Infra” tag set in creating time.
- Removed confluence terraform provider
- Add terraform validation and format to make
- Migrated the CNI args configuration from aws-vpc-cni-patch to AWS add-ons
- Migrated eniconfig creating from aws-vpc-cni-patch to kubectl terraform module
- Migrate aws-auth set up from aws-cni-patch to aws-vpc-cni-patch and aws_auth_users, BUAdmnistratorAccessRole is added automatically to admin.
- Removed aws-vpc-cni-patch helm
- AWS Addons, resolve_conflicts_on_update set to "OVERWRITE" by default
- Enhanced the core-default/variables-sandbox.tfvars documentation
- Add new entries to common errors [link](/docs/common-errors.md)
- Put helm and images to the below application in our private ECR
  - External DNS
  - Metrics Server
  - Cluster Autoscaler
- Change naming tag convention, now the tag to this module has the Kubernetes version, ex. aws-eks-1.27-v0.0.1
- Added iam_role_additional_policies to pass additional policies to worker's nodes
- Added aws_cni_configuration_values to set additional configuration to AWS-CNI, AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG is enabled by default

### Fix

- Replace data_template (deprecated) resource by template function
- Fix policies create conflict when launching more than one cluster with the same name
- Added aws_s3_bucket_versioning and aws_s3_bucket_server_side_encryption_configuration to aws_s3_bucket
- Fix tag instance

### [v0.0.13](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-eks-v0.0.12&sourceBranch=refs%2Ftags%2Faws-eks-v0.0.13) (2023-05-29)

### Features

- Add unit test for these resources
  - Node group disk size
  - EKS cluster name

### Fix

- Node disk size is not reflection the amount set up in configuration
- Change environment name for DEV variables in example coe-default
- Change ami to auto in example coe-default

### [v0.0.12](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-eks-v0.0.11&sourceBranch=refs%2Ftags%2Faws-eks-v0.0.12) (2023-03-23)

### Features

- Upgrade argocd-app-installer version to v1.0.0-15-gd3a578b
- Add global values:
  - Name of cluster
  - domain of the AWS account
  - AWS account ID
  - Project name

### Fix

- Update documentation:
  - Remove coe-argocd version from example to prevent clients use old version
  - Update istio annnotation to use external AWS Controller Load Balancer

### [v0.0.11](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-eks-v0.0.11&sourceBranch=refs%2Ftags%2Faws-eks-v0.0.10) (2023-03-16)

### Fix

- Increase random munber to ArgoCD role name
- Update AWS CNI PATCH version to v0.1.6-37
- Delegate random name for argo role to aws_iam_role
- Delegate random name for argo aws secret manager to aws_secretsmanager_secret
- Update coe-argocd helm version to v1.0.0-13-gb6191f6

### [v0.0.10](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-eks-v0.0.9&sourceBranch=refs%2Ftags%2Faws-eks-v0.0.10) (2023-02-15)

### Features

- Added coe-argocd as TF child module
- Added aws-ebs-csi-driver addons
- Added secrets-store-csi-driver and secrets-store-csi-driver-provider-aws in default installation
- Added replica set to min 2 for Istiod, this way can you realize update in the cluster without issues related to PDB
- Added istio_ingress_replica_count to control istio ingress replica set
- Added aws_cni_custom_network to enable or disable AWS CNI Custom network https://docs.aws.amazon.com/eks/latest/userguide/cni-custom-network.html
- Added aws_cni_extra_vars to pass extra vars to AWS CNI
- Moved helm chart aws-vpc-cni-patch and their images to ECR INFRA
- Moved all secret manager, role and policy related with Argo and DEX to their respective module
- Documentation updated
- Added Thumberprint 9E99A48A9960B14926BB7F3B02E22DA2B0AB7280 (C=US, O=Starfield Technologies, Inc., OU=Starfield Class 2 Certification Authority) as default to all OIDC
- Added eks_managed_node_infra_instance_types to change Infra Instancy type, default is m5.large
- Create a local user for SRE auth if dex_static_passwords_hash was set - Just for view
- Add AWS Load Balancer Controller v2.4
- Add Node policy to allow EBS attach EBS
- Replace deprecated aws_subnet_ids by aws_subnets
- For better understood of the code we change the resource these name:
  - "data.aws_subnet_ids.pods" -> "data.aws_subnets.experian"
  - "data.aws_subnet_ids.internal-pods" -> "data.aws_subnets.internal_pods"

### Fix

- Update for new version of aws-vpc-cni-patch:v0.1.6-20-geb39b1c this version fix the bug with process update, like add a new role do EKS Cluster
- Since the new version of 'aws_subnet_ids' (now 'aws_subnets') returns an empty '[]' value when not matching the tag filter, there is no need to use 'count' in the 'data.aws_subnets.experian'."

### [v0.0.9](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-eks-v0.0.65&sourceBranch=refs%2Ftags%2Faws-eks-v0.0.9) (2023-01-11)

### Features

- Add tags used by Brazil cloud Data Governance (https://pages.experian.com/pages/viewpage.action?pageId=1001013241)

### [v0.0.8](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-eks-v0.0.65&sourceBranch=refs%2Ftags%2Faws-eks-v0.0.8) (2022-11-30)

### Features

- Add new rules to POD SG to open the communication to istiod to the sidecar-injector to work.

### [v0.0.7](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-eks-v0.0.65&sourceBranch=refs%2Ftags%2Faws-eks-v0.0.7) (2022-10-26)

### Features

- Add new rules to POD SG, eks_managed_node_group_secondary_additional_rules [More Information](docs/eks-managed-node-group-secondary-additional-rules.md)

### [v0.0.6](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-eks-v0.0.5&sourceBranch=refs%2Ftags%2Faws-eks-v0.0.6) (2022-09-19)

### Features

- Generate documentation file with the below informations:
  - AWS Account
  - Cluster Name
  - K8S Version
  - Cluster AZ Enabled
  - Cluster AMI
  - Cluster Network
  - Grafana
  - Aditionals information can be add using the variable [documention](README.md#input_documention)
  - To enabled this feature is needed set a value to [path_documentation_file](README.md#input_path_documentation_file)

### [v0.0.5](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-eks-v0.0.4&sourceBranch=refs%2Ftags%2Faws-eks-v0.0.5) (2022-09-14)

### Features

- Additional list of server certificate thumbprints for the OpenID Connect (OIDC)

### Bug

When enabling IRSA the module will try to discover the fingerprint of the OIDC URL using the tls_certificate module that connects to the OIDC URL from the machine running the current terraform, when this machine is behind a proxy that replaces SSL for all URL as in our organization the fingerprint will be the proxy and not on the AWS EKS OIDC cluster URL.

As a workaround you need to put the correct fingerprint in the custom_oidc_thumbprints variable, you can get more information on how to do this at this link: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html.

Remember to do this inside AWS or in somewhere that is it not connected using proxy

### [v0.0.4](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-eks-v0.0.4&sourceBranch=refs%2Ftags%2Faws-eks-v0.0.3) (2022-08-22)

### Features

- Additional SG group to all nodes

### [v0.0.3](https://code.experian.local/projects/ESBT/repos/coe-tf-modules/compare/diff?targetBranch=refs%2Ftags%2Faws-eks-v0.0.4&sourceBranch=refs%2Ftags%2Faws-eks-v0.0.2) (2022-08-19)

### Features

- Upgrade Istio Version to 1.14.3

- Upgrade Kubernetes to 1.23

- Upgrade ExternalDNS to 1.11.0

- Upgrade MetricServer to 3.8.2

- Upgrade AWS EKS Terraform module to 18.28.0

- Enable IRSA by default

### Bug Fixed

- When set a Bottlerocket AMi the data AMI auto is set to an alternative name

- Set istio firewall rule with all CIDRS avaiable in the AWS account to enable communication between k8s Api and nodes
