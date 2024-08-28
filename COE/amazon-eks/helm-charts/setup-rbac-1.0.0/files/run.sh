#!/bin/bash

set -e

function help_message(){

    echo -e "
    $(basename $0) -r [-h -help]

    -n List of node roles to auth in EKS cluster
    -r List of roles to auth in EKS cluster
    -u List of users to auth in EKS cluster
    -i AWS account id
    -h|--help show this messages
    "
    exit 0
}

function add_noderoles_to_auth(){
    local nodeRoles=($(tr -d [] <<< $1))
    local accountId=$2
    local roleConfigMap=""

    kubectl get -n kube-system configmap/aws-auth -o yaml > /tmp/aws-auth.yml

    for role in ${nodeRoles[@]}
    do
        roleConfigMap="$roleConfigMap    - groups:\n      - system:bootstrappers\n      - system:nodes\n      rolearn: arn:aws:iam::${accountId}:role/${role}\n      username: system:node:{{EC2PrivateDNSName}}\n"
    done

    cat /tmp/aws-auth.yml | awk "/mapRoles: \|/{print;print \"${roleConfigMap}\";next}1" > /tmp/aws-auth-patch.yml
    cat /tmp/aws-auth-patch.yml
    echo ""

    kubectl patch configmap/aws-auth -n kube-system --patch-file /tmp/aws-auth-patch.yml

    rm -f /tmp/*.yml
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

while getopts 'nrui' args
do
    case $args in
    n) nodeRole=$OPTARG
        echo "-n param detected, $nodeRole"
        ;;
    r) role=$OPTARG
        echo "-r param detected, $role"
        ;;
    u) user=$OPTARG
        echo "-u param detected, $user"
        ;;
    i) accountId=$OPTARG
        echo "-i param detected, $accountId"
        ;;
    h) help_message
        ;;
    esac
done

[ -n "$role" -a -n "$user" -a -z "$accountId" ] && help_message

if [ -n "$nodeRole" ]; then
    echo "Will add nodeRoles to ConfigMap"
    add_noderoles_to_auth "${nodeRole}" "${accountId}"
    [ "$?" -ne 0 ] && exit $?
fi
if [ -n "$role" ]; then
    echo "Will add roles to ConfigMap"
    add_roles_to_auth "${role}" "${accountId}"
    [ "$?" -ne 0 ] && exit $?
fi
if [ -n "$user" ]; then
    echo "Will add users to ConfigMap"
    add_users_to_auth "${user}" "${accountId}"
    [ "$?" -ne 0 ] && exit $?
fi

exit 0
