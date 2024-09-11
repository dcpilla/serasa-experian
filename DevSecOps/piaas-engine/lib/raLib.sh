#!/usr/bin/env bash

VERSION='3.2.0'

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           raLib.sh
# * @version        $VERSION
# * @description    Biblioteca com as chamadas para CA Realese Automation
# * @copyright      2018 &copy Serasa Experian
# *
# * @version        3.2.0
# * @change         Tratar json via jq
# * @copyright      2018 &copy Serasa Experian
# * @author         Joao Aloia < joao.aloia@br.experian.com >
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 curl
# *                 /usr/local/bin/jq
# * @date           22-Out-2018
# *
# * @version        3.1.0
# * @change         Implementação blue&green
# * @copyright      2018 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 curl
# * @date           15-Mar-2017
# *
# * @version        3.0.0
# * @description    Biblioteca com as chamadas para CA Realese Automation
# * @copyright      2018 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 curl
# * @date           17-Jan-2017
# *
# **/

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

# Carrega wasLib
test -e "$baseDir"/lib/wasLib.sh || echo 'Ops, biblioteca wasLib nao encontrada'
source "$baseDir"/lib/wasLib.sh

# /**
# * Variaveis
# */

# /**
# * caServer
# * Servidor Realise Automation
# * @var string
# */
caServer=`getCredentialsHost cara`

# /**
# * caUser
# * Usuário Realise Automation
# * @var string
# */
caUser=`getCredentialsUser cara`

# /**
# * caToken
# * Token Realise Automation
# * @var string
# */
caToken=`getCredentialsToken cara`

# /**
# * jenkinsUser
# * usuário jenkins
# * @var string
# */
jenkinsUser=`getCredentialsUser jenkins`

# /**
# * caToken
# * Token jenkins
# * @var string
# */
jenkinsToken=`getCredentialsToken jenkins`


# /**
# * Variaveis padrões para chamada ao CA RA
# */
raProject="Continuous_Integration"
deploymentTemplate="Deploy_Rollout"
templateCategory="CI"

# /**
# * deploymentPlan
# * Define o nome do plano de deploy
# * @var string
# */
deploymentPlan=

# /**
# * deployment
# * Define o nome de deploy
# * @var string
# */
deployment=

# /**
# * deploymentPlanId
# * Define o id do plano de deploy
# * @var string
# */
deploymentPlanId=

# /**
# * deploymentId
# * Define o id de deploy
# * @var string
# */
deploymentId=

# /**
# * application
# * Define a aplication do CA RA
# * @var string
# */
application=


# /**
# * build
# * Define a versão do build da aplicação para o deploy
# * @var string
# */
build=

# /**
# * urlPackage
# * Define a url do pacote a fazer o deploy
# * @var string
# */
urlPackage=

# /**
# * method
# * Define o metodo para fazer o deploy
# * @var string
# */
method=

# /**
# * environmentSigla
# * Define a sigla ambiente para fazer o deploy
# * @var string
# */
environmentSigla=

# /**
# * environment
# * Define o ambiente para fazer o deploy
# * @var string
# */
environment=

# /**
# * instanceName
# * Define o nome da instancia a fazer o deploy em caso de provisionamento
# * @var string
# */
instanceName=

# /**
# * clusterName
# * Define o nome do cluster da aplicação
# * @var string
# */
clusterName=

# /**
# * contextRoot
# * Define o contextRoot da aplicação
# * @var string
# */
contextRoot=

# /**
# * userNameInstance
# * Define o nome do usuário da instancia a fazer o deploy em caso de provisionamento
# * @var string
# */
userNameInstance=

# /**
# * demandaInstance
# * Define a demanda da instancia a fazer o deploy em caso de provisionamento
# * @var string
# */
demandaInstance=


# /**
# * stageState
# * Define o status do deploy
# * @var string
# */
stageState=

# /**
# * releaseErrors
# * Define a msg de erro do deploy
# * @var string
# */
releaseErrors=

# /**
# * statusProcessDeploy
# * Define o percentual de deploy
# * @var string
# */
statusProcessDeploy=

# /**
# * urlJvm
# * Define a url do provisionamento was
# * @var string
# */
urlJvm=

# /**
# * flagErrorDeploy
# * Define flag de erro de deploy
# * @var string
# */
flagErrorDeploy=0

# /**
# * jdkVersion
# * Define versão do java
# * @var string
# */
jdkVersion=

