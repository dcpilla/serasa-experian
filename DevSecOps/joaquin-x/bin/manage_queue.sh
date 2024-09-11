#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto Service Catalog Infrastructure Serasa Experian 
# *
# * @package        Service Catalog Infrastructure
# * @name           manage_queue.sh
# * @version        $VERSION
# * @description    Script que controla filas das request para auto implementação
# * @copyright      2021 &copy Serasa Experian
# *
# * @version        2.3.0
# * @change         - [FEATURE] Normalização dos logs, implementação da função de envio de fila etl;
# * @author         DevSecOps Architecture Brazil
# * @contribution   Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @dependencies   /opt/DevOps/bin/snow.sh       
# *                 /usr/local/bin/jq
# *                 /usr/local/bin/yq
# *                 /opt/DevOps/lib/common.sh
# *                 mysql client
# * @date           14-Jul-2021
# *
# * @version        1.0.0
# * @change         - [FEATURE] Script que controla filas das request para auto implementação
# * @author         DevSecOps Architecture Brazil
# * @contribution   Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @dependencies   /opt/DevOps/bin/snow.sh       
# *                 /usr/local/bin/jq
# *                 /usr/local/bin/yq
# *                 mysql client
# * @date           17-Mar-2021
# **/  

# /**
# * Configurações iniciais
# */

# Exit on errors
#set -eu # Liga Debug

# Diretorio base
baseDir="/opt/deploy/joaquin-x"

# /**
# * Variaveis
# */

# /**
# * VERSION
# * Versão do script
# */
VERSION='2.3.0'

# /**
# * TEMP
# * Leitura de opções
# * @var string
# */
TEMP=`getopt -o a::h --long help::,action::,verbose:: -n "$0" -- "$@"`
eval set -- "$TEMP"

# /**
# * action
# * Define ação
# * @var string
# */
action=""

# /**
# * jsonMonitoredRequests
# * Define lista de request para monitoração
# * @var string
# */
jsonMonitoredRequests=""

#/**
# * workSpaceQueueIn
# * Define a workspace para fila de entrada das request
# * @var string
# **/
workSpaceQueueIn=''

#/**
# * workSpaceQueueProcessing
# * Define a workspace para fila de processando das request
# * @var string
# **/
workSpaceQueueProcessing=''

#/**
# * workSpaceQueueDone
# * Define a workspace para fila de implementadas das request
# * @var string
# **/
workSpaceQueueDone=''

#/**
# * workSpaceQueueError
# * Define a workspace para fila de error das request
# * @var string
# **/
workSpaceQueueError=''

#/**
# * workSpaceQueueEtl
# * Define a workspace para fila de etl
# * @var string
# **/
workSpaceQueueEtl=''

#/**
# * templateName
# * Define o nome do template
# * @var string
# **/
templateName=''

#/**
# * templateId
# * Define o id do template
# * @var string
# **/
templateId=''

#/**
# * templateOwner
# * Define o dono do template
# * @var string
# **/
templateOwner=''

#/**
# * templateOwnerEmail
# * Define email do dono do template
# * @var string
# **/
templateOwnerEmail=''

#/**
# * ritmList
# * Define lista de request
# * @var string
# **/
ritmList=''

# /**
# * verbose
# * Define modo de execução
# * @var string
# */
verbose='false'

# /**
# * Funções
# */

# /**
# * usage
# * Método help do script
# * @version $VERSION
# * @package DevOps
# * @author  Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# */
usage () {
    echo "manage_queue.sh version $VERSION - by DevSecOps PaaS"
    echo "Copyright (C) 2021 Serasa Experian"
    echo ""
    echo -e "manage_queue.sh Script que controla filas das request para auto implementação \n"
    echo -e "Usage: manage_queue.sh --verbose --action=get-queue-request
    or manage_queue.sh --action=send-queue-request-error
    or manage_queue.sh --action=send-queue-etl\n"


    echo -e "Options
    --a, --action                  Acao a tomar [get-queue-request|send-queue-request-error|send-queue-etl]
         --verbose                 Define modo verbose para execucao
    --h, --help                    Ajuda"

    exit 1
}

# /**
# * logMsg
# * Método mensagens
# * @package Service Catalog Infrastructure
# * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @parm    string - msg a ser exibida
# *          type   - tipo de msg
# * @return  true | false
# */
logMsg() {
    local msg="$1"
    local type="$2"

    echo "[$type] $(date) - $msg"
}

