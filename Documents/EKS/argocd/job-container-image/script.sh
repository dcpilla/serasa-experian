#!/bin/bash

aws_account_id=293242179596
aws_region=sa-east-1

echo
echo "Assuming role BURoleForSREGitOps

ASSUMED_ROLE=$(aws sts assume-role --role-arn arn:aws:iam::$aws_account_id:role/BURoleForSREGitOps --role-session-name BURoleForSREGitOps --region $aws_region)
if [ $? -ne 0 ];then
  exit 1
fi

export AWS_ACCESS_KEY_ID=$(echo $ASSUMED_ROLE | jq -r '.Credentials''.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $ASSUMED_ROLE | jq -r '.Credentials''.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $ASSUMED_ROLE | jq -r '.Credentials''.SessionToken')

echo
echo "Authenticating Kubeconfig in Amazon EKS..."

aws eks update-kubeconfig --name $eks_cluster_name --kubeconfig $eks_cluster_name.conf --region $aws_region
if [ $? -ne 0 ];then
  exit 1
fi



