#!/bin/bash

aws_region=@@AWS_REGION@@
aws_account_id=@@AWS_ACCOUNT_ID@@
eks_cluster_name=@@EKS_CLUSTER_NAME@@
eks_namespace=@@EKS_NAMESPACE@@
eks_deployment_name=@@EKS_DEPLOYMENT_NAME@@
eks_rollouts_command=@@EKS_ROLLOUTS_COMMAND@@


echo
echo "Assuming role BURoleForDevSecOpsCockpitService..."

ASSUMED_ROLE=$(aws sts assume-role --role-arn arn:aws:iam::$aws_account_id:role/BURoleForDevSecOpsCockpitService --role-session-name DevSecOpsCockpitService --region $aws_region)
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


echo
echo "Checking rollouts exists..."

kubectl argo rollouts get rollouts $eks_deployment_name -n $eks_namespace --kubeconfig $eks_cluster_name.conf
if [ $? -ne 0 ];then
  exit 1
fi


echo
echo "Rollouts command executing..."

execute_command() {
    command=$1
    echo "Executando: $command"
    eval $command
    if [ $? -ne 0 ]; then
        echo "Erro ao executar: $command"
        exit 1
    fi
}

# Valida e executa o comando apropriado
case $eks_rollouts_command in
    pause)
        execute_command "kubectl argo rollouts pause $eks_deployment_name -n $eks_namespace --kubeconfig $eks_cluster_name.conf"
        ;;
    abort)
        execute_command "kubectl argo rollouts abort $eks_deployment_name -n $eks_namespace --kubeconfig $eks_cluster_name.conf"
        ;;
    promote)
        execute_command "kubectl argo rollouts promote $eks_deployment_name -n $eks_namespace --kubeconfig $eks_cluster_name.conf"
        ;;
    promote-full)
        execute_command "kubectl argo rollouts promote $eks_deployment_name --full -n $eks_namespace --kubeconfig $eks_cluster_name.conf"
        ;;
    retry)
        execute_command "kubectl argo rollouts retry rollout $eks_deployment_name -n $eks_namespace --kubeconfig $eks_cluster_name.conf"
        ;;
    retry-experiment)
        execute_command "kubectl argo rollouts retry experiment $eks_deployment_name -n $eks_namespace--kubeconfig $eks_cluster_name.conf"
        ;;
    *)
        echo "Comando inválido: $rollouts_command"
        exit 1
        ;;
esac

rm -f ${eks_cluster_name}.conf

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN