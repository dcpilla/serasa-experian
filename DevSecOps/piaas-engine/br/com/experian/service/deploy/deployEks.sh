#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           deployEks.sh
# * @version        $VERSION
# * @description    Script que faz diferentes tipos de deploy
# * @copyright      2018 &copy Serasa Experian
# *
# * @version        1.0.0
# * @description    [FEATURE] Implementação de suporte da função de deploy para banco de dados;
# * @copyright      2024 &copy Serasa Experian
# * @author         Lucas Carvalho Francoi <lucas.francoi@br.experian.com>
# * @dependencies   common.sh
# *                 eksLib.sh
# *                 helmLib.sh
# * @date           25-march-2024
# *
# **/

# /**
# * Configurações iniciais
# */

# Exit on errors
#set -eu # Liga Debug

# Diretorio base
baseDir="/opt/infratransac/core"

# Carrega commons
test -e "$baseDir"/br/com/experian/utils/common.sh || echo 'Ops, biblioteca common nao encontrada'
source "$baseDir"/br/com/experian/utils/common.sh

# Carrega eksLib
test -e "$baseDir"/br/com/experian/utils/eksLib.sh || echo 'Ops, biblioteca eksLib nao encontrada'
source "$baseDir"/br/com/experian/utils/eksLib.sh

# Carrega helmLib
test -e "$baseDir"/br/com/experian/utils/helmLib.sh || echo 'Ops, biblioteca helmLib nao encontrada'
source "$baseDir"/br/com/experian/utils/helmLib.sh

# /**
# * Variaveis
# */

# /**
# * VERSION
# * Versão do script
# */
VERSION='1.0.0'

# /**
# * TEMP
# * Leitura de opções
# * @var string
# */
TEMP=$(getopt -o t:e:hu --long environment:,help,application-name:,version:,project:,no-delete-image:,tribe:,squad:,safe:,iamUser:,awsAccount:,cluster-name:,aws-region: -n "$0" -- "$@")
eval set -- "$TEMP"

# /**
# * applicationName
# * Nome da aplicacao 
# * @var string
# */
applicationName=''


# /**
# * environment
# * Ambiente para o deploy
# * @var string
# */
environment=''

# /**
# * noDeleteImage
# * Ignorar delete de conteiner no deploy
# * @var string
# */
noDeleteImage='false'

# /**
# * tribe
# * Nome da tribe responsavel pela aplicacao
# * @var string
# */
tribe=''

# /**
# * squad
# * Nome da squad responsavel pela aplicacao
# * @var string
# */
squad=''

# /**
# * safe
# * Nome do cofre
# * @var string
# */
safe=''

# /**
# * iamUser
# * Nome do usuário IAM
# * @var string
# */
iamUser=''

# /**
# * awsAccount
# * ID da conta AWS
# * @var string
# */
awsAccount=''

# /**
# * project
# * Define o projeto de deploy
# * @var string
# */
project=''

# /**
# * version
# * Versao da aplicacao que sera submetida
# * @var string
# */
version=

# /**
# * clusterName
# * Nome do Cluster EKS
# * @var string
# */
clusterName=''

# /**
# * awsRegion
# * Regiao do ECR onde serah salvo a imagem
# * @var string
# */
awsRegion=''

# /**
# * usage
# * Método help do script
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
usage () {
    echo "deployEks.sh version $VERSION - by DevSecOps PaaS Team"
    echo "Copyright (C) 2024 Serasa Experian"
    echo ""
    echo -e "deployEks.sh script para deploy em ambientes EKS .\n"

    echo -e "Usage: deployEks.sh --tribe=nike --squad=accelerators --safe=aws --aws-region=sa-east-1 --project=project-namespace --application-name=app-name --version=1.2.0 --environment=qa --cluster-name=nike-eks-01-uat"

    echo -e "Options
    --application-name          Nome da aplicacao 
    --tribe                     Nome da tribe responsavel pela aplicacao
    --squad                     Nome da squad responsavel pela aplicacao
    --safe                      Nome do cofre
    --iamUser                   Nome do IAM user
    --awsAccount                ID da conta AWS
    --aws-region                Regiao AWS do repositorio ECR para registro da imagem para o EKS
    --cluster-name              Nome do Cluster EKS onde sera realizado o deploy   
    --e, --environment          Ambiente para deploy [de|deeid|hi|hieid|he|pi|pe|peeid|develop|qa|master]
    --version                   Versao da aplicacao
    --no-delete-image           Ignorar delecao da image do conteiner usado no deploy
    --h, --help                 Ajuda"

    exit 1
}


