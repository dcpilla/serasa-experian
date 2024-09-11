#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           cloudfront.sh
# * @version        1.0.0
# * @description    Executa acoes no CloudFront
# * @copyright      2022 &copy Serasa Experian
# *
# **/

# Diretorio base
baseDir="/opt/infratransac/core"

# Carrega commons
test -e "$baseDir"/br/com/experian/utils/common.sh || echo 'Ops, biblioteca common nao encontrada'
source "$baseDir"/br/com/experian/utils/common.sh

# /**
# * TEMP
# * Leitura de opções
# * @var string
# */
TEMP=`getopt -o tuemirwj::h --long safe::,iamUser::,awsAccount::,awsRegion::,paths::,distribution::,action:: -n "$0" -- "$@"`
eval set -- "$TEMP"

#Variaveis

# /**
# * safe
# * Safe do CyberArk para retrieve de secrets
# * @var string
# */
safe=''

# /**
# * iamUser
# * Nome do usuario IAM da conta AWS
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
# * awsRegion
# * Regiao da conta AWS
# * @var string
# */
awsRegion='sa-east-1'

# /**
# * paths
# * Paths para invalidacao do cache
# * @var string
# */
paths=''

# /**
# * pathsParsed
# * Paths parseados para uso via CLI
# * @var string
# */
pathsParsed=''

# /**
# * action
# * Acao a ser realizada no CloudFront
# * @var string
# */
action=''

# /**
# * distribution
# * Distribution ID do CloudFront
# * @var string
# */
distribution=''

# /**
# * usage
# * Método help do script
# * @package DevOps
# */
usage () {
    echo "cloudfront.sh - by SRE Team"
    echo "Copyright (C) 2023 Serasa Experian"
    echo ""
    echo -e "cloudfront.sh script responsavel por executar a ações no CloudFront.\n"

    echo -e "Usage: cloudfront.sh --safe=USCLD_PAWS_1234567 --iamUser=BUUserForDevSecOps --awsAccount=1234567 --distribution=EHDBKAMSKL --action=invalidate 
    or cloudfront.sh --safe=USCLD_PAWS_1234567 --iamUser=BUUserForDevSecOps --awsAccount=1234567 --distribution=EHDBKAMSKL --action=invalidate --paths=/diretorio/arquivo.html,/diretorio/arquivo.js --awsRegion=us-east-1"

    echo -e "Options
    --safe          Nome do safe do CyberArk.
    --iamUser       Nome do usuario IAM da conta AWS.
    --awsAccount    ID da conta AWS .
    --awsRegion     Regiao da conta AWS. sa-east-1 por padrao.
    --paths         Paths a serem invalidados. '/*' por padrao.
    --distribution  Distribution ID do CloudFront.
    --action        Acao a ser executada no script. 
    --h, --help     Ajuda"

    exit 1
}

# /**
# * validateParameters
# * Método valida parametros obrigatorios
# * @package DevOps
# */
validateParameters () {

    infoMsg 'cloudfront.sh->validateParameters: Iniciando validacoes de parametros do CloudFront.'

    if [ "$safe" == "" ];then
        errorMsg 'cloudfront.sh->validateParameters: Para uso do CloudFront é obrigatório informar o safe CyberArk.'
        exit 1
    fi

    if [ "$iamUser" == "" ];then
        errorMsg 'cloudfront.sh->validateParameters: Para uso do CloudFront é obrigatório informar o iamUser do CyberArk.'
        exit 1
    fi

    if [ "$awsAccount" == "" ];then
        errorMsg 'cloudfront.sh->validateParameters: Para uso do CloudFront é obrigatório informar o ID da sua conta AWS.'
        exit 1
    fi

    if [ "$distribution" == "" ];then
        errorMsg 'cloudfront.sh->validateParameters: Para uso do CloudFront é obrigatório informar o ID da distribuição.'
        exit 1
    fi

    if [ "$action" == "" ];then
        errorMsg 'cloudfront.sh->validateParameters: Para uso do CloudFront é obrigatório informar a ação a ser realizada.'
        exit 1
    fi

}

# /**
# * awsAuth
# * Autentica na conta AWS
# * @package DevOps
# */
awsAuth() {

    if ! credentials=$(cyberArkDap -s $safe -c $iamUser -a $awsAccount); then
        warnMsg 'cloudfront.sh->awsAuth: Falha ao resgatar os segredos do vault '$safe'. Realize o onboarding para utilizar o CloudFront na esteira.'
        exit 1
    fi

    awsAccessKey=$(echo $credentials | jq -r '.accessKey')
    awsSecretKey=$(echo $credentials | jq -r '.accessSecret')

    export AWS_ACCESS_KEY_ID=$awsAccessKey
    export AWS_SECRET_ACCESS_KEY=$awsSecretKey
    export AWS_DEFAULT_REGION=$awsRegion
}

# /**
# * invalidateCache
# * Invalida o cache no CloudFront
# * @package DevOps
# */
invalidateCache() {

    infoMsg 'cloudfront.sh->invalidateCache: Iniciando procedimento de invalidate cache.'
    infoMsg 'cloudfront.sh->invalidateCache: Distribuição: '$distribution''

    if [ "$paths" == "" ]; then
        infoMsg 'cloudfront.sh->invalidateCache: Paths: '$paths''
        aws --no-verify-ssl cloudfront create-invalidation --distribution-id $distribution --paths "/*"
    else
        IFS=',' read -ra pathsArray <<< $paths

        for i in "${pathsArray[@]}"; do
            pathsParsed+="$i "
        done

        infoMsg 'cloudfront.sh->invalidateCache: Paths: '$pathsParsed''
        aws --no-verify-ssl cloudfront create-invalidation --distribution-id $distribution --paths $pathsParsed
    fi

}

# Valida passagem de parametros
if [ $# -eq 1 ];then
    usage
    exit 1
fi

# Extrai opcoes passadas
while true ; do
    case "$1" in
        --safe)
            case "$2" in
               "") shift 2 ;;
                *) safe="$2" ; shift 2 ;;
            esac ;;
        --iamUser)
            case "$2" in
               "") shift 2 ;;
                *) iamUser="$2" ; shift 2 ;;
            esac ;;
        --awsAccount)
            case "$2" in
               "") shift 2 ;;
                *) awsAccount="$2" ; shift 2 ;;
            esac ;;
        --awsRegion)
            case "$2" in
               "") shift 2 ;;
                *) awsRegion="$2" ; shift 2 ;;
            esac ;;
        --paths)
            case "$2" in
               "") shift 2 ;;
                *) paths="$2" ; shift 2 ;;
            esac ;;
        --distribution)
            case "$2" in
               "") shift 2 ;;
                *) distribution="$2" ; shift 2 ;;
            esac ;;
        --action)
            case "$2" in
               "") shift 2 ;;
                *) action="$2" ; shift 2 ;;
            esac ;;
        -h|--help) usage ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

validateParameters
awsAuth

case $action in
    invalidate)
        invalidateCache
    ;; 
    *)
        errorMsg 'cloudfront.sh: Ação '${action}' ainda nao implementada.'
        exit 1
    ;;
esac