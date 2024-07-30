#!/bin/bash
# Description: Run command to setup the EKS cluster
# Author: Diego Rodrigues <diego.rodrigues@br.experian.com>
#         Cristian Alexandre <cristian.alexandre@br.experian.com>
# Version: 0.1.5
set -e

function help_message(){

    echo -e "
    $(basename $0) -r [-h -help]

    -r List of role to auth in EKS cluster
    -u List of users to auth in EKS cluster
    -i AWS account id
    -c Apply AWS CNI Patch
    -h|--help show this messages
    "
    exit 0
}

# Patch AWS CNI
function apply_cni_patch(){
    kubectl set env daemonset aws-node -n kube-system AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG=true
    kubectl set env daemonset aws-node -n kube-system ENI_CONFIG_LABEL_DEF=topology.kubernetes.io/zone
    kubectl set env daemonset aws-node -n kube-system ENABLE_PREFIX_DELEGATION=true
    kubectl set env daemonset aws-node -n kube-system WARM_PREFIX_TARGET=1
    kubectl set env daemonset aws-node -n kube-system WARM_IP_TARGET-
    kubectl set env daemonset aws-node -n kube-system MINIMUM_IP_TARGET-
}

function add_roles_to_auth(){
    local roles=($(tr -d [] <<< $1))
    local accountId=$2
    local roleConfigMap=""

    kubectl get -n kube-system configmap/aws-auth -o yaml > /tmp/aws-auth.yml
    
    for role in ${roles[@]}
    do
        roleConfigMap="$roleConfigMap    - groups:\n      - system:masters\n      rolearn: arn:aws:iam::${accountId}:role/${role}\n      username: admin\n"
    done

    cat /tmp/aws-auth.yml | awk "/mapRoles: \|/{print;print \"${roleConfigMap}\";next}1" > /tmp/aws-auth-patch.yml
    cat /tmp/aws-auth-patch.yml
    echo ""

    kubectl patch configmap/aws-auth -n kube-system --patch-file /tmp/aws-auth-patch.yml

    rm -f /tmp/*.yml
}

function add_users_to_auth(){
    local users=($(tr -d [] <<< $1))
    local accountId=$2
    local userConfigMap=""

    kubectl get -n kube-system configmap/aws-auth -o yaml > /tmp/aws-auth.yml
    
    for user in ${users[@]}
    do
        userConfigMap="$userConfigMap    - groups:\n      - system:masters\n      userarn: arn:aws:iam::${accountId}:user/${user}\n      username: ${user}\n"
    done

    cat /tmp/aws-auth.yml | awk "/^data:$/{print;print \"  mapUsers: |\n${userConfigMap}\";next}1" > /tmp/aws-auth-patch.yml
    cat /tmp/aws-auth-patch.yml
    echo ""

    kubectl patch configmap/aws-auth -n kube-system --patch-file /tmp/aws-auth-patch.yml

    rm -f /tmp/*.yml
}

while getopts 'r:u:i:c' args
do
    case $args in
    r) role=$OPTARG
        ;;
    u) user=$OPTARG
        ;;
    i) accountId=$OPTARG
        ;;
    c) cniPath=true
        ;;
    h) help_message
        ;;
    esac
done

[ -n "$role" -a -n "$user" -a -z "$accountId" ] && help_message 

if [ -n "$role" ]; then
    add_roles_to_auth "${role}" "${accountId}"
    [ "$?" -ne 0 ] && exit $?
fi
if [ -n "$user" ]; then
    add_users_to_auth "${user}" "${accountId}"
    [ "$?" -ne 0 ] && exit $?
fi
if [ "${cniPath}" == true ]; then
    apply_cni_patch
    [ "$?" -ne 0 ] && exit $?
fi
exit 0