
  # EKS dev Documentation

  Documentation related to this project

  ## Cluster Information


  |Name|URL/ID|OBS|
  |---|---|---|
  |AWS Account |294463638235|Auth OKTA|
  |Cluster Name|coe-odin-01-dev|Auth AWS ROLE|
  |K8S Version|1.23| |
  |Cluster AZ Enabled|false|sa-east-1a, sa-east-1b, sa-east-1c|
  |Cluster AMI|ami-0801ca447fd9b4fc0| |
  |Cluster Network|subnet-0972ae13c0239f357, subnet-0cf90eb5086d0cbe3, subnet-0fca9614d2b51cc4d| Network Class 10|
  |Grafana|dev-mlops.br.experian.eeca|Auth Internal|

  ## Node groups
  |Name|Instance Type|OBS|
  |---|---|---|
 |ng_general_larger|m5.2xlarge; t3.2xlarge||
|ng_general_medium|m5.xlarge; t3.xlarge||
|ng_general_small|m5.large; t3.large||
|ng_m5a4xlarge|m5a.4xlarge||
|ng_r5n2xlarge|r5n.2xlarge||
|ng_spot_mixed|t3.large; m5.large; t3.xlarge; m5.xlarge||
  ## Auth System
  |Name|URL|OBS|
  |---|---|---|
  |ArgoCD|https://deploy-coe-odin-01-dev.dev-mlops.br.experian.eeca|Auth DEX|
  |Auth|https://auth-coe-odin-01-dev.dev-mlops.br.experian.eeca/api/dex/|Auth DEX|

  ## Setup Deploy environment

  ### Deploy Pub Key

  ```
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4snlx3snA6QNCr61rXK/Lp11suIKpIkcsqRUEHUlf/w4FrkNd90N5RWCslxu0NR2k4BeErTE93pFq220bx0N477OoBJmJs+gO9vnEt2r/i6xT6hPedTbgwFWgRV1yIgsHf4XvBtrWwGRiHxHHDrBpmEjdMWYreRoA1H5J6P9/2UURcG5m4lUCPeZh3SLKfIamvo2YxmYEgjHoeEbMU0NUumFdmbAhxhOPYlCIbP6iafbQL26Hp50qJ5T9z2+RVaPCyLfj55WEXnwus9/1D1l2dXeVIcXsq2pubGgP5d2BOsNIHYuoS9V8SUTvERWSM627eciWvXhz3OWdV0GydEh3  argocd@coe-odin-01-dev"
  ```

  ### Deploy ARN to access AWS Secrets Manager

  ``` 
  arn:aws:iam::294463638235:role/BURoleForDeployAccessSecretsManager
  ```

  ### DEX ARN to access AWS Secrets Manager

  ```
  arn:aws:iam::294463638235:role/BURoleForDexAccessSecretsManager
  ```
