#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto Service Catalog Infrastructure Serasa Experian 
# *
# * @package        Service Catalog Infrastructure
# * @name           engine.sh
# * @version        2.3.0
# * @description    Script que controla o motor de execuções
# * @copyright      2020 &copy Serasa Experian
# *
# * @version        2.3.0
# * @change         - [BUG] Display de vault em modo debug;
# *                 - [FEATURE] Normalização dos logs, remoção da função sendLog;
# * @author         DevSecOps Architecture Brazil
# * @contribution   Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @dependencies   /opt/DevOps/bin/snow.sh       
# *                 /usr/local/bin/jq
# *                 /usr/local/bin/yq
# *                 mysql client
# * @references     https://medium.com/@timhberry/terraform-pipelines-in-gitlab-415b9d842596
# * @date           20-Jul-2021
# *
# * @version        2.1.0
# * @change         - [FEATURE] Criação da branch de homolog para realizar homologações diretamente por ela;
# *                 - [BUG] Correção de update de submodules;
# * @author         DevSecOps Architecture Brazil
# * @contribution   Alison Pereira <Alison.Pereira@br.experian.com>
# *                 Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @dependencies   /opt/DevOps/bin/snow.sh       
# *                 /usr/local/bin/jq
# *                 /usr/local/bin/yq
# *                 mysql client
# * @references     https://medium.com/@timhberry/terraform-pipelines-in-gitlab-415b9d842596
# * @date           30-01-2021
# *
# * @version        1.0.0
# * @change         - [FEATURE] Implementação inicial de conceito
# * @author         DevSecOps Architecture Brazil
# * @contribution   Marcelo Oliveira <Marcelo.Oliveira@br.experian.com>
# *                 Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# *                 Luiz Bartholomeu <Luiz.Bartholomeu@br.experian.com>
# * @dependencies   /opt/DevOps/bin/snow.sh       
# *                 /usr/local/bin/jq
# *                 /usr/local/bin/yq
# *                 mysql client
# * @references     https://medium.com/@timhberry/terraform-pipelines-in-gitlab-415b9d842596
# * @date           07-07-2020
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

#/**
# * implementationNumber
# * Define o numero da implantação corrente
# * @var string
# **/
implementationNumber=''
if [ "$1" != "" ]; then implementationNumber="$1"; fi

# /**
# * template
# * Define o template de implementacao
# * @var boolean
# **/
template="" 
if [ "$2" != "" ]; then template="$2"; fi

#/**
# * rolloutPlan
# * Recebe o plano de rollout implantações liberadas
# * @var string
# **/
rolloutPlan=''
if [ "$3" != "" ]; then rolloutPlan="$3"; fi
rolloutPlan=$(echo $rolloutPlan|sed -e 's/\\//;s/\\//')

#/**
# * debugMode
# * Define modo debug
# * @var string
# **/
debugMode=''
if [ "$4" != "" ]; then debugMode="$4"; fi

#/**
# * jobId
# * Define o job id do launch
# * @var string
# **/
jobId=''
if [ "$5" != "" ]; then jobId="$5"; fi

#/**
# * changeorderNumber
# * Define o numero da OM para launch tipo itil
# * @var string
# **/
changeorderNumber=''
if [ "$6" != "" ]; then changeorderNumber="$6"; fi

#/**
# * workSpace
# * Define o base da workspace
# * @var string
# **/
workSpace='/opt/jenkins/.joaquin/workspace'

#/**
# * build
# * Define o numero do build da implantacao
# * @var string
# **/
build=''

#/**
# * implementationStatus
# * Define o status da implantação
# * @var string
# **/
implementationStatus=''

#/**
# * implementationProject
# * Define o projeto implantação
# * @var string
# **/
implementationProject=''

#/**
# * implementationNameResource
# * Define o recurso da implantação
# * @var string
# **/
implementationNameResource=''

#/**
# * implementationBu
# * Define a BU da implantação
# * @var string
# **/
implementationBu=''

#/**
# * implementationEnvironment
# * Define o ambiente implantação
# * @var string
# **/
implementationEnvironment=''

#/**
# * implementationLog
# * Define o map da implantação para log
# * @var string
# **/
implementationLog=''

#/**
# * implementationCategory
# * Define a categoria de implementações para o scan de liberação
# * @var string
# **/
implementationCategory='Brazil%20DevSecOps%20Infrastructure%20Service%20Catalog'

#/**
# * listImplementationsNumber
# * Recebe os numeros das implantações liberadas
# * @var string
# **/
listImplementationsNumber=''

#/**
# * timePlanStart
# *  Define o tempo inicial de execução gasto no plano
# * @var string
# **/
timePlanStart=''