# /**
# * Funções
# */

# /**
# * setUserNameInstance
# * Método que seta o nome do usuário extraido de instanceName
# * @version 3.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @return
# */
setUserNameInstance (){
    userNameInstance=''

    userNameInstance=$(echo $instanceName|cut -d'_' -f 1)
}

# /**
# * setCluster
# * Método que seta o cluster da aplicação
# * @version 3.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @return
# */
setCluster (){
    clusterName=''
    file=''
    fileTemp=''

    fileTemp="/tmp/`date +%s`.xml"
    deployXmlEar="META-INF/ibmconfig/cells/defaultCell/applications/defaultApp/deployments/defaultApp/deployment.xml"


    file=$(echo $urlPackage | sed "s/^.*\///")
    infoMsg 'raLib.sh->setCluster : Buscando cluster no pacote '${file}''
    file=/tmp/$file
	wget "$urlPackage" -O $file 2>/dev/null

    unzip -p "$file" "$deployXmlEar" | sed 's/xmlns=".*"//g' | sed 's/\(\w\+:\)schemaLocation=".*"//g' > $fileTemp

    clusterName=`xmllint --nowarning --xpath "//deploymentTargets/@name" $fileTemp |cut -d"=" -f 2| sed -e 's/\"//g'`

    if [ "$clusterName" == "" ]; then
        errorMsg 'raLib.sh->setCluster : Nao encontrado o nome do cluster para iniciar o deploy'
        infoMsg 'raLib.sh->setCluster : Aplicacao '${application}' ja foi enrriquecida?'
        infoMsg 'raLib.sh->setCluster : O arquivo de deployment.xml existe no EAR?'
        rm -f $file && rm -f $fileTemp
        exit 1
    fi

    infoMsg 'raLib.sh->setCluster : '${clusterName}''
    rm -f $file && rm -f $fileTemp
}

# /**
# * setJdkVersion
# * Método que extrai o valor da jdkVersion da aplicação
# * @version 3.0.0
# * @package DevOps
# * @author  João Aloia <Joao.Aloia@br.experian.com>
# * @return
# */
setJdkVersion (){
    jdkVersion=''
    file=''
    fileTemp=''

    fileTemp="/tmp/`date +%s`.MF"
    manifest="META-INF/MANIFEST.MF"


    file=$(echo $urlPackage | sed "s/^.*\///")
    infoMsg 'raLib.sh->setJdkVersion : Buscando o arquivo MANIFEST no pacote '${file}''
    file=/tmp/$file
    wget "$urlPackage" -O $file 2>/dev/null

    unzip -p "$file" "$manifest" > $fileTemp

    jdkVersion=`cat $fileTemp | grep Build-Jdk |cut -d":" -f 2|cut -d"." -f 2`

    if [ "$jdkVersion" == "" ]; then
        errorMsg 'raLib.sh->setJdkVersion : Nao encontrado a versao java no MANIFEST.MF do pacote'
        rm -f $file && rm -f $fileTemp
        exit 1
    fi

    infoMsg 'raLib.sh->setJdkVersion : Versao do jdk encontrada '${jdkVersion}''
    rm -f $file && rm -f $fileTemp
}


# /**
# * setContextRoot
# * Método que seta o contexto root da aplicação
# * @version 3.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @return
# */
setContextRoot (){
    contextRoot=''
    file=''
    fileTemp=''

    fileTemp="/tmp/`date +%s`.xml"
    applicationXml="META-INF/application.xml"

    file=$(echo $urlPackage | sed "s/^.*\///")
    infoMsg 'raLib.sh->setContextRoot : Buscando contextoroot da aplicacao no pacote '${file}''
    file=/tmp/$file
    wget "$urlPackage" -O $file 2>/dev/null

    unzip -p "$file" "$applicationXml" | sed 's/xmlns=".*"//g' | sed 's/\(\w\+:\)schemaLocation=".*"//g' > $fileTemp

    contextRoot=`xmllint --nowarning --xpath "/application/module/web/context-root/text()" $fileTemp`

    if [ "$contextRoot" == "" ]; then
        errorMsg 'raLib.sh->setContextRoot : Nao encontrado o nome do contextRoot para iniciar o deploy'
        infoMsg 'raLib.sh->setContextRoot : Aplicacao '${application}' ja foi enrriquecida?'
        infoMsg 'raLib.sh->setContextRoot : O arquivo de application.xml existe no EAR?'
        rm -f $file && rm -f $fileTemp
        exit 1
    fi

    infoMsg 'raLib.sh->setContextRoot : ContextoRoot encontrado '${contextRoot}''
    rm -f $file && rm -f $fileTemp
}

