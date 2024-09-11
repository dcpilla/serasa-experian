#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           wasLib.sh
# * @version        3.0.0
# * @description    Biblioteca com as chamadas para WAS
# * @copyright      2017 &copy Serasa Experian
# *
# * @version        3.1.0
# * @description    [Feature] Suporte a deploy WAS via wsadmin para desativação do RA;
# * @copyright      2020 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# *                 Michel Miranda <Michel.Miranda@br.experian.com>
# *                 Thiago Costa <Thiago.Costa@br.experian.com>
# * @dependencies   common.sh
# *                 ansibleLib.sh
# *                 curl
# *                 /opt/infratransac/IBM/WebSphere/AppServer/profiles/Deploy/bin/wsadmin.sh
# *                 /opt/infratransac/IBM/ansible/was_install_app.py
# * @date           09-Jan-2020
# *
# * @version        3.0.0
# * @description    [Feature] Suporte a deploy WAS via ansible para desativação do RA;
# * @copyright      2019 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# *                 Michel Miranda <Michel.Miranda@br.experian.com>
# * @dependencies   common.sh
# *                 ansibleLib.sh
# *                 curl
# * @date           14-Out-2019
# * 
# * @version        2.1.0
# * @change         Biblioteca com as chamadas para WAS
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# * @date           02-Out-2017
# *
# * @version        2.0.0
# * @description    Biblioteca com as chamadas para WAS
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# * @date           10-Ago-2017
# *
# **/

# /**
# * Configurações iniciais
# */

# Carrega commons
test -e common.sh || echo 'Ops, biblioteca common nao encontrada'
source common.sh


# /**
# * Variaveis
# */

# /**
# * environment
# * Define o ambiente para fazer o deploy
# * @var string
# */
environment=''

# /**
# * environmentSigla
# * Define a sigla ambiente para fazer o deploy
# * @var string
# */
environmentSigla=''

# /**
# * wasDeployJobId
# * Define o id do job para deploy
# * @var string
# */
wasDeployJobId='570'

# /**
# * wasDeployMethod
# * Define metodo de deploy was
# * @var string
# */
wasDeployMethod=''

# /**
# * wasDmgr
# * Define o DMGR para o deploy
# * @var string
# */
wasDmgr=''

# /**
# * wasDmgrPort
# * Define o DMGR port para o deploy
# * @var string
# */
wasDmgrPort="8879"

# /**
# * wasDmgrUser
# * User DMGR para o deploy
# * @var string
# */
wasDmgrUser=''

# /**
# * wasDmgrPassword
# * Password DMGR para o deploy
# * @var string
# */
wasDmgrPassword=''

# /**
# * wasApplication
# * Define o nome da aplicação no WAS
# * @var string
# */
wasApplication=''

# /**
# * wasClusterName
# * Define o nome do cluster da aplicação
# * @var string
# */
wasClusterName=''

# /**
# * wasPackageDeploy
# * Define o pacote para deploy no was
# * @var string
# */
wasPackageDeploy=''

# /**
# * wasSleepStart
# * Define o tempo de esperar do start do WAS
# * @var string
# */
wasSleepStart=60

# /**
# * wasErrors
# * Define erros do WAS
# * @var string
# */
wasErrors="ADMA0010E|WASX7023E|WASX7017E|JVMDUMP013I"

# /**
# * urlPackage
# * Define a url do pacote a fazer o deploy
# * @var string
# */
urlPackage=''

# /**
# * flagErrorDeploy
# * Define flag de erro de deploy
# * @var string
# */
flagErrorDeploy=0


# /**
# * Funções
# */


