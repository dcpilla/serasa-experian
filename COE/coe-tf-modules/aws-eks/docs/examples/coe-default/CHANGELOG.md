# Changelog

All notable changes to this project will be documented in this file.

### [v0.0.5](https://code.experian.local/projects/CDEAMLO/repos/coe-odin-infra/compare/diff?targetBranch=refs%2Ftags%2Fv0.0.5&sourceBranch=refs%2Ftags%2Fv0.0.4) (2024-02-07)

### Features

- Added new mandatory tags:
  coststring
  appid
- Added global_max_pods_per_node

### Fix

- Comment aws_cni_configuration_values

### [v0.0.4](https://code.experian.local/projects/CDEAMLO/repos/coe-odin-infra/compare/diff?targetBranch=refs%2Ftags%2Fv0.0.3&sourceBranch=refs%2Ftags%2Fv0.0.4) (2023-11-21)

### Features

- Now you can disable ASG (AWS Scaling Group) AZ re-balance by setting the option "az_rebalance = false" in the node group configuration.

### NOTES

- Once set up "az_rebalance = false", the best way to re-enable it, is creating a new one node group and delete the old

### [v0.0.3](https://code.experian.local/projects/CDEAMLO/repos/coe-odin-infra/compare/diff?targetBranch=refs%2Ftags%2Fv0.0.3&sourceBranch=refs%2Ftags%2Fv0.0.2) (2023-01-28)

### Features

- Create file "variables-sandbox-test.tfvars" for exclusive use in test process, we collect the variables inside it to validate environment
- Update source to latest aws-eks module aws-eks-1.27-v0.0.6

### [v0.0.2](https://code.experian.local/projects/CDEAMLO/repos/coe-odin-infra/compare/diff?targetBranch=refs%2Ftags%2Fv0.0.1&sourceBranch=refs%2Ftags%2Fv0.0.2) (2023-01-28)

### Features

- Move Secret Manager and Argo installation to coe-tf-eks module
- Any change that you make in this code\*\*\*

### [v0.0.1](https://code.experian.local/projects/CDEAMLO/repos/coe-odin-infra/compare/diff?targetBranch=refs%2Ftags%2Fv0.0.1&sourceBranch=refs%2Ftags%2Fv0.0.1) (2022-09-15)

### Features

- Automatic Documentation
- coe-tf-modules/aws-eks v0.0.5
- AWS Secrets Manager to setup DEX
- AWS Secrets Manager to store SSH key to Argocd
- Create key pair to ArgoCD
- Create Role to setup DEX and Argocd with AWS Secrets Manager
- New model of documentation
