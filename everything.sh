#!/bin/bash

time_now_is() {
    echo -e "\nTime now is $(date +%Y-%m-%dT%T%z)\n"
}
time_now_is

### BEGIN extracted from aws-eks-docker-hub-cache
export aws_account_id=@@AWS_ACCOUNT_ID@@

function check_and_enter_lock() {
    while true; do
        if [ -f $PID_LOCK_FILE ]; then
            if [ "$(cat $PID_LOCK_FILE)" != "$$" ]; then
                export LOCK_RESULT="WAIT"
            fi
        else
            echo $$ > $PID_LOCK_FILE
            export LOCK_RESULT="OK"
        fi

        if [ "$LOCK_RESULT" == "OK" ]; then
            echo "Lock adquirido, prosseguindo..."
            break
        else
            echo "Outra pessoa está rodando a automação, aguardando $1 segundos para testar novamente..."
            sleep $1
        fi
    done
}

function leave_lock() {
    unset LOCK_RESULT
    echo "Leaving file-based ($PID_LOCK_FILE) lock"
    rm -rvf $PID_LOCK_FILE
}

function login_aws() {
    export AWS_REGION=$2
    ASSUMED_ROLE=$(aws sts assume-role --role-arn arn:aws:iam::$1:role/BURoleForDevSecOpsCockpitService --role-session-name DevSecOpsCockpitService --region $2)
    export AWS_ACCESS_KEY_ID=$(echo $ASSUMED_ROLE | jq -r '.Credentials''.AccessKeyId')
    export AWS_SECRET_ACCESS_KEY=$(echo $ASSUMED_ROLE | jq -r '.Credentials''.SecretAccessKey')
    export AWS_SESSION_TOKEN=$(echo $ASSUMED_ROLE | jq -r '.Credentials''.SessionToken')
    aws sts get-caller-identity
}

function logout_aws() {
    unset AWS_REGION AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
}

function pull_from_cache_to_account_ecr() {
    export REGION="@@AWS_REGION@@"

    # Phase 0: Check if any image:tag already exists
    login_aws "$aws_account_id" "@@AWS_REGION@@"
    cat docker-images.list | ./pull-through-cache.py
    logout_aws

    # All images as USER/REPO:TAG from Docker Hub (if only REPO, add "library" as USER)
    export IMAGE_LIST="$(cat docker-images-to-pull.list)"

    # Only goes to phase 2 if downloaded successfully
    export PHASE2_LIST=""

    # Phase 1: Cache all images locally
    login_aws $1 $2

    aws ecr get-login-password --region $2 | docker login --username AWS --password-stdin $1.dkr.ecr.$2.amazonaws.com

    for image in $IMAGE_LIST; do
        docker image pull $1.dkr.ecr.$2.amazonaws.com/docker-hub/$image
        if [ "$?" -eq "0" ]; then
            export PHASE2_LIST="$PHASE2_LIST $image"
        fi 
    done

    logout_aws

    # Phase 2: Send all images to account's ECR
    login_aws "$aws_account_id" "@@AWS_REGION@@"

    # for repo in $(echo $PHASE2_LIST | sed -e 's/:[a-z0-9\.]\+//g'); do
    #     echo "Criando repositorio $repo, ignore erro caso ja exista"
    #     aws ecr create-repository --repository-name docker-hub/$repo --image-tag-mutability MUTABLE --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=AES256
    # done

    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $aws_account_id.dkr.ecr.$AWS_REGION.amazonaws.com

    for image in $PHASE2_LIST; do
        docker image tag $1.dkr.ecr.$2.amazonaws.com/docker-hub/$image $aws_account_id.dkr.ecr.$AWS_REGION.amazonaws.com/docker-hub/$image
        docker image push $aws_account_id.dkr.ecr.$AWS_REGION.amazonaws.com/docker-hub/$image
        docker image rm $1.dkr.ecr.$2.amazonaws.com/docker-hub/$image $aws_account_id.dkr.ecr.$AWS_REGION.amazonaws.com/docker-hub/$image
    done

    logout_aws

    unset REGION
}

rm -vf /tmp/aws-eks-docker-hub-cache.lock

export DOCKERHUB_CACHE_PREFIX="@@DOCKER_HUB_CACHE_PREFIX@@"
if [ "$DOCKERHUB_CACHE_PREFIX" == "own" ]; then
    # export PID_LOCK_FILE=/tmp/aws-eks-docker-hub-cache.lock
#     check_and_enter_lock 15
    pull_from_cache_to_account_ecr 575206002933 sa-east-1
#     leave_lock
fi

### END

GIT_BRANCH=$(git branch)
echo "Current branch is ${GIT_BRANCH}"

aws sts get-caller-identity
python3 ./pre-flight.py || exit 1

pushd ./repo-sre-amazon-eks
set -x
CURRENT_BRANCH=$(echo -n "${GIT_BRANCH}" | grep -G ^* | sed -e 's@^* @@')
if [[ "${CURRENT_BRANCH}" == "homolog" || "${CURRENT_BRANCH}" == "master" ]]; then
    git fetch origin
    git checkout frontend-${CURRENT_BRANCH}
    git describe
fi
set +x
replace variables/catalog.tfvars,backend-config/catalog.tfvars,variables.tf

export REPOTAG=$(git describe)
sed -i variables/catalog.tfvars -e 's@__REPO_VERSION__@'"$REPOTAG"'@'
unset REPOTAG

echo -e -n "This is your TFVARS for init:\n\n"
cat backend-config/catalog.tfvars
echo -e -n "\n\nThis is your TFVARS for plan/apply:\n\n"
cat variables/catalog.tfvars 
echo -e -n "\n"
popd

