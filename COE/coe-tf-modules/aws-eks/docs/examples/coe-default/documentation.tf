locals {
  documention = <<EOF
  ## Auth System
  |Name|URL|OBS|
  |---|---|---|
  |ArgoCD|${module.experian_eks.argo_url}|Auth DEX|
  |Auth|${module.experian_eks.auth_url}|Auth DEX|

  ## Setup Deploy environment

  ### Deploy Pub Key

  ```
  ${module.experian_eks.deploy_pub_key}
  ```

  ### Deploy ARN to access AWS Secrets Manager

  ``` 
  ${module.experian_eks.deploy_aws_secrets_manager}
  ```

  ### DEX ARN to access AWS Secrets Manager

  ```
  ${module.experian_eks.deploy_iam_role_arn}
  ```
  EOF
}