# /**
# * loadEnv
# * Método carregamento das variaveis
# * @package Service Catalog Infrastructure
# * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @parm    
# * @return  true | false
# */
loadEnv() {
    logMsg 'manage_queue.sh->loadEnv: Set enviroment' "INFO"
    if [ "$0" == "/opt/deploy/hom-joaquin-x/bin/manage_queue.sh" ]; then
        jsonMonitoredRequests="/opt/deploy/hom-joaquin-x/config/monitored_requests.json"
        workSpaceQueueIn='/opt/jenkins/.joaquin/workspace-homolog/queue/input'
        workSpaceQueueProcessing='/opt/jenkins/.joaquin/workspace-homolog/queue/processing'
        workSpaceQueueDone='/opt/jenkins/.joaquin/workspace-homolog/queue/done'
        workSpaceQueueError='/opt/jenkins/.joaquin/workspace-homolog/queue/error'
        workSpaceQueueEtl='/opt/jenkins/.joaquin/workspace-homolog/queue/etl'
    else
        jsonMonitoredRequests="/opt/deploy/joaquin-x/config/monitored_requests.json"
        workSpaceQueueIn='/opt/jenkins/.joaquin/workspace/queue/input'
        workSpaceQueueProcessing='/opt/jenkins/.joaquin/workspace/queue/processing'
        workSpaceQueueDone='/opt/jenkins/.joaquin/workspace/queue/done'
        workSpaceQueueError='/opt/jenkins/.joaquin/workspace/queue/error'
        workSpaceQueueEtl='/opt/jenkins/.joaquin/workspace/queue/etl'
    fi
}

# /**
# * getQueueRequest
# * Método que consulta fila request 
# * @version $VERSION
# * @package DevOps
# * @author  Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# * @return 
# */
getQueueRequest(){ 
    local i=0
    local requestMonitoring=$(cat $jsonMonitoredRequests | /usr/local/bin/jq -r '.monitored_requests | length')
    templateName=''
    templateId=''
    templateOwner=''
    templateOwnerEmail=''

    logMsg 'manage_queue.sh->getQueueRequest: Looking for released requests in '${requestMonitoring}' category' "INFO"

    for (( i=0; i < $(cat $jsonMonitoredRequests | /usr/local/bin/jq -r '.monitored_requests | length') ; i++ ))
    do
        logMsg 'manage_queue.sh->getQueueRequest: Set details' "INFO"     
        templateName=$(cat $jsonMonitoredRequests | /usr/local/bin/jq -r '.monitored_requests['${i}'].template_name')
        templateId=$(cat $jsonMonitoredRequests | /usr/local/bin/jq -r '.monitored_requests['${i}'].template_id')
        templateOwner=$(cat $jsonMonitoredRequests | /usr/local/bin/jq -r '.monitored_requests['${i}'].owner')
        templateOwnerEmail=$(cat $jsonMonitoredRequests | /usr/local/bin/jq -r '.monitored_requests['${i}'].owner_email')

        logMsg 'manage_queue.sh->getQueueRequest: Search' "INFO"        
        echo "Request category: $templateName "
        echo "Request Id: $templateId"
        
        ritmList=$(/opt/DevOps/bin/snow.sh  --action=get-request-auto-implement --category=$templateId)
        if [ "$ritmList" != "" ]; then
            logMsg 'manage_queue.sh->getQueueRequest: Queue for category found' "INFO" 
            echo "List: ${ritmList}"
            for item in $ritmList
            do
                if [ -e $workSpaceQueueIn/$item.queue ];then
                    logMsg 'manage_queue.sh->getQueueRequest: Request '${item}' exists in queue input, ignore' "INFO" 
                elif [ -e $workSpaceQueueDone/$item.queue ]; then
                    logMsg 'manage_queue.sh->getQueueRequest: Request '${item}' exists in queue done, ignore' "INFO" 
                elif [ -e $workSpaceQueueProcessing/$item.queue ]; then
                    logMsg 'manage_queue.sh->getQueueRequest: Request '${item}' exists in queue processing, ignore ' "INFO" 
                elif [ -e $workSpaceQueueError/$item.queue ]; then
                    logMsg 'manage_queue.sh->getQueueRequest: Request '${item}' exists in queue error, ignore' "INFO" 
                else
                    logMsg 'manage_queue.sh->getQueueRequest: Request '${item}' is new create queue' "INFO"
                    echo "$item;$templateName;$templateId;$templateOwner;$templateOwnerEmail;$(date)" > $workSpaceQueueIn/$item.queue
                fi
            done
        else
            logMsg 'manage_queue.sh->getQueueRequest: Queue for empty category ' "INFO"  
        fi

        logMsg 'manage_queue.sh->getQueueRequest: Clenaup enviroment' "INFO"  
        templateName=''
        templateId=''
        templateOwner=''
        templateOwnerEmail=''
        ritmList=''
    done
}

# /**
# * sendQueueRequestError
# * Método que enviar fila com erros para os donos das request
# * @version $VERSION
# * @package DevOps
# * @author  Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# * @return 
# */
sendQueueRequestError(){ 
    echo "implementar sendQueueRequestError"
    cat $jsonMonitoredRequests
    echo "Listando erros"
    ls -lha $workSpaceQueueError
}