# /**
# * setDemandaInstance
# * Método que seta a demanda extraido de instanceName
# * @version 3.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @return
# */
setDemandaInstance (){
    demandaInstance=''

    demandaInstance=$(echo $instanceName|cut -d'_' -f 2)
}

# /**
# * setBuild
# * Método que seta o numero do build da url do pacote
# * @version 3.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @return
# */
setBuild (){
    build=''

    build=$(echo ${urlPackage} | cut -d '/' -f `echo ${urlPackage} | grep -o '/' | wc -l`)

    infoMsg 'raLib.sh->setBuild : '${build}' '
}

# /**
# * setDeploymentPlan
# * Método que seta o nome deploymentPlan
# * @version 3.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @return
# */
setDeploymentPlan (){
    deploymentPlan=''
    flag=''

    flag=`echo ${urlPackage} | grep -o '/' | wc -l`
    flag=`echo ${flag} + 1 |bc`

    deploymentPlan=$(echo ${urlPackage} | cut -d '/' -f ${flag})
    deploymentPlan=$deploymentPlan'_'$(date +%s)

    infoMsg 'raLib.sh->setDeploymentPlan : '${deploymentPlan}' '
}

# /**
# * setDeployment
# * Método que seta o nome deployment
# * @version 3.1.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @return
# */
setDeployment (){
    deployment=''

    if [ "$method" == "bluegreen" ]; then
        deployment=$deploymentPlan
    else
        deployment=$deploymentPlan'_'$environment
    fi

    infoMsg 'raLib.sh->setDeployment : '${deployment}' '
}

# /**
# * createDeploymentPlan
# * Método que cria um plano de deploy
# * @version 3.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @return
# */
createDeploymentPlan (){
    resp=''
    result=''
    deploymentPlanId=''

    infoMsg 'raLib.sh->createDeploymentPlan: Criando plano de deploy '${application}'->'${deploymentPlan}' '

    resp=$(curl --verbose \
                --request POST \
                --url  $caServer'create-deployment-plan' \
                --header 'accept: application/json' \
                --header 'authorization: Basic '$caToken'' \
                --header 'cache-control: no-cache' \
                --header 'content-type: application/json' \
                --data '{"deploymentPlan": "'${deploymentPlan}'", "application": "'${application}'", "build": "'${build}'", "project": "'${raProject}'", "deploymentTemplate": "'${deploymentTemplate}'", "templateCategory": "'${templateCategory}'" }' 2>/dev/null)

    result=`lerJSON "result" "$resp"`
    deploymentPlanId=`lerJSON "deploymentPlanId" "$resp"`

    if [ "$result" != "true" ]; then
        errorMsg 'raLib.sh->createDeploymentPlan : Algo de errado aconteceu na criacao do plano de deploy impossivel prosseguir. Resultado: '$resp''
        infoMsg 'raLib.sh->createDeploymentPlan : Aplicacao '${application}' existe?'
        infoMsg 'raLib.sh->createDeploymentPlan : Ja existe plano de deploy para esta versao da '${application}' criado no projeto?'
        infoMsg 'raLib.sh->createDeploymentPlan : Existe o projeto '${raProject}' para aplicacao?'
        infoMsg 'raLib.sh->createDeploymentPlan : Existe o template '${deploymentTemplate}' para aplicacao?'
        infoMsg 'raLib.sh->createDeploymentPlan : Existe a categoria de template '${templateCategory}' para aplicacao?'
        exit 1
    fi
}

