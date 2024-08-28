
  # EKS uat Documentation

  Documentation related to this project

  ## Cluster Information

  |Name|URL/ID|OBS|
  |---|---|---|
  |AWS Account |201085490967|Auth OKTA|
  |Cluster Name|coe-odin-01-uat|Auth AWS ROLE|
  |K8S Version|1.23| |
  |Cluster AZ Enabled|false|sa-east-1a, sa-east-1b, sa-east-1c|
  |Cluster AMI|ami-05f57f4048b3c84d7| |
  |Cluster Network|subnet-04847e4826bb25146, subnet-0d50816d51611a01f, subnet-0e9514077e7756fa3| Network Class 10|
  |Grafana|uat-mlops.br.experian.eeca|Auth Internal|

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
  |ArgoCD|https://deploy-coe-odin-01-uat.uat-mlops.br.experian.eeca|Auth DEX|
  |Auth|https://auth-coe-odin-01-uat.uat-mlops.br.experian.eeca/api/dex/|Auth DEX|

  ## Setup Deploy environment

  ### Deploy Pub Key

  ```
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCcVijQpqTvMT/oE0J2EDjs7GiwE6DywDV+kaBRNZ0fC22sHxo/xA4tj3bqbwZiNQg4ZYUnI6o3qWGOCJbm2fDJcXAcN8nYkOOGupQ4k7DdwEtf6i9YG20fdUJK4n6l5E18Ueg8mFsnZR3vVRUl/kU83IeZdKeIIkPMa8zNUz2F4mRRpX+vhHZX++Ly5Kr14kyOqbv9LucTmnOZGhMxHdDOs/NJ/oKcm20m9hpe8jae2eJdp1r/GNfBEuaHrlAPF9TLm66V6YOgmyDR2lK284m9hXifeMhaHY0JnYTfiDmBv7gynhNGY+KKf1c/Iz2mnhW/OQTVxjDzZi9rNU6Hp5Pz  argocd@coe-odin-01-uat"
  ```

  ### Deploy ARN to access AWS Secrets Manager

  ``` 
  arn:aws:iam::201085490967:role/BURoleForDeployAccessSecretsManager
  ```

  ### DEX ARN to access AWS Secrets Manager

  ```
  arn:aws:iam::201085490967:role/BURoleForDexAccessSecretsManager
  ```
