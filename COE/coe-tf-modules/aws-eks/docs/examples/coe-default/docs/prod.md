
  # EKS prod Documentation

  Documentation related to this project

  ## Cluster Information

  |Name|URL/ID|OBS|
  |---|---|---|
  |AWS Account |221992887590|Auth OKTA|
  |Cluster Name|coe-data-platform-01-prod|Auth AWS ROLE|
  |K8S Version|1.23| |
  |Cluster AZ Enabled|false|sa-east-1a, sa-east-1b, sa-east-1c|
  |Cluster AMI|ami-0d44d79637601288e| |
  |Cluster Network|subnet-024bcf28858077946, subnet-04ae7a7ec18659b7d, subnet-0da8a217c0ac4d353| Network Class 10|
  |Grafana|corp-data.br.experian.eeca|Auth Internal|

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
  |ArgoCD|https://deploy-coe-data-platform-01-prod.corp-data.br.experian.eeca|Auth DEX|
  |Auth|https://auth-coe-data-platform-01-prod.corp-data.br.experian.eeca/api/dex/|Auth DEX|

  ## Setup Deploy environment

  ### Deploy Pub Key

  ```
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQvdiEtOW681+RPeSD8bsYzYCNx54f66dHHLt/Lho0lWKSRp7qWaXqQE6Xhbt+QtarsV0TSvMZ18HFFm4U9Z9jVjDirxydUteSJuWITRqusyUk1rRdQlvB4/0xD3AAl2LnEBpJkszaIOUGW/V4JNz5D3I1VDe+Pdn80UcljCoZYPblaJYw8zuDVKHFekQnpsY7nLUQCzJ5u1NVN1tQ+BdfYkrPLLlluOYF6Tz+qnHZUPjik6y1sEcp3A4UoJhMGQD8z7lmjL5MpcN18oWmi7EIxq8R9lxnNShAGq3xM7CPE5LXOkklA99amFexCYb/ITDewOHUdNBrkmAfqcezxuWV  argocd@coe-data-platform-01-prod
  ```

  ### Deploy ARN to access AWS Secrets Manager

  ``` 
  coe-data-platform/coe-data-platform-01/argocd_prod-repositories
  ```

  ### DEX ARN to access AWS Secrets Manager

  ```
  arn:aws:iam::221992887590:role/BURoleForDeployAccessSecretsManager-11
  ```