# /**
# * startDeployWsadmin
# * Método que seta ambiente was
# * @version #VERSION
# * @package DevOps
# * @author  Michel Miranda <Michel.Miranda@br.experian.com>
# * @param   
# * @return
# */
startDeployWsadmin (){
    
    shWasadmin="/opt/IBM/WebSphere/AppServer/profiles/AppSrv01/bin/wsadmin.sh"

    local jythonWasInstallApp="was_install_app.py"
    local logTemp=$(mktemp)
    local cmdShWasadmin=$(mktemp).sh
    local flagStart=1
    local flagEnd=0
    local statusElapsed=1
    local psProc=''

    wasDmgrUser=$1
    wasDmgrPassword=$2

    infoMsg 'wasLib.sh->startDeployWsadmin: Aplicacao : '${wasApplication}' '
    infoMsg 'wasLib.sh->startDeployWsadmin: Cluster : '${wasClusterName}' '
    infoMsg 'wasLib.sh->startDeployWsadmin: Pacote : '${wasPackageDeploy}' ' 

    infoMsg 'wasLib.sh->startDeployWsadmin: Start processo de deploy [ Log '${logTemp}' ]' 
    echo -e "#!/usr/bin/env bash \n $shWasadmin -conntype SOAP -host $wasDmgr  -port $wasDmgrPort -user $wasDmgrUser -password "$wasDmgrPassword" -lang jython -f $jythonWasInstallApp $wasPackageDeploy $wasApplication $wasClusterName" > $cmdShWasadmin
    chmod a+x $cmdShWasadmin
    nohup $cmdShWasadmin > $logTemp &
    psProc=$(ps -ef | grep $cmdShWasadmin | grep -v grep| awk '{print $2}')
    if [ "$psProc" == "" ]; then
        errorMsg 'wasLib.sh->startDeployWsadmin: OPS, erro ao iniciar deploy da aplicacao '${wasApplication}' para cluster '${wasClusterName}'['${wasDmgr}'] '
        rm -f $wasPackageDeploy $logTemp $cmdShWasadmin
        if [ "$psProc" != "" ];then kill -9 $psProc; fi
        exit 1
    fi

    infoMsg 'wasLib.sh->startDeployWsadmin: Detalhes do deploy [ Log '${logTemp}' | Proc '${psProc}' ]'
    while [ "$psProc" != "" ]; do
        sleep 1
        let statusElapsed=$statusElapsed+1

        flagEnd=$(cat $logTemp | wc -l)
        if [ "$flagEnd" -eq 0 ]; then
            flagEnd=1
        fi

        if [ "$flagEnd" -ne "$flagStart" ]; then
            infoMsg 'wasLib.sh->startDeployWsadmin: Status deploy [ Log '${logTemp}' | Proc '${psProc}' ] ('${statusElapsed}'s)'
            cat $logTemp | sed -n "${flagStart},${flagEnd}p"
            if cat $logTemp | egrep "$wasErrors"  | grep -v "already started" > /dev/null; then 
                warnMsg 'wasLib.sh->startDeployWsadmin: Foi encontrado possiveis erros '${wasErrors}' de deploy da aplicacao '${wasApplication}' para cluster '${wasClusterName}'['${wasDmgr}'] '
                rm -f $wasPackageDeploy $logTemp $cmdShWasadmin
                if [ "$psProc" != "" ]; then 
                    psProc=$(ps -ef | grep $cmdShWasadmin | grep -v grep)
                    if [ $? -ne 0 ]; then
                        kill -9 $psProc
                    fi
                fi
                # exit 1
            fi
            flagStart=$flagEnd    
        fi

        psProc=''
        psProc=$(ps -ef | grep $cmdShWasadmin | grep -v grep| awk '{print $2}')
    done

    infoMsg 'wasLib.sh->startDeployWsadmin: Removendo pacote '${wasPackageDeploy}' localmente'     
    rm -f $wasPackageDeploy $logTemp $cmdShWasadmin
    infoMsg 'wasLib.sh->startDeployWsadmin: Aguardando '${wasSleepStart}' segundos para a aplicacao subir'     
    sleep $wasSleepStart
}