# /**
# * loadManifest
# * Método que carrega o manifesto do deploy
# * @version 3.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param
# * @return
# */
loadManifest (){
	resp=''
    result=''

    infoMsg 'raLib.sh->loadManifest: Carregando manifesto '${application}'->'${deploymentPlan}'->'${method}' '

    case $method in
        normal)
           resp=$(curl   --verbose \
                         --request POST \
                         --url $caServer'load-manifest' \
                         --header 'accept: application/json' \
                         --header 'authorization: Basic '$caToken'' \
                         --header 'cache-control: no-cache' \
                         --header 'content-type: application/json' \
                         --data '{"deploymentPlan":"'${deploymentPlan}'", "application":"'${application}'", "environments":["'${environment}'"],"build":"'${build}'","project":"'${raProject}'","deploymentTemplate":"'${deploymentTemplate}'","manifest": "<?xml version=\"1.0\" encoding=\"UTF-8\"?><DeploymentManifest build=\"'${build}'\" name=\"'${deploymentPlan}'\" project=\"'${raProject}'\"><properties/><Deployment><step name=\"Deploy\"><Deploy><Application_Parameters><nexus_url>'${urlPackage}'</nexus_url><was_cluster><arrayParam>'${clusterName}'</arrayParam></was_cluster><was_password>'${jenkinsToken}'</was_password><was_user>'${jenkinsUser}'</was_user></Application_Parameters></Deploy></step></Deployment></DeploymentManifest>"}' 2>/dev/null)
        ;;
        provisioning)
            resp=$(curl  --verbose \
                         --request POST \
                         --url $caServer'load-manifest' \
                         --header 'accept: application/json' \
                         --header 'authorization: Basic '$caToken'' \
                         --header 'cache-control: no-cache' \
                         --header 'content-type: application/json' \
                         --data '{"deploymentPlan":"'${deploymentPlan}'", "application":"'${application}'", "environments":["'${environment}'"],"build":"'${build}'","project":"'${raProject}'","deploymentTemplate":"'${deploymentTemplate}'","manifest": "<?xml version=\"1.0\" encoding=\"UTF-8\"?><DeploymentManifest build=\"'${build}'\" name=\"'${deploymentPlan}'\" project=\"'${raProject}'\"><properties/><Deployment><step name=\"Deploy\"><Deploy><Application_Parameters><nexus_url>'${urlPackage}'</nexus_url><incidente>'${demandaInstance}'</incidente><was_cluster><arrayParam>'${instanceName}'</arrayParam></was_cluster><was_user>'${jenkinsUser}'</was_user><was_password>'${jenkinsToken}'</was_password></Application_Parameters></Deploy></step></Deployment><Post-Deployment><step name=\"Rollout\"><Rollout_Edition><Application_Parameters><incidente>'${demandaInstance}'</incidente><nexus_url>'${urlPackage}'</nexus_url></Application_Parameters></Rollout_Edition></step></Post-Deployment></DeploymentManifest>"}' 2>/dev/null)
        ;;
        green)
            resp=$(curl  --verbose \
                         --request POST \
                         --url $caServer'load-manifest' \
                         --header 'accept: application/json' \
                         --header 'authorization: Basic '$caToken'' \
                         --header 'cache-control: no-cache' \
                         --header 'content-type: application/json' \
                         --data '{"deploymentPlan":"'${deploymentPlan}'", "application":"'${application}'", "environments":["'${environment}'"],"build":"'${build}'","project":"'${raProject}'","deploymentTemplate":"'${deploymentTemplate}'","manifest": "<?xml version=\"1.0\" encoding=\"UTF-8\"?><DeploymentManifest build=\"'${build}'\" name=\"'${deploymentPlan}'\" project=\"'${raProject}'\"><properties/><Deployment><step name=\"Deploy_Green\"><Deploy_Green><Application_Parameters><nexus_url>'${urlPackage}'</nexus_url><was_user>'${jenkinsUser}'</was_user><was_password>'${jenkinsToken}'</was_password></Application_Parameters></Deploy_Green></step></Deployment><Post-Deployment></Post-Deployment></DeploymentManifest>"}' 2>/dev/null)
        ;;
        blue)
            resp=$(curl  --verbose \
                         --request POST \
                         --url $caServer'load-manifest' \
                         --header 'accept: application/json' \
                         --header 'authorization: Basic '$caToken'' \
                         --header 'cache-control: no-cache' \
                         --header 'content-type: application/json' \
                         --data '{"deploymentPlan":"'${deploymentPlan}'", "application":"'${application}'", "environments":["'${environment}'"],"build":"'${build}'","project":"'${raProject}'","deploymentTemplate":"'${deploymentTemplate}'","manifest": "<?xml version=\"1.0\" encoding=\"UTF-8\"?><DeploymentManifest build=\"'${build}'\" name=\"'${deploymentPlan}'\" project=\"'${raProject}'\"><properties/><Deployment><step name=\"Deploy_Blue\"><Deploy_Blue><Application_Parameters><nexus_url>'${urlPackage}'</nexus_url></Application_Parameters></Deploy_Blue></step></Deployment><Post-Deployment></Post-Deployment></DeploymentManifest>"}' 2>/dev/null)
        ;;
    esac

    result=`lerJSON "result" "$resp"`

    if [ "$result" != "true" ]; then
        errorMsg 'raLib.sh->loadManifest : Algo de errado aconteceu em carregar o plano de deploy impossivel prosseguir. Resultado: '$resp''
        infoMsg 'raLib.sh->loadManifest : Aplicacao '${application}' existe?'
        infoMsg 'raLib.sh->loadManifest : Existe o plano de deploy '${deploymentPlan}' para o projeto '${raProject}'?'
        infoMsg 'raLib.sh->loadManifest : Valide o manifesto enviado para o metodo '${method}'?'
        exit 1
    fi
}

