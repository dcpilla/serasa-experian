#!/bin/bash

time_now_is() {
    echo -e "\nTime now is $(date +%Y-%m-%dT%T%z)\n"
}

time_now_is

echo -e -n "This is your TFVARS for init:\n\n"
cat '{{repo_files}}'repo-sre-amazon-eks/backend-config/catalog.tfvars
echo -e -n "\n\nThis is your TFVARS for plan/apply:\n\n"
cat '{{repo_files}}'repo-sre-amazon-eks/variables/catalog.tfvars 
echo -e -n "\n"

aws sts get-caller-identity

echo 'runing {{repo_files}}pre-flight.py'
python3 '{{repo_files}}'pre-flight.py || exit 1

aws_region='{{account_region}}'
aws_account_id='{{account_id}}'
eks_cluster_name='{{eks_name}}'
kubeconfig_enabled='{{kubeconfig_enabled}}'

echo "Assuming DevSecOpsServiceCatalog role..."

#ASSUMED_ROLE=$(aws sts assume-role --role-arn arn:aws:iam::$aws_account_id:role/BURoleForDevSecOpsCockpitService --role-session-name DevSecOpsCockpitService --region $aws_region)

#export AWS_ACCESS_KEY_ID=$(echo $ASSUMED_ROLE | jq -r '.Credentials''.AccessKeyId')
#export AWS_SECRET_ACCESS_KEY=$(echo $ASSUMED_ROLE | jq -r '.Credentials''.SecretAccessKey')
#export AWS_SESSION_TOKEN=$(echo $ASSUMED_ROLE | jq -r '.Credentials''.SessionToken')
export AWS_REGION=$aws_region

export AWS_ACCESS_KEY_ID='{{assumed_role_ak}}'
export AWS_SECRET_ACCESS_KEY='{{assumed_role_sk}}'
export AWS_SESSION_TOKEN='{{assumed_role_token}}'

aws sts get-caller-identity --profile='{{account}}'

aws eks describe-cluster --name $eks_cluster_name --profile='{{account}}' >/dev/null
CLUSTER_EXISTS_RETCODE=$?

echo $CLUSTER_EXISTS_RETCODE

if [ "$CLUSTER_EXISTS_RETCODE" -eq "0" ]; then
    echo "You have an active cluster with provided name. Proceeding with KUBECONFIG setup (if selected)."

    echo "Creating KUBECONFIG for cluster $eks_cluster_name..."
    aws eks update-kubeconfig --name $eks_cluster_name --profile='{{account}}'

    # Adds this account's role to aws-auth
    echo "Downloading eksctl..."
    '{{repo_files}}'eksctl-install.sh || exit 1
    echo "Granting BURoleForDevSecOpsCockpitService of 707064604759 to existing cluster..."
    ./eksctl create iamidentitymapping --cluster $eks_cluster_name --arn arn:aws:iam::707064604759:role/BURoleForDevSecOpsCockpitService --username admin --group system:masters --no-duplicate-arns || exit 1
else
    echo "You don't have an active cluster with provided name, further operation with KUBECONFIG will NOT be set up."
fi

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
unset AWS_REGION
aws sts get-caller-identity

time_now_is

terraform -chdir='{{repo_files}}'repo-sre-amazon-eks init -backend-config=backend-config/catalog.tfvars -reconfigure || exit 1

time_now_is

if [ "$CLUSTER_EXISTS_RETCODE" -eq "0" ]; then
    # backup of ENIConfigs and checking for aws-vpc-cni-patch to be removed
    echo "--- backup of ENIConfigs - begin"
    kubectl --kubeconfig $HOME/.kube/config get eniconfig -o yaml || exit 1
    echo "--- backup of ENIConfigs - end"
    helm --kubeconfig $HOME/.kube/config history -n kube-system aws-vpc-cni-patch
    if [ "$?" -eq "0" ]; then
        helm --kubeconfig $HOME/.kube/config uninstall -n kube-system aws-vpc-cni-patch
        terraform state list | grep "helm_release.aws-vpc-cni-patch"
        if [ "$?" -eq "0" ]; then
            terraform state rm helm_release.aws-vpc-cni-patch
        fi
    fi

    if [ "$kubeconfig_enabled" = true ]; then
        echo -e "\nKUBECONFIG was selected in the form, exporting KUBECONFIG as $HOME/.kube/config..."
        export KUBE_CONFIG_PATH=$HOME/.kube/config
    fi
fi

time_now_is

terraform -chdir='{{repo_files}}'repo-sre-amazon-eks apply --var-file=variables/catalog.tfvars -auto-approve || exit 1

time_now_is