# /**
# * setWasDeployDetails
# * Método que seta o detalhes de deploy para WAS
# * @version 3.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @return
# */
setWasDeployDetails (){
    wasClusterName=''
    wasPackageDeploy=''
    wasApplication=''
    file=''
    fileTemp=''

    fileTemp="/tmp/`date +%s`.xml"
    deployXmlEar="META-INF/ibmconfig/cells/defaultCell/applications/defaultApp/deployments/defaultApp/deployment.xml"
    applicationXml="META-INF/application.xml"
    file=$(echo $urlPackage | sed "s/^.*\///")
    wasPackageDeploy="`date +%s`_$file"
    wasPackageDeploy="/tmp/$wasPackageDeploy"
    file=/tmp/$file

    infoMsg 'wasLib.sh->setWasDeployDetails : Baixando pacote '${urlPackage}' para '${file}''
    wget --no-check-certificate "$urlPackage" -O $file 2>/dev/null

    infoMsg 'wasLib.sh->setWasDeployDetails : Buscando cluster no pacote '${file}''
    unzip -p "$file" "$deployXmlEar" | sed 's/xmlns=".*"//g' | sed 's/\(\w\+:\)schemaLocation=".*"//g' > $fileTemp
    wasClusterName=`xmllint --nowarning --xpath "//deploymentTargets/@name" $fileTemp |cut -d"=" -f 2| sed -e 's/\"//g'`
    if [ "$wasClusterName" == "" ]; then
        errorMsg 'wasLib.sh->setWasDeployDetails : Nao encontrado o nome do cluster para iniciar o deploy'
        infoMsg 'wasLib.sh->setWasDeployDetails : Aplicacao ja foi enrriquecida?'
        infoMsg 'wasLib.sh->setWasDeployDetails : O arquivo de deployment.xml existe no EAR?'
        rm -f $file && rm -f $fileTemp
        exit 1
    fi
    rm -f $fileTemp
    infoMsg 'wasLib.sh->setWasDeployDetails : Cluster '${wasClusterName}''

    infoMsg 'wasLib.sh->setWasDeployDetails : Buscando nome da aplicacao no pacote '${file}''
    unzip -p "$file" "$applicationXml" | sed 's/xmlns=".*"//g' | sed 's/\(\w\+:\)schemaLocation=".*"//g' > $fileTemp
    wasApplication=`xmllint --nowarning --xpath "/application/display-name/text()" $fileTemp`
    if [ "$wasApplication" == "" ]; then
        errorMsg 'wasLib.sh->setWasDeployDetails : Nao encontrado o nome da aplicacao para iniciar o deploy'
        rm -f $file && rm -f $fileTemp
        exit 1
    fi
    rm -f $fileTemp
    infoMsg 'wasLib.sh->setWasDeployDetails : Aplicacao '${wasApplication}''

    infoMsg 'wasLib.sh->setWasDeployDetails : Buscando Dmgr para deploy no ambiente '${environment}''
    case $environment in
        de) environment="Desenvolvimento"; wasDmgr=spobrwas04-de;;
        deeid) errorMsg 'wasLib.sh->deploymentsWas : Ambiente '${environment}' nao permitido para deploy automatizado' ; exit 1;;
        hi) environment="Homologacao_Interna" ; wasDmgr=spobrwas03-hi;;
        hieid) errorMsg 'wasLib.sh->deploymentsWas : Ambiente '${environment}' nao permitido para deploy automatizado' ; exit 1;;
        he) environment="Homologacao_Externa" ; wasDmgr=spobrwas03-he;;
        pi) environment="Producao_Interna" ; wasDmgr=spobrwas03-pi ; wasSleepStart=180;;
        pe) environment="Producao_Externa" ; wasDmgr=spobrwas10 ; wasDmgrPort="8880" ; wasSleepStart=180 ;;
        pehttps1) environment="Producao_Externa_Sitenet53" ; wasDmgr=spobrwashttps1; wasSleepStart=180 ;;
        pehttps3) environment="Producao_Externa_Sitenet43" ; wasDmgr=spobrwashttps3; wasSleepStart=180 ;;
        pefree) errorMsg 'wasLib.sh->deploymentsWas : Ambiente '${environment}' nao permitido para deploy automatizado' ; exit 1;;
        peeid) errorMsg 'wasLib.sh->deploymentsWas : Ambiente '${environment}' nao permitido para deploy automatizado' ; exit 1;;
    esac
    
    infoMsg 'wasLib.sh->setWasDeployDetails : Dmgr para deploy '${wasDmgr}':'${wasDmgrPort}''
    cp $file $wasPackageDeploy
    infoMsg 'wasLib.sh->setWasDeployDetails : Pacote para deploy criado '${wasPackageDeploy}''
    ls -lha $wasPackageDeploy
    rm -f $file
}

# /**
# * deploymentsWas
# * Método de deploy para WAS
# * @version 3.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   $urlPackage
# * @param   $environment
# * @param   $wasDeployMethod
# * @return  true / false
# */
deploymentsWas (){
    urlPackage=''
    environment=''
    wasDeployMethod=''
    local extraVars=''

    test ! -z $1 || { errorMsg 'wasLib.sh->deploymentsWas : Url nao informado' ; exit 1; }
    test ! -z $2 || { errorMsg 'wasLib.sh->deploymentsWas : Ambiente nao informado' ; exit 1; }
    test ! -z $3 || { errorMsg 'wasLib.sh->deploymentsWas : Metodo de deploy nao informado' ; exit 1; }

    urlPackage=$1
    environment=$2
    wasDeployMethod=$3
    environmentSigla=$environment

    wsadminUser=$4
    wsadminPwd=$5

    setWasDeployDetails

    infoMsg 'wasLib.sh->deploymentsWas : Iniciando deploy via '${wasDeployMethod}' no ambiente '${wasDmgr}':'${wasDmgrPort}' ['${environment}']'

    startDeployWsadmin $wsadminUser $wsadminPwd

    if [ $flagErrorDeploy -eq 1 ]; then
        errorMsg 'wasLib.sh->deploymentsWas Deploy apresentou erros, realizando rollback'
        exit 1
    fi
}