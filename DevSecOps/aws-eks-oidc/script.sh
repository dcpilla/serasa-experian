#!/bin/bash

aws_account_id=@@AWS_ACCOUNT_ID@@
aws_region=@@AWS_REGION@@
eks_cluster_name=@@EKS_CLUSTER_NAME@@
oidc_config_name=@@OIDC_CONFIG_NAME@@
oidc_client_id=@@OIDC_CLIENT_ID@@
oidc_issuer_url=@@OIDC_ISSUER_URL@@

echo "Assuming DevSecOpsServiceCatalog role..."

ASSUMED_ROLE=$(aws sts assume-role --role-arn arn:aws:iam::$aws_account_id:role/BURoleForDevSecOpsServiceCatalog --role-session-name DevSecOpsServiceCatalog --region $aws_region)

export AWS_ACCESS_KEY_ID=$(echo $ASSUMED_ROLE | jq -r '.Credentials''.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $ASSUMED_ROLE | jq -r '.Credentials''.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $ASSUMED_ROLE | jq -r '.Credentials''.SessionToken')

echo
echo "Associating new OIDC identity provider..."

aws eks associate-identity-provider-config --region $aws_region --cluster-name $eks_cluster_name --oidc identityProviderConfigName=$oidc_config_name,clientId=$oidc_client_id,issuerUrl=$oidc_issuer_url,usernameClaim=email,groupsClaim=groups