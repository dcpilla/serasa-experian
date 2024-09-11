#!/usr/bin/env bash

# /**
# * Configurações iniciais
# */

# Exit se erros
#set -eu   # Liga Debug

# Diretorio base
baseDir="/opt/infratransac/core"

# Carrega commons
test -e "$baseDir"/br/com/experian/utils/common.sh || echo 'Ops, biblioteca common nao encontrada'
source "$baseDir"/br/com/experian/utils/common.sh

# /**
# * Variaveis
# */

# /**
# * ansibleServer
# * Servidor Ansible Executor
# * @var string
# */
ansibleServer=''

# /**
# * ansibleUser
# * Usuário Ansible Executor
# * @var string
# */
ansibleUser=''

# /**
# * ansibleToken
# * Token Ansilbe Executor
# * @var string
# */
ansibleToken=''

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

# /**
# * deploymentId
# * Define o id de deploy
# * @var string
# */
deploymentId=''

# /**
# * statusProcessDeploy
# * Define o status do deploy
# * @var string
# */
statusDeploy=''

# /**
# * statusElapsed
# * Define o percentual do status de deploy
# * @var string
# */
statusElapsed=''

# /**
# * deployCreated
# * Define a data de criação do deploy
# * @var string
# */
deployCreated=''

# /**
# * towerServer
# * Servidor tower
# * @var string
# */
towerServer=$(getCredentialsHost aap-api)

# /**
# * towerTokenAuthorization
# * Token tower
# * @var string
# */
towerTokenAuthorization=$(getCredentialsToken aap-api)
towerTokenAuthorization=$(echo ${towerTokenAuthorization} | base64 -d)  

# /**
# * towerJobId
# * Numero do job no tower
# * @var string
# */
towerJobId=''

# /**
# * towerExtraVars
# * Define extra-vars do tower
# * @var string
# */
towerExtraVars=''

# /**
# * towerJobStatus
# * Define job status
# * @var string
# */
towerJobStatus=''

# /**
# * towerEndPoint
# * Define end-point do tower
# * @var string
# */
towerEndPoint=''

# /**
# * towerJobId
# * Numero do job id executado no tower
# * @var string
# */
towerJobIdExec=''

# /**
# * towerJobStatusElapsed
# * Define tempo de execução do job
# * @var string
# */
towerJobStatusElapsed=''

# /**
# * towerJobCreated
# * Define data de criação de um execução de job
# * @var string
# */
towerJobCreated=''

# /**
# * towerModeDebug
# * Define modo debug para execução de job
# * @var string
# */
towerModeDebug='false'

# /**
# * errors
# * Define flag de erro do deploy
# * @var string
# */
errors=false

# /**
# * Funções
# */

# /**
# * runJobTower
# * Método executa job no tower
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <Joao.Leite2@br.experian.com>
# * @param   $towerJobId
# *          $towerExtraVars
# *          $towerModeDebug - true | false
# * @return  true|false
# */
runJobTower() {
    towerJobId="$1"
    towerExtraVars="$2"
    towerModeDebug="$3"

    test ! -z $towerJobId || { errorMsg 'ansibleLib.sh->runJobTower: towerJobId nao informado' ; exit 1; }
    test ! -z "$towerExtraVars" || { errorMsg 'ansibleLib.sh->runJobTower: towerExtraVars nao informada' ; exit 1; }

    infoMsg 'ansibleLib.sh->runJobTower: Servidor tower '${towerServer}''

    infoMsg 'ansibleLib.sh->runJobTower: Start job '${towerJobId}''
    resp=''
    towerEndPoint=''
    towerEndPoint=$(echo $towerServer'/job_templates/'$towerJobId'/launch/')
    resp=$(curl --insecure --request POST $towerEndPoint \
                --header 'authorization: Bearer '$towerTokenAuthorization'' \
                --header 'cache-control: no-cache' \
                --header 'Content-Type: application/json' \
                --data   "{ \"extra_vars\": ${towerExtraVars} }" 2>/dev/null)

    towerJobIdExec=$(echo $resp | jq -r '.id')
    towerJobStatus=$(echo $resp | jq -r '.status')
    towerJobCreated=$(echo $resp | jq -r '.created')

    if [ "$towerJobIdExec" == "" ] || [ "$towerJobStatus" != "pending" ] || [ "$towerJobCreated" == "" ]; then
        errorMsg 'ansibleLib.sh->runJobTower: UPsss erro no start do job '${towerJobId}' impossivel prosseguir :('
        echo "$resp" | jq -r '.'
        if [ "$towerJobIdExec" != "" ]; then
            echo "$resp" | jq -r '.'
        fi
        errors='true'
        return 1
    fi

    infoMsg 'ansibleLib.sh->runJobTower: Job iniciado em '${towerJobCreated}' ID '${towerJobIdExec}''

    if [ "$towerModeDebug" == "true" ]; then
        towerEndPoint=''
        towerEndPoint=$(echo $towerServer'/jobs/'$towerJobIdExec'/')
        infoMsg 'ansibleLib.sh->runJobTower: Monitorando job '${towerEndPoint}''
        infoMsg 'ansibleLib.sh->runJobTower: Job '${towerEndPoint}' - ('${towerJobStatus}') '
        while [ "$towerJobStatus" != "successful" ]; do
            resp=''
            resp=$(curl --insecure GET $towerEndPoint \
                        --header 'authorization: Bearer '$towerTokenAuthorization'' \
                        --header 'cache-control: no-cache' \
                        --header 'Content-Type: application/json' 2>/dev/null)

            towerJobStatus=$(echo $resp | jq -r '.status')
            towerJobStatusElapsed=$(echo $resp | jq -r '.elapsed')

            infoMsg 'ansibleLib.sh->runJobTower: Status job '${towerEndPoint}' - ('${towerJobStatus}' | '${towerJobStatusElapsed}')'

            if [ "$towerJobStatus" == "failed" ]; then
                errorMsg 'ansibleLib.sh->runJobTower: job falhou '${towerEndPoint}' :('
                echo "$resp" | jq -r '.'
                errors='true'
                return 1
            fi

            sleep 3
        done
    fi

    infoMsg "ansibleLib.sh->runJobTower: It's Magic o/"
}