# /**
# * runDeployments
# * Método de start do deploy
# * @version 3.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param
# * @return
# */
runDeployments (){
    resp=''
    result=''
    deploymentId=''

    infoMsg 'raLib.sh->runDeployments: Rodando deploy '${application}'->'${deploymentPlan}' '

    resp=$(curl --verbose \
                --request POST \
                --url $caServer'run-deployments' \
                --header 'accept: application/json' \
                --header 'authorization: Basic '$caToken'' \
                --header 'cache-control: no-cache' \
                --header 'content-type: application/json' \
                --data '{"deploymentPlan":"'${deploymentPlan}'", "deployment":"'${deployment}'", "build":"'${build}'", "application":"'${application}'", "environments":["'${environment}'"], "project":"'${raProject}'"} ' 2>/dev/null)

    result=`echo ${resp} | /usr/local/bin/jq '.[].result'|sed -e 's/"//;s/"//'`
    deploymentId=`echo ${resp} | /usr/local/bin/jq '.[].id'|sed -e 's/"//;s/"//'`

    if [ "$result" != "true" ]; then
        errorMsg 'raLib.sh->runDeployments : Algo de errado aconteceu no start do deploy impossivel prosseguir. Resultado: '$resp''
        exit 1
    else
        infoMsg 'raLib.sh->runDeployments : Id deploy criado '${deploymentId}'' 
    fi
}

# /**
# * releaseStatus
# * Método que verificar percentual de status do deploy
# * @version 3.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param
# * @return
# */
releaseStatus (){
    stageState=""
    
    infoMsg 'raLib.sh->releaseStatus: Monitorando status do deploy '${application}'->'${deploymentPlan}'->'${deploymentId}''

    while [ "$stageState" != "Succeeded" ]; do
    	resp=''
        result=''
        stageState=''
        releaseErrors=''
        statusProcessDeploy=''

        resp=`curl  --request GET \
                    --url $caServer'release-status/'${deploymentId} \
                    --header 'authorization: Basic '$caToken'' \
                    --header 'cache-control: no-cache' 2>/dev/null`

        result=`lerJSON "result" "$resp"`
        stageState=`lerJSON "stageState" "$resp"`
        releaseErrors=`lerJSON "releaseErrors" "$resp"`
        statusProcessDeploy=`lerJSON "description" "$resp"`

        infoMsg 'raLib.sh->releaseStatus: '${application}'->'${deploymentPlan}': '${stageState}' - '${statusProcessDeploy}' '

        if [  "$stageState" == "Running-With-Errors" ] || [  "$stageState" == "" ] ; then
            errorMsg 'raLib.sh->releaseStatus: Foi encontrado o erro de deploy Running-With-Errors '${deploymentPlan}' da aplicacao '${application}' '
            errorMsg 'raLib.sh->releaseStatus: Descricao do erro '${resp}' '
            stopRelease
            return
        elif [  "$stageState" == "Failed" ]; then
            errorMsg 'raLib.sh->releaseStatus: Foi encontrado o erro de deploy Failed '${deploymentPlan}' da aplicacao '${application}' '
            errorMsg 'raLib.sh->releaseStatus: Descricao do erro '${resp}' '
            flagErrorDeploy=1
            return
        fi
        sleep 3
    done
}