# /**
# * validParameters
# * Método valida quando destino for eks
# * @version 1.0.0
# * @package DevOps
# * @author  gleise teixeira <gleise.teixeira at br.experian dot com>
# */
validParameters () {

    infoMsg 'deployEks.sh : Iniciando validacoes de parametros de deploy para EKS '

    if [ "$environment" == "" ];then
        errorMsg 'deployEks.sh : Para o deploy no EKS e necessario informar o ambiente. Exemplo: --environment=qa'
        exit 1
    fi

    if [ "$project" == "" ];then
        errorMsg 'deployEks.sh : Para o deploy no EKS e necessario informar o projeto (eks namespace). Exemplo: --project=project-namespace'
        exit 1
    fi

    if [ "$applicationName" == "" ];then
        errorMsg 'deployEks.sh : Para o deploy no EKS e necessario informar o nome da aplicacao. Exemplo: --application-name=app-image:latest'
        exit 1
    fi

    if [ "$version" == "" ];then
        errorMsg 'deployEks.sh : Para o deploy no EKS e necessario informar a versao da aplicacao. Exemplo: --version=1.2.0'
        exit 1
    fi

    if [ "$tribe" == "" ];then
        errorMsg 'deployEks.sh : Para o deploy no EKS e necessario informar o nome da tribe. Exemplo: --tribe=nike'
        exit 1
    fi

    if [ "$squad" == "" ];then
        errorMsg 'deployEks.sh : Para o deploy no EKS e necessario informar o nome da squad. Exemplo: --squad=accelerators'
        exit 1
    fi

    if [ "$safe" == "null" ] && [ "$vault" == "null" ];then
        errorMsg 'deployEks.sh : Para o deploy no EKS e necessario informar o nome do cofre. Exemplo: --safe=aws ou --vault=aws'
        exit 1
    fi

    if [ "$clusterName" == "" ];then
        errorMsg 'deployEks.sh : Para o deploy no EKS e necessario informar o nome do Cluster. Exemplo: --cluster-name=cluster-01'
        exit 1
    fi

     if [ "$awsRegion" == "" ];then
        errorMsg 'deployEks.sh : Para o deploy no EKS e necessario informar a regiao AWS do Repositorio ECR. Exemplo: --aws-region=sa-east-1'
        exit 1
    fi

}

# /**
# * Start
# */

# Valida passagem de parametros
if [ $# -eq 1 ];then
    usage
    exit 1
fi

# Extrai opções passadas
while true; do
    case "$1" in
        -t|--target) target=$(echo "$2" | tr '[:upper:]' '[:lower:]'); shift 2;;
        -e|--environment) environment=$(echo "$2" | tr '[:upper:]' '[:lower:]'); shift 2;;
        --application-name) applicationName="$2"; shift 2;;
        --version) version="$2"; shift 2;;
        --project) project="$2"; shift 2;;
        --no-delete-image) noDeleteImage='true'; shift;;
        --tribe) tribe="$2"; shift 2;;
        --squad) squad="$2"; shift 2;;
        --safe) safe="$2"; shift 2;;
        --iamUser) iamUser="$2"; shift 2;;
        --awsAccount) awsAccount="$2"; shift 2;;
        --cluster-name) clusterName="$2"; shift 2;;
        --aws-region) awsRegion="$2"; shift 2;;
        -h|--help) usage;;
        --) shift; break;;
        *) echo "Internal error!"; exit 1;;
    esac
done

# Valida os parametros obrigatorios para EKS
validParameters

# Configuração e deploy
#setProxy
infoMsg 'deployEks.sh : Executando o deploy em EKS'
deploymentsEks $applicationName $version $project $tribe $squad $safe $iamUser $awsAccount $environment $clusterName $awsRegion $noDeleteImage
infoMsg 'deployEks.sh : Sucesso no deploy \o/'