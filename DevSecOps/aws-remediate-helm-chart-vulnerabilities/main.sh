#!/usr/bin/env bash

# /**
# *
# * Este arquivo e parte do launch joaquinx-launch-onboarding
# *
# * @name           apply.sh
# * @version        1.0.0
# * @description    Script que controla o motor de execucao
# * @copyright      2023 &copy Serasa Experian
# *
# * @version        1.0.0
# * @change         - [FEATURE] Criacao e inicializacao do launch;
# * @author         DevSecOps Architecture Brazil
# * @contribution   Fabio Zinato <fabio.zinato@br.experian.com>
# * @dependencies   cockpit_common/common.sh
# * @references     
# * @date           18-Mai-2023
# *
# **/  

# /**
# * Configurações iniciais

# /**
# * Variaveis de parametros
# */

#/**
# * aws_account_id
# * Recebe o parametro de aws_account_id 
# * @var string
# **/
aws_account_id="@@AWS_ACCOUNT_ID@@"

#/**
# * aws_region
# * Recebe o parametro de aws_region
# * @var string
# **/
aws_region="@@AWS_REGION@@"

#/**
# * eks_cluster_name
# * Recebe o parametro de eks_cluster_name 
# * @var string
# **/
eks_cluster_name="@@EKS_CLUSTER_NAME@@"

#/**
# * charts
# * Recebe o parametro de charts
# * @var string
# **/
IFS='; ' read -r -a charts <<< "@@CHARTS@@"


if [ -f bin/common.sh ] ; then
    source bin/common.sh
fi

if [ -f bin/vpa_recommender.sh ] ; then
    source bin/vpa_recommender.sh
fi

if [ -f bin/metrics_server.sh ]  ; then
    source bin/metrics_server.sh
fi

if [ -f bin/kubecost.sh ]  ; then
    source bin/kubecost.sh
fi

# /**
# * Funções
# */

# /**
# * Start
# */

# Forçar para não usar proxy
unset HTTP_PROXY
unset HTTPS_PROXY

log_msg 'main - Initialize launch aws-remediate-helm-chart-vulnerabilities' 'INFO'

log_msg "main - Assuming role BURoleForDevSecOpsCockpitService" "INFO"

ASSUMED_ROLE=$(aws sts assume-role --role-arn arn:aws:iam::$aws_account_id:role/BURoleForDevSecOpsCockpitService --role-session-name DevSecOpsCockpitService --region $aws_region)

if [ $? -ne 0 ];then
    exit 1
fi

export AWS_ACCESS_KEY_ID=$(echo $ASSUMED_ROLE | jq -r '.Credentials''.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $ASSUMED_ROLE | jq -r '.Credentials''.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $ASSUMED_ROLE | jq -r '.Credentials''.SessionToken')

if [ "$(aws sts get-caller-identity | jq -r '.Account')" -eq "${aws_account_id}" ]; then
    log_msg "main - Assumed Role realizado com sucesso." "INFO"
else
    log_msg "main - Ocorreu um erro ao realizar o Assumed Role. Impossivel prosseguir." "ERROR"
fi

log_msg "main - Autenticando no cluster EKS ${eks_cluster_name}" "INFO"

export KUBECONFIG="${eks_cluster_name}.conf"

if ! aws eks update-kubeconfig --name $eks_cluster_name --kubeconfig $KUBECONFIG > /dev/null; then
    log_msg "main - Ocorreu um erro ao gerar o kubeconfig. Impossivel prosseguir." "ERROR"
    exit 1
else
    log_msg "main - Autenticado com sucesso." "INFO"
fi

echo ${charts[@]}

for chart in "${charts[@]}"; do

    case $chart in
        vpa-recommender)
            vpa_recommender
        ;;
        metrics-server)
            metrics_server
        ;;
        kubecost)
            kubecost
        # ;;
        # velero)
        #     velero
    esac

done