# /**
# * runDeploymentsAnsible
# * Método de start do deploy
# * @version 4.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param
# * @return
# */
runDeploymentsAnsible (){
    resp=''
    deploymentId=''
    statusElapsed=''
    statusDeploy=''
    deployCreated=''

    case $typeExecution in
        job)         
            infoMsg 'ansibleLib.sh->runDeploymentsAnsible: Executando '${typeExecution}' em '${ansibleServer}' id '${jobId}'' 
            if [ "$extraVars" != "" ]; then
                infoMsg 'ansibleLib.sh->runDeploymentsAnsible: Variaveis extras para execucao '${extraVars}' '
                resp=$(docker run --rm $runin tower-cli \
                              job launch --job-template=$jobId \
                              --extra-vars="${extraVars}")
            else
                resp=$(docker run --rm $runin tower-cli \
                              job launch --job-template=$jobId)
            fi

            deploymentId=$(echo $resp |cut -d' ' -f18)
            deployCreated=$(echo $resp |cut -d' ' -f20)
            statusDeploy=$(echo $resp |cut -d' ' -f21)
            statusElapsed=$(echo $resp |cut -d' ' -f22)
        ;;
        workflow)
            #infoMsg 'ansibleLib.sh->runDeploymentsAnsible: Executando '${typeExecution}' em '${ansibleServer}' id '${workflowId}'' 
            if [ "$extraVars" != "" ]; then
                infoMsg 'ansibleLib.sh->runDeploymentsAnsible: Variaveis extras para execucao '${extraVars}' do workflow '${workflowId}' '
                resp=$(docker run --rm $runin tower-cli \
                              workflow_job launch --workflow-job-template=$workflowId \
                              --extra-vars="${extraVars}")
            else
                resp=$(docker run --rm $runin tower-cli \
                              workflow_job launch --workflow-job-template=$workflowId)
            fi 

            deploymentId=$(echo $resp |cut -d' ' -f15)
            deployCreated=$(echo $resp |cut -d' ' -f17)
            statusDeploy=$(echo $resp |cut -d' ' -f18)
        ;;
    esac

    if [ "$deploymentId" == "" ] || [ "$deployCreated" == "" ]; then
        errorMsg 'ansibleLib.sh->runDeploymentsAnsible: Algo de errado aconteceu no start do deploy impossivel prosseguir. Resultado: '$resp''
        if [ "$deploymentId" != "" ]; then
            docker run --rm $runin tower-cli job stdout $deploymentId
        fi
        exit 1
    fi
}