# /**
# * stopRelease
# * Método que faz o stop do deploy
# * @version 3.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param
# * @return
# */
stopRelease (){
    resp=''
    result=''

    resp=$(curl --request POST \
                --url $caServer'stop-release' \
                --header 'accept: application/json' \
                --header 'authorization: Basic '$caToken'' \
                --header 'cache-control: no-cache' \
                --header 'content-type: application/json' \
                --data '{"releaseId": "'${deploymentId}'", "application":"'${aplication}'", "release":"'${deploymentPlan}'", "environment": "'${environment}'", "version":"'${build}'"} ' 2>/dev/null)

    result=`lerJSON "result" "$resp"`

    if [ "$result" == "true" ]; then
        errorMsg 'raLib.sh->stopRelease : Abortando deploy'
        flagErrorDeploy=1
    fi
}

# /**
# * deploymentsNormal
# * Método que orquestra o deploy tipo normal
# * @version 3.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   $method
# * @param   $application
# * @param   $urlPackage
# * @param   $environment
# * @param   $instanceName
# * @return  true / false
# */
deploymentsNormal (){
	method=''
	urlPackage=''
	environment=''
	application=''

	test ! -z $1 || { errorMsg 'raLib.sh->deploymentsNormal : Metodo de deploy nao informado' ; exit 1; }
	test ! -z $2 || { errorMsg 'raLib.sh->deploymentsNormal : Application de deploy nao informado' ; exit 1; }
    test ! -z $3 || { errorMsg 'raLib.sh->deploymentsNormal : Url do pacote de deploy nao informado.' ; exit 1; }
    test ! -z $4 || { errorMsg 'raLib.sh->deploymentsNormal : Ambiente para deploy nao informado.' ; exit 1; }

    method=$1
    application=$2
    urlPackage=$3
    environment=$4
    environmentSigla=$environment

    setBuild
    setDeploymentPlan
    setDeployment
    setCluster

    case $environment in
        de) environment="Desenvolvimento";;
        deeid) environment="DesenvolvimentoEID";;
        hi) environment="Homologacao_Interna";;
        hieid) environment="Homologacao_InternaEID";;
        he) environment="Homologacao_Externa";;
        pi) environment="Producao_Interna";;
        pe) environment="Producao_Externa";;
        pefree) environment="Producao_Externa_FreeReport";;
        peeid) errorMsg 'raLib.sh->deploymentsNormal : Ambiente '${environment}' nao permitido para deploy automatizado' ; exit 1;;
    esac

    infoMsg 'raLib.sh->deploymentsNormal : Iniciando deploy no ambiente '${environment}' '

    createDeploymentPlan
    loadManifest
    runDeployments
    releaseStatus

    if [ $flagErrorDeploy -eq 1 ]; then
        errorMsg 'raLib.sh->deploymentsNormal: Deploy apresentou erros, realizando rollback'
        exit 1
    fi
}

