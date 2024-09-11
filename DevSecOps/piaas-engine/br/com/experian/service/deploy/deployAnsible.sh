#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           deployAnsible.sh
# * @version        $VERSION
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
TEMP=$(getopt -o twj::h --long help,piaasEnv::,runin::,job-id::,workflow-id::,extra-vars:: -n "$0" -- "$@")
eval set -- "$TEMP"

# /**
# * runin
# * Define o executor de deploy ansible
# * @var string
# */
runin=''

# /**
# * typeExecution
# * Define o tipo de execução no ansible
# * @var string
# */
typeExecution=''

# /**
# * workflowId
# * Define o id do workflow para usar no deploy
# * @var int
# */
workflowId=0

# /**
# * jobId
# * Define o id do job para usar no deploy
# * @var int
# */
jobId=0

# /**
# * extraVars
# * Define as variaveis extras de deploy
# * @var string
# */
extraVars=''


usage () {
    echo "deployAnsible.sh version $VERSION - by DevSecOps PaaS Team"
    echo "Copyright (C) 2024 Serasa Experian"
    echo ""
    echo -e "deployAnsible.sh script para deploy Ansible no PiaaS.\n"
    echo -e "Usage: deployAnsible.sh --runin=awx-midd --job-id=50 --extra-vars='a=5 b=3 ' \n
                 or deployAnsible.sh --runin=tower --workflow-id=51 --extra-vars='a=5 b=3'"
    echo -e "Options:
    --runin                     Executor ansible que irá ser chamado para deploy
                                Executores: tower
                                            tower-experian
                                            awx-midd
    --w, --workflow-id          Id do workflow no ansible tower
    --j, --job-id               Id do job no ansible tower
    --extra-vars                Variaveis extras usadas para o deploy no ansible tower
    --h, --help                 Ajuda"
    exit 1
}

# /**
# * validTargetAnsible
# * Método valida quando destino for ansible 
# */
validTargetAnsible() {
    if [ "$runin" == "" ]; then
        errorMsg 'deployAnsible.sh : Para o deploy com ansible e necessario informar um executor. Exemplo: --runin=awx-midd|tower|tower-experian'
        exit 1
    fi

    if [ $workflowId -ne 0 ] && [ $jobId -ne 0 ]; then
        errorMsg 'deployAnsible.sh : Para deploy Ansible é permitido o uso somente de "workflow" ou "job". Impossivel usar os dois como parametros simultaneamente. Exemplo --workflow-id=51 OU --job-id=50'
        exit 1
    fi

    if [ $workflowId -ne 0 ]; then
        if [[ $workflowId = ?(+|-)+([0-9]) ]] ; then 
            typeExecution='workflow'
        else
            errorMsg 'deployAnsible.sh : Id '${workflowId}' do workflow invalido. Exemplo --workflow-id=51'
            exit 1
        fi
    elif [ $jobId -ne 0 ]; then
        if [[ $jobId = ?(+|-)+([0-9]) ]] ; then 
            typeExecution='job'
        else
            errorMsg 'deployAnsible.sh : Id '${jobId}' do jobId invalido. Exemplo --job-id=50'
            exit 1
        fi
    else
        errorMsg 'deployAnsible.sh : Um Id de workflow ou job e necessario para deploy Ansible. Exemplo --workflow-id=51 ou --job-id=50'
        exit 1
    fi

    if [ "$extraVars" != "" ]; then
        infoMsg 'deployAnsible.sh : Variaveis extras definidas para o deploy '${extraVars}' '
    else
        warnMsg 'deployAnsible.sh : Nenhuma variavel extra foi definida para este deploy'
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
        --runin)
            case "$2" in
               "") shift 2 ;;
                *) runin=$(echo ${2} | tr [:upper:] [:lower:]) ; shift 2 ;;
            esac ;;
        -w|--workflow-id)
            case "$2" in
               "") shift 2 ;;
                *) workflowId=$(echo ${2} | tr [:upper:] [:lower:]) ; shift 2 ;;
            esac ;;
        -j|--job-id)
            case "$2" in
               "") shift 2 ;;
                *) jobId=$(echo ${2} | tr [:upper:] [:lower:]) ; shift 2 ;;
            esac ;;
        --extra-vars)
            case "$2" in
               "") shift 2 ;;
                *) extraVars="$2" ; shift 2 ;;
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

validTargetAnsible

infoMsg "deployAnsible.sh : Executando o deploy do tipo '${typeExecution}'"
deploymentsAnsible $runin $typeExecution $workflowId $jobId "$extraVars"
infoMsg "deployAnsible.sh : Sucesso no deploy \o/"