# /**
# * statusDeployAnsible
# * Método que verificar percentual de status do deploy
# * @version 4.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param
# * @return
# */
statusDeployAnsible (){
    case $typeExecution in
        job)
            infoMsg 'ansibleLib.sh->statusDeployAnsible: Monitorando status do deploy '${typeExecution}'['${jobId}']->'${deploymentId}' em '${ansibleServer}''
            infoMsg 'ansibleLib.sh->statusDeployAnsible: '${typeExecution}'['${jobId}']->'${deploymentId}': '${statusDeploy}' - '${statusElapsed}' '

            while [ "$statusDeploy" != "successful" ]; do
                
                resp=''
                errors=''
                statusDeploy=''
                statusElapsed=''

                resp=$(docker run --rm $runin tower-cli job status ${deploymentId})

                statusDeploy=$(echo "$resp" | awk 'NR == 4 {print $3}')
                errors=$(echo "$resp" | awk 'NR == 4 {print $2}')
                statusElapsed=$(echo "$resp" | awk 'NR == 4 {print $1}')
                
                infoMsg 'ansibleLib.sh->statusDeployAnsible: '${typeExecution}'['${jobId}']->'${deploymentId}': '${statusDeploy}' - '${statusElapsed}' '

                if [ "$statusDeploy" == "failed" ]; then
                    errorMsg 'ansibleLib.sh->statusDeployAnsible: Foi encontrado o erro no deploy do job '${jobId}' de id '${deploymentId}''
                    errorMsg 'ansibleLib.sh->statusDeployAnsible: Status do job: '
                    errorMsg "$resp"
                    return
                fi

                sleep 2
            done
        ;;
        workflow)
            infoMsg 'ansibleLib.sh->statusDeployAnsible: Monitorando status do deploy '${typeExecution}'['${workflowId}']->'${deploymentId}' em '${ansibleServer}''
            infoMsg 'ansibleLib.sh->statusDeployAnsible: '${typeExecution}'['${workflowId}']->'${deploymentId}': '${statusDeploy}' - '${statusElapsed}' '

            while [ "$statusDeploy" != "successful" ]; do
                resp=''
                errors=''
                statusDeploy=''
                statusElapsed=''

                resp=$(docker run --rm $runin tower-cli workflow_job status ${deploymentId})

                statusDeploy=$(echo "$resp" | awk 'NR == 4 {print $3}')
                statusElapsed=$(echo "$resp" | awk 'NR == 4 {print $1}')
                
                infoMsg 'ansibleLib.sh->statusDeployAnsible: '${typeExecution}'['${workflowId}']->'${deploymentId}': '${statusDeploy}' - '${statusElapsed}' '

                if [ "$statusDeploy" == "failed" ]; then
                    errorMsg 'ansibleLib.sh->statusDeployAnsible: Foi encontrado o erro no deploy do workflow '${jobId}' de id '${deploymentId}''
                    errorMsg 'ansibleLib.sh->statusDeployAnsible: Descricao do erro '${resp}' '
                    return
                fi

                sleep 2
            done
            
            resp=$(docker run --rm $runin tower-cli workflow_job summary ${deploymentId})

            echo "${resp,,}" | egrep 'failed' >/dev/null
            if [ $? -eq 0 ]; then
                errorMsg 'ansibleLib.sh->statusDeployAnsible: Foi encontrado o erro no deploy do workflow '${workflowId}' de id '${deploymentId}''
                errorMsg 'ansibleLib.sh->statusDeployAnsible: Descricao do erro '${resp}' '
                errors='true'
                return
            fi 
        ;;
    esac
}


# /**
# * deploymentsAnsible
# * Método que orquestra o deploy no ansible tower
# * @version 4.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   $runin
# *          $typeExecution 
# *          $workflowId 
# *          $jobId 
# *          $extraVars
# * @return  true / false
# */
deploymentsAnsible (){
    runin=''
    typeExecution=''
    workflowId=0 
    jobId=0
    extraVars=''

    test ! -z $1 || { errorMsg 'ansibleLib.sh->deploymentsAnsible: Executor nao informado' ; exit 1; }
	test ! -z $2 || { errorMsg 'ansibleLib.sh->deploymentsAnsible: Tipo de execucao nao informada' ; exit 1; }

    runin=$1
    typeExecution=$2
    workflowId=$3
    jobId=$4
    extraVars=$5
    
    case $runin in
        tower) 
            ansibleServer=$(getCredentialsHost tower)
            ansibleUser=$(getCredentialsUser tower)
            runin="$awsAccount.dkr.ecr.sa-east-1.amazonaws.com/ansible-tower-cli"
        ;;
        tower-experian) 
            ansibleServer=$(getCredentialsHost tower-experian)
            ansibleUser=$(getCredentialsUser tower-experian)
            runin="$awsAccount.dkr.ecr.sa-east-1.amazonaws.com/ansible-tower-cli-experian"
        ;;
        tower-experian-us) 
            ansibleServer=$(getCredentialsHost tower-experian-us)
            runin="$awsAccount.dkr.ecr.sa-east-1.amazonaws.com/ansible-tower-cli-experian-us"
        ;;
        awx-midd) 
            ansibleServer=$(getCredentialsHost awx-midd)
            ansibleUser=$(getCredentialsUser awx-midd)
            runin="$awsAccount.dkr.ecr.sa-east-1.amazonaws.com/ansible-awx-cli-middleware"
        ;;
        *) errorMsg 'ansibleLib.sh->deploymentsAnsible: Executor informado '${runin}' nao existe' ; exit 1;;
    esac
 
    infoMsg 'ansibleLib.sh->deploymentsAnsible: Executor selecionado para deploy '${runin}' '
    infoMsg 'ansibleLib.sh->deploymentsAnsible: Iniciando Deploy'

    runDeploymentsAnsible
    statusDeployAnsible

    if [ "$errors" == "true" ]; then
        errorMsg 'ansibleLib.sh->deploymentsAnsible: Detalhes do erro'
        docker run --rm $runin tower-cli job stdout $deploymentId
        errorMsg 'ansibleLib.sh->deploymentsAnsible: Deploy apresentou erros, realizando rollback'
        exit 1
    fi
}