
  # EKS sandbox Documentation

  Documentation related to this project

  ## Cluster Information

  |Name|URL/ID|OBS|
  |---|---|---|
  |AWS Account |827294527432|Auth OKTA|
  |Cluster Name|mlops-test-02-sandbox|Auth AWS ROLE|
  |K8S Version|1.29| |
  |Cluster AZ Enabled|true|sa-east-1a, sa-east-1b, sa-east-1c|
  |Cluster AMI|ami-0713af20315be3377| |
  |Cluster Network|subnet-0dd070e5d55ba3035, subnet-065df8eb2edcea41e, subnet-0fc7ffed504e890f3| Network Class 10|
  |Grafana|sandbox-mlops.br.experian.eeca|Auth Internal|

  ## Node groups
  |Name|Instance Type|OBS|
  |---|---|---|
 |ng_g54xlarge_gpu_sa-east-1a|g4dn.2xlarge||
|ng_g54xlarge_gpu_sa-east-1b|g4dn.2xlarge||
|ng_g54xlarge_gpu_sa-east-1c|g4dn.2xlarge||
|ng_general_small_sa-east-1a|m5.large; t3.large||
|ng_general_small_sa-east-1b|m5.large; t3.large||
|ng_general_small_sa-east-1c|m5.large; t3.large||
|ng_m5a4xlarge_sa-east-1a|m5a.4xlarge||
|ng_m5a4xlarge_sa-east-1b|m5a.4xlarge||
|ng_m5a4xlarge_sa-east-1c|m5a.4xlarge||
  ## Auth System
  |Name|URL|OBS|
  |---|---|---|
  |ArgoCD|https://deploy-mlops-test-02-sandbox.sandbox-mlops.br.experian.eeca|Auth DEX|
  |Auth|https://auth-mlops-test-02-sandbox.sandbox-mlops.br.experian.eeca/api/dex/|Auth DEX|

  ## Setup Deploy environment

  ### Deploy Pub Key

  ```
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCaoOm9rIt1621VxCmZT6oeQ7w6JB2ukigPdsC6juYzxuWiQuA6ofh8WYZrz9c9zBY68odzVAcO/uVkIvQgMZ0tKf1v2x9mUCEhfYAeMdftiPQM8HquzrhmdOdLbuuNmKdYRc9hg09Lvy6EI5XIWvmTznqhsPubobZYTnXzqRc7Kn2DtNsJChFfjmXrWq65H1bTN2nq249uNx1TcZG+avtCEYCvw/EWuvlpTrXOuCWjIWx4QeKbuyA/d9vFLw8L2/EJBl9MgN2XtAi4Cla+MhkK4Ery7GEUiFHLIDCKlUGG9aY8k3ZJXU6TaUc/c2NoJKvdO7FebFxRZ+Sgc0chVXC5  argocd@mlops-test-02-sandbox
  ```

  ### Deploy ARN to access AWS Secrets Manager

  ``` 
  mlops-test/mlops-test-02/argocd_sandbox-repositories-20240227193005388000000008
  ```

  ### DEX ARN to access AWS Secrets Manager

  ```
  arn:aws:iam::827294527432:role/BURoleForDeployAccessSecretsManager-2024022719301766360000000b
  ```
