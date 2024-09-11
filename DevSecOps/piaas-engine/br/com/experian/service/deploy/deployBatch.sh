#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           deployAnsible.sh
# * @description    Script para deploys Ansible
# * @copyright      2024 &copy Serasa Experian
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

# Carrega ansibleLib
test -e "$baseDir"/br/com/experian/utils/ansibleLib.sh || echo 'Ops, biblioteca ansibleLib nao encontrada'
source "$baseDir"/br/com/experian/utils/ansibleLib.sh

# Carrega nexusLib
test -e "$baseDir"/br/com/experian/utils/nexusLib.sh || echo 'Ops, biblioteca nexusLib nao encontrada'
source "$baseDir"/br/com/experian/utils/nexusLib.sh

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
TEMP=`getopt -o miu::h --long help,piaasEnv::,application-name::,method::,instance-name::,parameters::,url-package::,path-package::,no-service:: -n "$0" -- "$@"`
eval set -- "$TEMP"

# /**
# * piaasEnv
# * Define o executor de deploy ansible
# * @var string
# */
piaasEnv=''

# /**
# * method
# * Define metodo de deploy
# * @var string
# */
method=''

# /**
# * applicationName
# * Nome da aplicacao 
# * @var string
# */
applicationName=''

# /**
# * instanceName
# * Nome da instancia a ser ser feito o deploy
# * @var string
# */
instanceName=''

# /**
# * parameters
# * Parametros para o deploy
# * @var string
# */
parameters=''

# /**
# * urlPackage
# * Url pacote para o deploy
# * @var string
# */
urlPackage=''

# /**
# * pathPackage
# * Caminho do pacote para o deploy
# * @var string
# */
pathPackage=''

# /**
# * noService
# * Ignorar criacao de servico no deploy no openshift
# * @var string
# */
noService='false'


usage () {
    echo "deployAnsible.sh version $VERSION - by DevSecOps PaaS Team"
    echo "Copyright (C) 2024 Serasa Experian"
    echo ""
    echo -e "deployAnsible.sh script para deploy Ansible no PiaaS.\n"
    echo -e "Usage: \n
           deployBatch.sh --method=ansible --application-name=experian-test --instance-name=spobrtest --parameters=parametros_start --url-package=url_pacote 
        or deployBatch.sh --method=ansible --application-name=experian-test --instance-name=spobrtest --parameters=parametros_start --url-package=url_pacote --path-package=/path/do/deploy
        or deployBatch.sh --method=ansible --application-name=experian-test --instance-name=spobrtest --parameters=parametros_start --url-package=url_pacote --path-package=/path/do/deploy --no-service"
    echo -e "Options: \n
    --m, --method               Metodo de deploy a ser usado [normal|provisioning|bluegreen|package|ansible] 
    --application-name          Nome da aplicacao 
    --i,--instance-name         Nome da instancia a ser ser feito o deploy 
    --parameters                Parametros para o deploy 
    --u, --url-package          Pacote para deploy 
    --path-package              Caminho do pacote para ser feito o deploy 
    --no-service                Ignorar criacao de servico no deploy 
    --h, --help                 Ajuda"
    exit 1
}

# /**
# * validTargetBatch
# * Método valida quando destino for batch
# */
validTargetBatch () {
    if [ "$applicationName" == "" ]; then
        errorMsg 'deployBatch.sh : Para o deploy de batch e necessario informar o application-name. Exemplo: --application-name=experian-test'
        exit 1
    fi

    if [ "$instanceName" == "" ]; then
        errorMsg 'deployBatch.sh : Para o deploy de batch e necessario informar a instance-name de deploy. Exemplo: --instance-name=spobrtest'
        exit 1
    fi

    if [ "$parameters" != "" ]; then
        infoMsg 'deployBatch.sh : Parametros definidos para o deploy '${parameters}' '
    else
        warnMsg 'deployBatch.sh : Nenhuma parametros foi definido para este deploy'
        parameters=''
    fi

    if [ "$pathPackage" == "" ];then
        pathPackage="/opt/deploy/$applicationName"
        infoMsg 'deployBatch.sh: O parametro --path-package nao foi usado, definindo caminho padrao de deploy '${pathPackage}' '
    fi
}

# /**
# * validPackage
# * Método valida package informado
# */
validPackage () {
    # Validações de pacote
    if [ ${#urlPackage} -lt 1 ]; then
        errorMsg 'deployBatch.sh : Opcao --url-package nao informada impossivel prosseguir'
        exit 1
    fi

    resp=`getInfoPackage "statusPackage" "$urlPackage"`
    infoMsg 'deployBatch.sh: Retorno do status do pacote '${resp}' '
    if [ "$resp" == "200" ] || [ "$resp" == "307" ]; then
        infoMsg 'deployBatch.sh : Pacote '${urlPackage}' encontrado! Seguindo com o deploy...'
    else
        errorMsg 'deployBatch.sh : Pacote informado '${urlPackage}' nao encontrado impossivel prosseguir'
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
while true ; do
    case "$1" in
        --piaasEnv)
            case "$2" in
               "") shift 2 ;;
                *) piaasEnv=$2 ; shift 2 ;;
            esac ;;
        --application-name)
            case "$2" in
               "") shift 2 ;;
                *) applicationName="$2" ; shift 2 ;;
            esac ;;
        -m|--method)
            case "$2" in
               "") shift 2 ;;
                *) method=`echo ${2} | tr [:upper:] [:lower:]` ; shift 2 ;;
            esac ;;
        -i|--instance-name)
            case "$2" in
               "") shift 2 ;;
                *) instanceName=`echo ${2} | tr [:upper:] [:lower:]` ; shift 2 ;;
            esac ;;
        --parameters)
            case "$2" in
               "") shift 2 ;;
                *) parameters="$2" ; shift 2 ;;
            esac ;;
        -u|--url-package)
            case "$2" in
               "") shift 2 ;;
                *) urlPackage=$2 ; shift 2 ;;
            esac ;;
        --path-package)
            case "$2" in
               "") shift 2 ;;
                *) pathPackage="$2" ; shift 2 ;;
            esac ;;
        --no-service)
            case "$2" in
               "") noService='true' ; shift 2;;
                *) noService='true' ; shift 2;;
            esac ;;
        -h|--help) usage ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done


#Definindo conta AWS
if [ "$piaasEnv" == "prod" ]; then
    awsAccount="707064604759"
else
    awsAccount="559037194348"
fi


validPackage
validTargetBatch
infoMsg 'deployBatch.sh : Usando o metodo de deploy '${method}''
case $method in
    ansible)
        runin="tower"
        typeExecution="job"
        jobId="568"
        extensao=$(echo "$urlPackage" | awk -F . '{print $NF}')
        extraVars="application_service_name=$applicationName deploy_host_target=$instanceName application_nexus_url=$urlPackage systemd_unit_exec_start='$parameters' path_target=$pathPackage no_service=$noService extension=$extensao"
        deploymentsAnsible $runin $typeExecution $workflowId $jobId "$extraVars"
        infoMsg 'deployBatch.sh : Sucesso no deploy \o/'
    ;;
    *)
        errorMsg 'deployBatch.sh : Tipo de deploy '${method}' ainda nao implementado :('
        exit 1
    ;;
esac