# /**
# * sendQueueEtl
# * Método que envia fila de etl para base unificada
# * @version $VERSION
# * @package DevOps
# * @author  Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# * @return 
# */
sendQueueEtl(){ 
    # Carrega commons
    test -e "/opt/DevOps/lib/common.sh" || echo 'Ops, biblioteca common nao encontrada'
    source "/opt/DevOps/lib/common.sh"

    local dbServer=`getCredentialsHost db-database-devops`
    local dbUser=`getCredentialsUser db-database-devops`
    local dbUser=$(echo ${dbUser} | base64 -d) 
    local dbToken=`getCredentialsToken db-database-devops`
    local dbToken=$(echo ${dbToken} | base64 -d) 
    local dbDatabase='devops'
    local dbTable='JOAQUINX_BI'
    local dbQuery=''
    local qtdEtl=''
    local qtdEtlProces=1
    local launch=''
    local type=''
    local date_start=''
    local date_end=''
    local execution_result=''
    local who_executed=''
    local joaquinx_environment=''
    local jsonData=''

    logMsg 'manage_queue.sh->sendQueueEtl: Start send queue ETL to server['${dbServer}']:data_base['${dbDatabase}']/table['${dbTable}']' "INFO"

    if [ $(ls -A $workSpaceQueueEtl/*.etl |wc -l) -gt 0 ] ; then
        qtdEtl=$(ls -A $workSpaceQueueEtl/*.etl |wc -l)
        for ln in $(ls -A $workSpaceQueueEtl/*.etl); do
            logMsg 'manage_queue.sh->sendQueueEtl: Processing queue ETL ('${qtdEtlProces}'/'${qtdEtl}') ' "INFO"
            echo "Item-> $ln"
            
            logMsg 'manage_queue.sh->sendQueueEtl: [E]xtract queue ETL' "INFO"
            sed -i "s/'//g" $ln
            launch=$(cat $ln | /usr/local/bin/jq -r '.launch')
            type=$(cat $ln | /usr/local/bin/jq -r '.type')
            date_start=$(cat $ln | /usr/local/bin/jq -r '.date_start')
            date_end=$(cat $ln | /usr/local/bin/jq -r '.date_end')
            execution_result=$(cat $ln | /usr/local/bin/jq -r '.execution_result')
            who_executed=$(cat $ln | /usr/local/bin/jq -r '.who_executed')
            joaquinx_environment=$(cat $ln | /usr/local/bin/jq -r '.joaquinx_environment')
            jsonData=$(cat "$ln")

            if [ "$who_executed" == "by_magic" ] && [ "$execution_result" == "CANCELED" ]; then
                logMsg 'manage_queue.sh->sendQueueEtl: [I]gnore queue ETL because who executed is by_magic and result is CANCELED' "INFO"
                rm -f $ln
            else
                logMsg 'manage_queue.sh->sendQueueEtl: [T]rasnform queue ETL' "INFO"
                if [ "$execution_result" == "" ]; then
                    execution_result="ERROR"
                fi

                dbQuery="INSERT INTO $dbTable (launch,type,date_start,date_end,execution_result,who_executed,joaquinx_environment,log) VALUES('$launch','$type','$date_start','$date_end','$execution_result','$who_executed','$joaquinx_environment','$jsonData');"
                echo "Query-> $dbQuery"

                logMsg 'manage_queue.sh->sendQueueEtl: [L]oad queue ETL' "INFO"
                if ! mysql -h $dbServer -u $dbUser -e "$dbQuery" $dbDatabase -p"$dbToken"; then
                    logMsg 'manage_queue.sh->sendQueueEtl: Ops, Error send queue!' "ERROR"
                else
                    logMsg 'manage_queue.sh->sendQueueEtl: Success in send queue!' "INFO"
                    rm -f $ln
                fi  
            fi

            logMsg 'manage_queue.sh->sendQueueEtl: [C]leanup queue ETL' "INFO"
            qtdEtlProces=$(($qtdEtlProces+1))
            launch=''
            type=''
            date_start=''
            date_end=''
            execution_result=''
            who_executed=''
            joaquinx_environment=''
            jsonData=''
            dbQuery=''
        done
    else
        logMsg 'manage_queue.sh->sendQueueEtl: No queue ETL to send, nothing to do!' "INFO"
    fi

    logMsg 'manage_queue.sh->sendQueueEtl: End send queue ETL to server['${dbServer}']:data_base['${dbDatabase}']/table['${dbTable}']' "INFO"
}

# /**
# * Start
# */

# Valida passagem de parametros
if [ $# -eq 1 ];then
    usage
    exit 1
else
    loadEnv
fi

# Extrai opções passadas
while true ; do
    case "$1" in
        --verbose)
            case "$2" in
               "") verbose='true' ; shift 2;;
                *) verbose='true' ; shift 2;;
            esac ;;
        -a|--action)
            case "$2" in
               "") shift 2 ;;
                *) action=$2 ; shift 2 ;;
            esac ;;
        -h|--help) usage ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

# Run action
case "$action" in
    get-queue-request) getQueueRequest ;;
    send-queue-request-error) sendQueueRequestError ;;
    send-queue-etl) sendQueueEtl ;;
    *) logMsg 'manage_queue.sh: Options '${action}' not exists ' "ERROR"; usage;;
esac 