# /**
# * deploymentsProvisioning
# * Método que orquestra o deploy tipo provisionamento
# * @version 3.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   $method
# * @param   $instanceName
# * @param   $urlPackage
# * @param   $environment
# * @return  true / false
# */
deploymentsProvisioning (){
    method=''
    urlPackage=''
    environment=''
    application='was_deploy_provisioned'
    instanceName=''

	test ! -z $1 || { errorMsg 'raLib.sh->deploymentsProvisioning : Metodo de deploy nao informado' ; exit 1; }
	test ! -z $2 || { errorMsg 'raLib.sh->deploymentsProvisioning : Instancia de deploy nao informado' ; exit 1; }
    test ! -z $3 || { errorMsg 'raLib.sh->deploymentsProvisioning : Url do pacote de deploy nao informado.' ; exit 1; }
    test ! -z $4 || { errorMsg 'raLib.sh->deploymentsProvisioning : Ambiente para deploy nao informado.' ; exit 1; }

    method=$1
    instanceName=$2
    urlPackage=$3
    environment=$4
    environmentSigla=$environment

    setBuild
    setDeploymentPlan
    setDeployment
    setUserNameInstance
    setDemandaInstance
    setCluster
    setContextRoot
    setJdkVersion

    case $environment in
        de) environment="Desenvolvimento";;
        deeid) environment="DesenvolvimentoEID";;
        hi) environment="Homologacao_Interna";;
        hieid) environment="Homologacao_InternaEID";;
        he) errorMsg 'raLib.sh->deploymentsProvisioning : Ambiente '${environment}' nao permitido para deploy automatizado' ; exit 1;;
        pi) errorMsg 'raLib.sh->deploymentsProvisioning : Ambiente '${environment}' nao permitido para deploy automatizado' ; exit 1;;
        pe) errorMsg 'raLib.sh->deploymentsProvisioning : Ambiente '${environment}' nao permitido para deploy automatizado' ; exit 1;;
        pefree) errorMsg 'raLib.sh->deploymentsProvisioning : Ambiente '${environment}' nao permitido para deploy automatizado' ; exit 1;;
        peeid) errorMsg 'raLib.sh->deploymentsProvisioning : Ambiente '${environment}' nao permitido para deploy automatizado' ; exit 1;;
    esac

    infoMsg 'raLib.sh->deploymentsProvisioning : Iniciando deploy no ambiente '${environment}' '
    infoMsg 'raLib.sh->deploymentsProvisioning: Criando JVM '${instanceName}' no ambiente WAS: '${environmentSigla}' '
    urlJvm=`callWasCreate $userNameInstance $demandaInstance $environmentSigla $jdkVersion`
    if echo "$urlJvm" | egrep '500' >/dev/null ; then
        echo 'raLib.sh->deploymentsProvisioning: 500 - Erro de comunicacao com  servidor WAS: '${urlJvm}' '
        exit 1
    elif echo "$urlJvm" | egrep '201' >/dev/null ; then
        echo 'raLib.sh->deploymentsProvisioning: 201 - Servidor WAS nao conseguiu realizar o provisionamento: '${urlJvm}' '
        exit 1
    fi
    infoMsg 'raLib.sh->deploymentsProvisioning:  Provisionamento realizado com sucesso em '${environmentSigla}' no endereco https://'${urlJvm}''${contextRoot}' '

    createDeploymentPlan
    loadManifest
    runDeployments
    releaseStatus

    if [ $flagErrorDeploy -eq 1 ]; then
        errorMsg 'raLib.sh->deploymentsProvisioning: Deploy apresentou erros, realizando rollback'
        warnMsg 'raLib.sh->deploymentsProvisioning: Removendo instancia '${instanceName}' criada no WAS em '${environmentSigla}' '
        callWasDelete $userNameInstance $demandaInstance $environmentSigla
        exit 1
    fi

    if [ "$environmentSigla" == "hi" ] || [ "$environmentSigla" == "hiEID" ] ; then
        infoMsg 'raLib.sh->deploymentsProvisioning: Verificando se existe JVM  '${instanceName}' para remocao no ambiente WAS: DE'
        callWasDelete $userNameInstance $demandaInstance "de"
        infoMsg 'raLib.sh->deploymentsProvisioning: Criando plano de deploy para implatacao pelo time de operacao em was_deploy'
        environment=''
        setDeployment
        method='normal'
        application='was_deploy'
        environment='Desenvolvimento'
        createDeploymentPlan
        loadManifest
    fi
}


# /**
# * deploymentsBlueGreen
# * Método que orquestra o deploy tipo blue & green
# * @version 3.1.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   $method
# * @param   $urlPackage
# * @return  true / false
# */
deploymentsBlueGreen (){
    method=''
    urlPackage=''
    raProject=''
    deploymentTemplate=''
    templateCategory=''
    application='was_bluegreen_deploy'
    environment='Desenvolvimento'

    test ! -z $1 || { errorMsg 'raLib.sh->deploymentsBlueGreen : Metodo de deploy nao informado' ; exit 1; }
    test ! -z $2 || { errorMsg 'raLib.sh->deploymentsBlueGreen : Url do pacote de deploy nao informado.' ; exit 1; }

    method=$1
    urlPackage=$2

    setBuild
    setDeploymentPlan
    setDeployment
    
    infoMsg 'raLib.sh->deploymentsBlueGreen : Iniciando deploy no ambiente '${environment}' '

    method='green'
    raProject='Green'
    deploymentTemplate='Deploy_Rollout'
    templateCategory='Green'

    infoMsg 'raLib.sh->deploymentsBlueGreen : Iniciando a criacao de plano de deploy Green'
    createDeploymentPlan
    infoMsg 'raLib.sh->deploymentsBlueGreen : Inicializando manifesto de deploy Green'
    loadManifest

    method='blue'
    raProject='Blue'
    deploymentTemplate='Deploy_Rollout'
    templateCategory='Blue'

    infoMsg 'raLib.sh->deploymentsBlueGreen : Iniciando a criacao de plano de deploy Blue'
    createDeploymentPlan
    infoMsg 'raLib.sh->deploymentsBlueGreen : Inicializando manifesto de deploy Blue'
    loadManifest
}