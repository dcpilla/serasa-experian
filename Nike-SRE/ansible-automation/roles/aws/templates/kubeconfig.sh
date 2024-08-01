#!/bin/bash

aws_region='{{account_region}}'
aws_account_id='{{account_id}}'
eks_cluster_name='{{eks_name}}'
kubeconfig_enabled='{{kubeconfig_enabled}}'

if [ "$kubeconfig_enabled" = false ]; then
    return 0
fi

echo "Assuming DevSecOpsServiceCatalog role..."

#ASSUMED_ROLE=$(aws sts assume-role --role-arn arn:aws:iam::$aws_account_id:role/BUAdministratorAccessRole --role-session-name DevSecOpsCockpitService --region $aws_region --profile='{{account}}')

#export AWS_ACCESS_KEY_ID=$(echo $ASSUMED_ROLE | jq -r '.Credentials''.AccessKeyId')
#export AWS_SECRET_ACCESS_KEY=$(echo $ASSUMED_ROLE | jq -r '.Credentials''.SecretAccessKey')
#export AWS_SESSION_TOKEN=$(echo $ASSUMED_ROLE | jq -r '.Credentials''.SessionToken')

export AWS_ACCESS_KEY_ID='{{assumed_role_ak}}'
export AWS_SECRET_ACCESS_KEY='{{assumed_role_sk}}'
export AWS_SESSION_TOKEN='{{assumed_role_token}}'
echo
echo "Creating KUBECONFIG for cluster $eks_cluster_name..."
/usr/local/bin/aws eks update-kubeconfig --name $eks_cluster_name --profile='{{account}}' --region=$aws_region

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN

echo
echo "Exporting KUBECONFIG as $HOME/.kube/config..."
export KUBE_CONFIG_PATH=$HOME/.kube/config