#/**
# * timePlanEnd
# * Define o tempo final de execução gasto no plano
# * @var string
# **/
timePlanEnd=''

#/**
# * timePlanSpent
# * Define o tempo total de execução gasto no plano
# * @var string
# **/
timePlanSpent=''

#/**
# * planStatus
# * Define o status do plano 0 - sucesso | 1 - falha
# * @var string
# **/
planStatus=''

#/**
# * bitbucketProject
# * Define  projeto  bitbucket
# * @var string
# **/
bitbucketProject="https://code.br.experian.local/scm/scib"

#/**
# * gitBranch
# * Define  a branch
# * @var string
# **/
gitBranch=""

#/**
# * flagError
# * Define flag para erros
# * @var boolean
# **/
flagError=""

# /**
# * Funções
# */

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
# * replace
# * Método faz o replace da env's no arquivos para os planos de implementação
# * @version 2.3.0
# * @package Service Catalog Infrastructure
# * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @return  true | false
# **/
replace () {
    local files=$(echo $1 | sed "s/,/ /g")
    local fileMap="/tmp/$(date +%s).json"
    echo $rolloutPlan > $fileMap
    local map=($(/usr/local/bin/jq --raw-output -r '. | keys | @sh' $fileMap | sed "s/'//g" ))
    rm -f $fileMap
    local value=''
    local key=''

    logMsg 'engine.sh->replace : Apply environments' "INFO"
    echo "Map: ${map[@]}"
    echo "Files: ${files}"

    for (( x = 0 ; x < ${#map[@]} ; x++ ))
    do
        key=$(echo ${map[$x]} | tr '[:lower:]' '[:upper:]' )
        value=$(echo $rolloutPlan | /usr/local/bin/jq -r ".${map[$x]}"| sed -e "s/#/\\\#/g")

        if [ "$debugMode" == "true" ]; then
           logMsg 'engine.sh->replace : key->'$key' ' "DEBUG"
        fi
        
        # Check if string contains "&". If not, use the standard sed command
        if echo "$value" | grep -q '&'; then
            sed -i "s#@@$key@@#${value//&/\\&}#g" "$files"
        else
            sed -i "s#@@$key@@#$value#g" $files
        fi

        key=''
        value=''
    done

    sed -i "s#@@OM@@#$implementationNumber#g" $files
}

# /**
# * beforePlan
# * Método executa os steps de preparações antes do plano de implamentação
# * @version 1.0.0
# * @package Service Catalog Infrastructure
# * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @return  true | false
# **/
beforePlan () {
    local operation=''
    local line=''
    local files=''

    for (( i=0; i < $(/usr/local/bin/yq r -j joaquin-infra.yml | /usr/local/bin/jq -r '.before_plan | length') ; i++ ))
    do
        line=$(/usr/local/bin/yq r -j joaquin-infra.yml | /usr/local/bin/jq -r '.before_plan['${i}']')
        operation=$(echo $line | awk '{print $1}')

        case $operation in
            replace)
                files=$(echo $line | awk '{print $2}')
                replace $files
                ;;
            *)
                logMsg 'engine.sh->beforePlan : Operation not exist '${operation}' ' "ERROR"
                ;;
        esac

        operation=''
        line=''
        files=''
    done
}

# /**
# * plan
# * Método executa o plano de implementação
# * @version 1.0.0
# * @package Service Catalog Infrastructure
# * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @return  true | false
# **/
plan () {
    timePlanStart=''
    timePlanEnd=''
    timePlanExecution=''
    local commandPlan=''
    local commandReturn=''
    flagError=''
    planStatus=''

    timePlanStart=$(date +%s)

    for (( i=0; i < $(/usr/local/bin/yq r -j joaquin-infra.yml | /usr/local/bin/jq -r '.plan | length') ; i++ ))
    do
        commandPlan=$(/usr/local/bin/yq r -j joaquin-infra.yml | /usr/local/bin/jq -r '.plan['${i}']')
        logMsg 'engine.sh->plan : Execution command plan' "INFO"
        echo "Command: $commandPlan"
        $commandPlan
        commandReturn=$?
        echo "Code Return Command: $commandReturn"
        if [ $commandReturn -eq 0 ]; then
            logMsg 'engine.sh->plan : Success in execution command plan' "INFO"
        else
            flagError='true'
            timePlanEnd=$(date +%s)
            timePlanSpent=0
            planStatus=1
            logMsg 'engine.sh->plan : Opsss, Error in execution command plan' "ERROR"
            return
        fi
        commandPlan=''
        commandReturn=''
    done

    timePlanEnd=$(date +%s)
    timePlanSpent=$(echo $((timePlanEnd-timePlanStart)))
    timePlanSpent=$((timePlanSpent/60))
    planStatus=0
    if [ $timePlanSpent -eq 0 ]; then timePlanSpent=1; fi

    logMsg 'engine.sh->plan : Time spent creating the infrastructure '${timePlanSpent}' minutes ' "INFO"
}

# /**
## * getImplementations
# * Método busca implantações liberadas
# * @version 1.0.0
# * @package Service Catalog Infrastructure
# * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @return  true | false
# **/
getImplementations () {
    listImplementationsNumber=''

    if [ "$itil" == "true" ]; then
        logMsg 'engine.sh->getImplementations : Active implementation FAKE for homologation ' "WARN"
        listImplementationsNumber="$implementationNumber" 
    else
        logMsg 'engine.sh->getImplementations : Implementation of the category '$implementationCategory' released for execution ' "INFO"
        listImplementationsNumber=$(/opt/DevOps/bin/snow.sh --action=get-change-open-category --category="$implementationCategory") 
    fi
    
    if [ "$listImplementationsNumber" != "" ];then 
        echo "List: $listImplementationsNumber"
    else
        logMsg 'engine.sh->getImplementations : Not implementation of the category '$implementationCategory' released for execution ' "WARN"
    fi
}

# /**
# * closeImplementations
# * Método fecha uma implementação
# * @version 1.0.0
# * @package Service Catalog Infrastructure
# * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @return  true | false
# **/
closeImplementations () {
    local changeorderWorkStart=$(date +'%Y-%m-%d %H:%M:%S' -d "@$timePlanStart")
    local changeorderWorkEnd=$(date +'%Y-%m-%d %H:%M:%S' -d "@$timePlanEnd")
    local changeorderCloseCode="successful"
    local changeorderCloseNotes="Implementacao realizada com sucesso pelo joaquinX"
    local dbServer='10.96.170.153'
    local dbUser=$(cat $secretJsonFile | /usr/local/bin/jq -r '.db_bi.access_key')
    local dbToken=$(cat $secretJsonFile | /usr/local/bin/jq -r '.db_bi.access_secret')
    local dbDatabase='devops'
    local dbQuery=''

    if [ "$itil" == "true" ]; then
        if [ "$flagError" == "true" ]; then
            logMsg 'engine.sh->closeImplementations : Error in implementation FAKE '${implementationNumber}' success' "ERROR"
            exit 1
        else
            logMsg 'engine.sh->closeImplementations : Close implementation FAKE '${implementationNumber}' success' "INFO"
            cd "$workSpace"
            logMsg 'engine.sh->closeImplementation : Remove workspace '$workSpace/$implementationNumber/$build/'' "INFO"
            #rm -rf "$workSpace/$implementationNumber/$build"
        fi
    else
        if [ "$flagError" == "true" ]; then
            implementationStatus='error'
            logMsg 'engine.sh->closeImplementations : Implementation '${implementationNumber}' error found send to analyze ' "ERROR"
        else
            implementationStatus='successful'
            logMsg 'engine.sh->closeImplementations : Implementation '${implementationNumber}' sucess send to BI' "INFO"
            logMsg 'engine.sh->closeImplementations : Close implementation '${implementationNumber}'' "INFO"
            /opt/DevOps/bin/snow.sh  --action=close-change \
                                     --number-change=$implementationNumber \
                                     --close-code=${changeorderCloseCode} \
                                     --close-notes="${changeorderCloseNotes}" \
                                     --work-start=${changeorderWorkStart} \
                                     --work-end=${changeorderWorkEnd}
            logMsg 'engine.sh->closeImplementations : Close implementation '${implementationNumber}' success' "INFO"
            cd "$workSpace"
            logMsg 'engine.sh->closeImplementation : Remove workspace '$workSpace/$implementationNumber/$build/'' "INFO"
            rm -rf "$workSpace/$implementationNumber/$build"
        fi

        dbQuery="INSERT INTO JOAQUINX (project,name_resource,bu,environment,template,date_execution,time_plan_spent,status,implementation_number,log) VALUES('$implementationProject','$implementationNameResource','$implementationBu','$implementationEnvironment','$template','$changeorderWorkStart','$timePlanSpent','$implementationStatus','$implementationNumber','$implementationLog')"

        if ! mysql -h $dbServer -u $dbUser -e "$dbQuery" $dbDatabase -p"$dbToken"; then
            logMsg 'engine.sh->closeImplementations : Opsss, Error in send '${implementationNumber}' for data base' "ERROR"
        else
            logMsg 'engine.sh->closeImplementations : Success in send '${implementationNumber}' for data base' "INFO"
        fi
    fi
}

# /**
# * getRolloutPlan
# * Método busca o rollout implantações liberadas
# * @version 2.3.0
# * @package Service Catalog Infrastructure
# * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @return  true | false
# **/
getRolloutPlan () {
    logMsg 'engine.sh->getRolloutPlan : Rollout found' "INFO"    
}

# /**
# * getTemplate
# * Método busca o template da execução do rollout
# * @version 2.1.0
# * @package Service Catalog Infrastructure
# * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @return  true | false
# **/
getTemplate () {
    local where="$1"
    local retry=0
    
    if [ "$0" == "/opt/deploy/hom-joaquin-x/bin/engine.sh" ]; then
        gitBranch="homolog"
        logMsg 'engine.sh->getTemplate : Choice branch '${gitBranch}' for execution ' "INFO"
    else
        gitBranch="master"
    fi

    logMsg 'engine.sh->getTemplate : Get template '${template}'('${gitBranch}') for '$where/$template' ' "INFO"
    while ! git clone --branch ${gitBranch} --recurse-submodules "$bitbucketProject/$template.git" $where/$template; do
        logMsg 'engine.sh->getTemplate : Falha ao realizar clone do Bitbucket. Realizando higienização e tentando novamente...'
        retry=$((retry + 1))

        rm -rf $where/$template

        if [ $retry -eq 3 ]; then
	   	    logMsg 'engine.sh->getTemplate : Impossível seguir com clone a partir da mirror BR. Alterando para mirror global...'
            bitbucketProject="https://code.experian.local/scm/scib"
		elif [ $retry -eq 6 ]; then
            logMsg 'engine.sh->getTemplate : Falha ao realizar clone no BitBucket. Contate o time global responsável pela ferramenta'
            exit 1
        fi

        sleep 10
    done

    logMsg 'engine.sh->getTemplate : Framework assembled for execution' "INFO"
    chmod a+x $where/$template -Rf
    ls -lha  $where/$template

    logMsg 'engine.sh->getTemplate : Change to dir '$workSpace/$implementationNumber/$build/$template'' "INFO"
    cd "$workSpace/$implementationNumber/$build/$template"

    if [ -e .gitmodules ] ; then 
        logMsg 'engine.sh->getTemplate : Aplicando update de submodules' "INFO"
        git submodule foreach 'git stash'
        git submodule update --remote --merge
    else 
        logMsg 'engine.sh->getTemplate : Ignorando update de submodules' "INFO"
    fi
}

# /**
# * Start
# */

logMsg 'engine.sh : Set proxy' "INFO"
export NO_PROXY=localhost,.serasa.intranet,10.0.0.0/8,.experian.local,.es.amazonaws.com,grafana,cmak,spobrcatalog
export FTP_PROXY=http://proxy.serasa.intranet:3128
export SOCKS_PROXY=http://proxy.serasa.intranet:3128
export HTTPS_PROXY=http://proxy.serasa.intranet:3128
export HTTP_PROXY=http://proxy.serasa.intranet:3128

logMsg 'engine.sh : Initializing Variables' "INFO"
build=$(date +%s)

logMsg 'engine.sh : Job request launch '${jobId}' ' "INFO"

if [ "$changeorderNumber" == "" ]; then
    logMsg 'engine.sh : Launch not using process ITIL for execution ' "INFO"
else
    logMsg 'engine.sh : Process ITIL number '${changeorderNumber}' for execution ' "INFO"
fi

logMsg 'engine.sh : Create workspace' "INFO"
logMsg 'engine.sh : Execution implementation  in '$workSpace/$implementationNumber/$build'' "INFO"
mkdir -p $workSpace/$implementationNumber/$build

logMsg 'engine.sh : Read rollout plan' "INFO"
getRolloutPlan

logMsg 'engine.sh : Get template '${template}' for execution' "INFO"
getTemplate "$workSpace/$implementationNumber/$build"
    
logMsg 'engine.sh : Start implementation '${implementationNumber}' ' "INFO"
beforePlan
plan

if [ "$debugMode" != "true" ]; then
    logMsg 'engine.sh : Remove workspace temp' "INFO" 
    cd ..
    rm -rf $template
else
    logMsg 'engine.sh : Debug active not remove workspace temp' "DEBUG" 
fi

if [ "$flagError" == "true" ]; then
    logMsg 'engine.sh : End implementation '${implementationNumber}' with error' "ERROR"
    exit 1
fi

logMsg 'engine.sh : End implementation '${implementationNumber}' ' "INFO"