export AWS_REGION=@@AWS_REGION@@ ACCOUNT_ID=@@AWS_ACCOUNT_ID@@ CLUSTER_NAME=@@EKS_CLUSTER_NAME@@-@@ENV@@ KUBECONFIG_ENABLED=@@KUBECONFIG_ENABLED@@

echo "Assuming DevSecOpsServiceCatalog role..."

login_aws "$ACCOUNT_ID" "$AWS_REGION"

aws eks describe-cluster --name $CLUSTER_NAME >/dev/null
CLUSTER_EXISTS_RETCODE=$?
if [ "$CLUSTER_EXISTS_RETCODE" -eq "0" ]; then
    echo "You have an active cluster with provided name. Proceeding with KUBECONFIG setup (if selected)."

    # Usaremos no segundo bloco
    export OIDC_ISSUER=$(aws eks describe-cluster --region $AWS_REGION --name $CLUSTER_NAME | jq '.cluster.identity.oidc.issuer' -r)

    # exportando KUBECONFIG para helm e kubectl
    export KUBECONFIG=~/aws-eks-serasa.kubeconfig
    echo "Creating KUBECONFIG for cluster $CLUSTER_NAME..."
    aws eks update-kubeconfig --name $CLUSTER_NAME --kubeconfig $KUBECONFIG

#     # Debug do script microgateway secret
#     pushd ./repo-sre-amazon-eks
#     chmod +x -v scripts/get_current.sh
#     scripts/get_current.sh $CLUSTER_NAME
#     cat << EOF | python3 scripts/edgemicro.py
# {
#     "aws_account":"$ACCOUNT_ID",
#     "aws_region":"$AWS_REGION",
#     "cluster_name":"$CLUSTER_NAME",
#     "edgecli_username":"",
#     "edgecli_password":"",
#     "apigee_username":"",
#     "apigee_password":"",
#     "apigee_org":"",
#     "apigee_env":""
# }
# EOF
#     popd

    # Adds this account's role to aws-auth
    echo "Downloading eksctl..."
    ./eksctl-install.sh || exit 1
    echo "Granting BURoleForDevSecOpsCockpitService of 707064604759 to existing cluster..."
    ./eksctl create iamidentitymapping --cluster $CLUSTER_NAME --arn arn:aws:iam::707064604759:role/BURoleForDevSecOpsCockpitService --username admin --group system:masters --no-duplicate-arns || { 
        echo -e "Do you have arn:aws:iam::$ACCOUNT_ID:role/BURoleForDevSecOpsCockpitService present at your ConfigMap kube-config/aws-auth? Please check and do so like below:\n\n"
cat << EOF
apiVersion: v1
data:
  mapRoles: |
    ...
    - groups:
      - system:masters
      rolearn: arn:aws:iam::YOUR_ACCOUNT_ID_HERE:role/BURoleForDevSecOpsCockpitService
      username: admin
    ...
EOF
        exit 1
    }
else
    echo "You don't have an active cluster with provided name, further operation with KUBECONFIG will NOT be set up."
fi

logout_aws

unset AWS_REGION
aws sts get-caller-identity

pushd ./repo-sre-amazon-eks
time_now_is
terraform init -backend-config=backend-config/catalog.tfvars -reconfigure || exit 1
time_now_is

if [ "$CLUSTER_EXISTS_RETCODE" -eq "0" ]; then
    # backup of ENIConfigs and checking for aws-vpc-cni-patch to be removed
    echo "--- backup of ENIConfigs - begin"
    kubectl --kubeconfig $KUBECONFIG get eniconfig -o yaml || exit 1
    echo "--- backup of ENIConfigs - end"

    helm --kubeconfig $KUBECONFIG history -n kube-system aws-vpc-cni-patch
    if [ "$?" -eq "0" ]; then
        helm --kubeconfig $KUBECONFIG uninstall -n kube-system aws-vpc-cni-patch
        terraform state list | grep "helm_release.aws-vpc-cni-patch"
        if [ "$?" -eq "0" ]; then
            terraform state rm helm_release.aws-vpc-cni-patch
        fi
    fi

    terraform state list | grep "helm_release.apigee-microgateway"
    if [ "$?" -eq "0" ]; then
        terraform state rm helm_release.apigee-microgateway
    fi

    #OIDC_ISSUER=$(aws eks describe-cluster --region $AWS_REGION --name $CLUSTER_NAME | jq '.cluster.identity.oidc.issuer' -r)
    if [ "${OIDC_ISSUER}" != "null" ]; then
        # https://oidc.eks.sa-east-1.amazonaws.com/id/97F6EF66E9947FC944AAE15CCE9F2538
        # arn:aws:iam::575206002933:oidc-provider/oidc.eks.sa-east-1.amazonaws.com/id/97F6EF66E9947FC944AAE15CCE9F2538
        OIDC_ARN=$(echo -n ${OIDC_ISSUER} | sed -e 's@https://@arn:aws:iam::'"$ACCOUNT_ID"':oidc-provider/@')

        terraform state list | grep "aws_iam_openid_connect_provider.cluster"
        if [ "$?" -ne "0" ]; then
            terraform import --var-file=variables/catalog.tfvars aws_iam_openid_connect_provider.cluster ${OIDC_ARN}
        fi
    fi

    if [ "$KUBECONFIG_ENABLED" = true ]; then
        echo -e "\nKUBECONFIG was selected in the form, exporting KUBECONFIG as $KUBECONFIG..."
        export KUBE_CONFIG_PATH=$KUBECONFIG
    fi
fi

time_now_is
terraform plan --var-file=variables/catalog.tfvars -out plan || exit 1
time_now_is
terraform apply plan || exit 1
time_now_is

rm -vf $KUBECONFIG
unset KUBECONFIG

popd