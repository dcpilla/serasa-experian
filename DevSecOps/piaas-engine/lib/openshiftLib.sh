#!/usr/bin/env bash

VERSION='8.3.0'

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           openshiftLib.sh
# * @version        $VERSION
# * @description    Biblioteca com as manipulações do client OC do openshift
# * @copyright      2018 &copy Serasa Experian
# *
# * @version        8.3.0
# * @description    [FEATURE] Função de start/stop de api
# * @copyright      2021 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 ansibleLib.sh
# *                 curl
# *                 fusermount
# *                 gocryptfs
# *                 jq 
# *                 jenkins-credentials-decryptor (https://github.com/hoto/jenkins-credentials-decryptor)
# * @date           03-Dec-2021
# *
# * @version        8.2.0
# * @description    [BUG] Correção de vulnerabildiades
# * @copyright      2021 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 ansibleLib.sh
# *                 curl
# *                 fusermount
# *                 gocryptfs
# *                 jq 
# *                 jenkins-credentials-decryptor (https://github.com/hoto/jenkins-credentials-decryptor)
# * @date           11-Fev-2021
#
# * @version        8.1.0
# * @description    [FEATURE] Criacao da label 'tribe' no namespace sempre que o deploy é executado para contabilizar o consumo de recursos por tribe;
# * @copyright      2020 &copy Serasa Experian
# * @author         Renato M Thomazine <renato.thomazine@br.experian.com>
# * @dependencies   deploy.sh
# * @date           06-Jul-2020
#
# * @version        6.0.0
# * @description    [FEATURE] Compatibilidade do openshift 4.4
# *                 [BUG] Correção na criação de rotas;
# * @copyright      2020 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 ansibleLib.sh
# *                 curl
# *                 openshift-credentials.xml
# * @date           18-Jun-2020
# *
# * @version        5.9.0
# * @description    [FEATURE] Promoção de images;
# *                 [BUG] Correção na criação de rotas;
# * @copyright      2020 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 ansibleLib.sh
# *                 curl
# *                 openshift-credentials.xml
# * @date           10-Jun-2020
# *
# * @version        5.8.0
# * @description    [BUG] Retry de deploy no openshift eliminando o kubeconfig para evitar problemas de deploy simultâneos;
# * @copyright      2020 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 ansibleLib.sh
# *                 curl
# *                 openshift-credentials.xml
# * @date           11-Mar-2020
# *
# * @version        5.7.0
# * @description    [Melhoria] Melhorar a performace do push para o openshift com o metodo de tag de images; 
# * @copyright      2020 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 ansibleLib.sh
# *                 curl
# *                 openshift-credentials.xml
# * @date           03-Mar-2020
# *
# * @version        5.6.0
# * @description    [Feature] Adicionado parametro --region-latam para tratar DevSecOps LATAM;
# *                 [Feature] Deploy de aplicações no openshift por templates;
# * @copyright      2019 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 ansibleLib.sh
# *                 curl
# *                 openshift-credentials.xml
# * @date           19-Jun-2019
# *
# * @version        5.6.0
# * @description    Criação de rotas para o canvas BR via ansible
# * @copyright      2018 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 ansibleLib.sh
# *                 curl
# *                 openshift-credentials.xml
# * @date           29-Ago-2018
# *
# * @version        5.5.0
# * @description    Feature:
# *                    - Implementação da função playbook para o step install:
# *                    - Essa função irá disponibilizar para a SQUAD a aplicação de playbook's para infra as code para criação ou atualização dos serviços;
# * @copyright      2018 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 curl
# *                 openshift-credentials.xml
# * @date           30-Jul-2018
# *
# * @version        4.1.0
# * @description    Get de token de name space de xml
# * @copyright      2018 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 curl
# *                 openshift-credentials.xml
# * @date           25-Jun-2017
# *
# * @version        4.0.0
# * @description    Biblioteca com as manipulações do client OC do openshift
# * @copyright      2018 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 curl
# * @date           07-Maio-2017
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


# Carrega ansibleLib.sh
test -e "$baseDir"/lib/ansibleLib.sh || echo 'Ops, biblioteca ansibleLib.sh nao encontrada'
source "$baseDir"/lib/ansibleLib.sh

# /**
# * Variaveis
# */

# JENKINS_HOME
# if [[ -z "$JENKINS_HOME" ]]; then JENKINS_HOME="/opt/infratransac/jenkins" ; fi
# 
# # $JENKINS_HOME/credentials.xml
# JENKINS_HOME_CREDENTIALS="$JENKINS_HOME/credentials.xml"
# 
# # $JENKINS_HOME/secrets/master.key
# JENKINS_HOME_MASTER="$JENKINS_HOME/secrets/master.key"
# 
# # $JENKINS_HOME/secrets/hudson.util.Secret
# JENKINS_HOME_HUDSON="$JENKINS_HOME/secrets/hudson.util.Secret"
# 
# # HOME DAS CREDENCIAIS
# JENKINS_HOME_CRYPTFS="/opt/infratransac/credentials-cryptfs"
# 
# # Passaporte criptografia fs
# passportCredentialsCryptfs=$(/usr/local/bin/jenkins-credentials-decryptor -m $JENKINS_HOME_MASTER \
#                                                                           -s $JENKINS_HOME_HUDSON \
#                                                                           -c $JENKINS_HOME_CREDENTIALS \
#                                                                           -o json | /usr/local/bin/jq -r '.[] | select(.id=="devsecops-passport-credentials-cryptfs") | .password' )
# 
# # Monta partição criptografada fs
# dirCryptfs=$(mktemp -d)
# echo "$passportCredentialsCryptfs" | /usr/local/bin/gocryptfs -idle 60s -ro -quiet $JENKINS_HOME_CRYPTFS $dirCryptfs
# 
# # Carrega arquivo de credenciais openshift para array
# if [ ! -e "$dirCryptfs"/openshift-credentials.xml ] ; then
#     echo 'Ops, arquivo openshift-credentials.xml nao encontrado' 
#     fusermount -u $dirCryptfs
#     rm -rf $dirCryptfs
#     exit 1
# fi
# 
# for tag in namespaceOc appCanvasOc registryOc domainOc tokenOc
# do
#     OUT=`grep  $tag "$dirCryptfs"/openshift-credentials.xml | tr -d '\t' | sed 's/^<.*>\([^<].*\)<.*>$/\1/' `
#     # fazendo o eval_trick
#     eval ${tag}=`echo -ne \""${OUT}"\"`
# done
# namespaceOc=( `echo ${namespaceOc}` )
# appCanvasOc=( `echo ${appCanvasOc}` )
# registryOc=( `echo ${registryOc}` )
# domainOc=( `echo ${domainOc}` )
# tokenOc=( `echo ${tokenOc}` ) 
# 
# # Desmonta partição criptografada fs
# fusermount -u $dirCryptfs
# rm -rf $dirCryptfs

# /**
# * openshiftServer
# * Servidor openshift
# * @var string
# */
openshiftServer=

# /**
# * openshiftDomain
# * Domain openshift
# * @var string
# */
openshiftDomain=

# /**
# * openshiftRegistry
# * Servidor registry openshift
# * @var string
# */
openshiftRegistry=

# /**
# * openshiftToken
# * Token openshift
# * @var string
# */
openshiftToken=

# /**
# * openshiftCli
# * Cli do openshift
# * @var string
# */
openshiftCli='/usr/bin/oc'

# /**
# * openshiftVersion
# * Versão do openshift
# * @var string
# */
openshiftVersion='3'

# /**
# * project
# * Define o projeto de deploy
# * @var string
# */
project=''

# /**
# * pathPackage
# * Caminho do pacote para o deploy
# * @var string
# */
pathPackage=''

# /**
# * image
# * Define a imagem do conteiner
# * @var string
# */
image=''

# /**
# * replicas
# * Define o numero replicas 
# * @var string
# */
replicas=''

# /**
# * environment
# * Define o ambiente para fazer o deploy
# * @var string
# */
environment=

# /**
# * regionLatam
# * Regiao LATAM para DevSecOps
# * @var string
# */
regionLatam=''

# /**
# * version
# * Versao da aplicacao que sera submetida
# * @var string
# */
version=

# /**
# * noRoute
# * Ignorar criacao de rotas no deploy no openshift
# * @var string
# */
noRoute='false'

# /**
# * noDeleteImage
# * Ignorar delete de conteiner no deploy
# * @var string
# */
noDeleteImage='false'

# /**
# * tribe
# * Tribe responsavel pela aplicacao
# * @var string
# */
tribe=''

# /**
# * Variaveis de Origem de promoção da imagem para deploy com openshift
# * @var string
# */
promotionSrc=''
promotionSrcProject=''
promotionSrcApp=''
promotionSrcTag=''
promotionSrcOpenshiftServer=''
promotionSrcOpenshiftDomain=''
promotionSrcOpenshiftRegistry=''
promotionSrcOpenshiftToken=''
    
# /**
# * Variaveis Destino de promoção da imagem para deploy com openshift
# * @var string
# */
promotionDst=''
promotionDstProject=''
promotionDstApp=''
promotionDstTag=''
promotionDstOpenshiftServer=''
promotionDstOpenshiftDomain=''
promotionDstOpenshiftRegistry=''
promotionDstOpenshiftToken=''
versionPromotion=''

# /**
# * flagPromotion
# * Ativa flag para promoção de imagens
# * @var string
# */
flagPromotion='false'

# /**
# * errors
# * Define flag de erro do deploy
# * @var string
# */
errors=false

# /**
# * keepGoing
# * Define flag para controle de fluxo de tentativas de deploy
# * @var string
# */
keepGoing=''

# /**
# * kubeConfigFile
# * Define arquivo kubeconfig 
# * @var string
# */
kubeConfigFile=''

# /**
# * metodoCreateRoute
# * Define metodo para criacao de rotas no deploy no openshift
# * @var string
# */
metodoCreateRoute=''

# /**
# * unset do proxy
# */
unset http_proxy
unset https_proxy

# /**
# * Funções
# */

# /**
# * getDetailsAppOpenshift
# * Método para retornar o detalhes de infra da aplicação no openshift
# * @version 4.1.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   namespace - Name Space para pesquisa
# * @return  true | false
# */
getDetailsAppOpenshift() {
    openshiftServer=''
    openshiftDomain=''
    openshiftRegistry=''
    openshiftToken=''
    metodoCreateRoute=''
    local nameSpaceSearch=$1

    test ! -z $nameSpaceSearch || { errorMsg 'openshiftLib.sh->getDetailsAppOpenshift : Name Space nao informado para pesquisa' ; exit 1; }

    if test $OPENSHIFT_IFS_SERVER_NPROD; then
        openshiftServer=$OPENSHIFT_IFS_SERVER_NPROD
        openshiftDomain=$OPENSHIFT_IFS_DOMAIN_NPROD
        openshiftRegistry=$OPENSHIFT_IFS_REGISTRY_NPROD
        openshiftToken=$OPENSHIFT_IFS_TOKEN_NPROD

        metodoCreateRoute="template-yaml"
        openshiftCli='/usr/local/bin/oc'
        openshiftVersion='4'

        infoMsg 'openshiftLib.sh->getDetailsAppOpenshift : Detalhes do projeto '${nameSpaceSearch}' no openshift encontrados'
        echo "Server para deploy: $openshiftServer"
        echo "Dominio para deploy: $openshiftDomain"
        echo "Registry para deploy: $openshiftRegistry"
        echo "Metodo para rotas: $metodoCreateRoute"
        echo "Versao do openshift: $openshiftVersion"
        echo "Cli do openshift: $openshiftCli"
        echo "Token: hahahahahaha nao podemos contar"
        return 0
    fi

    errorMsg 'openshiftLib.sh->getDetailsAppOpenshift : Name Space pesquisado '${nameSpaceSearch}' nao foi localizado no arquivo de credenciais do openshift!'
    exit 1
}


# /**
# * setDetailsPromotion
# * Método que seta os detalhes de promoção de images para openshift
# * @version VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @return
# */
setDetailsPromotion (){
    versionPromotion=`echo $image|cut -d':' -f2`
    versionPromotion=`echo $versionPromotion| sed -e 's/-SNAPSHOT//g'`

    infoMsg 'openshiftLib.sh->setDetailsPromotion : Setando dados para promocao de images no openshift'

    promotionSrcProject=$(echo $promotionSrc|cut -d'/' -f1)
    promotionSrcApp=$(echo $promotionSrc|cut -d'/' -f2|cut -d':' -f1)
    promotionSrcTag=$(echo $promotionSrc|cut -d'/' -f2|cut -d':' -f2)
    promotionSrc="$promotionSrcProject/$promotionSrcApp:$versionPromotion-$promotionSrcTag"
    for (( x = 0 ; x < ${#namespaceOc[@]} ; x++ )) 
    do
        if [ "${namespaceOc[$x]}" = "$promotionSrcProject" ] ; then
            promotionSrcOpenshiftServer=${appCanvasOc[$x]}
            promotionSrcOpenshiftDomain=${domainOc[$x]}
            promotionSrcOpenshiftRegistry=${registryOc[$x]}
            promotionSrcOpenshiftToken=${tokenOc[$x]}
            echo ""
            infoMsg 'openshiftLib.sh->setDetailsPromotion : Detalhes do projeto Src '${promotionSrcProject}' no openshift encontrados para promocao'
            echo "Server Src deploy: $promotionSrcOpenshiftServer"
            echo "Dominio Src deploy: $promotionSrcOpenshiftDomain"
            echo "Registry Src deploy: $promotionSrcOpenshiftRegistry"
            echo "Project Src: $promotionSrcProject"
            echo "Application Src: $promotionSrcApp"
            echo "Tag Src: $promotionSrcTag"
            echo "Command Src: $promotionSrc"
            echo "Versao do openshift: $openshiftVersion"
            echo "Cli do openshift: $openshiftCli"
            echo "Token Src: hahahahahaha nao podemos contar"
            echo ""
            x=100000
            flagPromotion='true'
        else
           flagPromotion='false'
        fi
    done
    if [ "$flagPromotion" == "false" ];then
        errorMsg 'openshiftLib.sh->setDetailsPromotion: Name Space Src pesquisado '${promotionSrcProject}' para promocao de images nao foi localizado no arquivo de credenciais do openshift!'
        exit 1
    fi

    promotionDstProject=$(echo $promotionDst|cut -d'/' -f1)
    promotionDstApp=$(echo $promotionDst|cut -d'/' -f2|cut -d':' -f1)
    promotionDstTag=$(echo $promotionDst|cut -d'/' -f2|cut -d':' -f2)
    promotionDst="$promotionDstProject/$promotionDstApp:$versionPromotion-$promotionDstTag"
    for (( x = 0 ; x < ${#namespaceOc[@]} ; x++ )) 
    do
        if [ "${namespaceOc[$x]}" = "$promotionDstProject" ] ; then
            promotionDstOpenshiftServer=${appCanvasOc[$x]}
            promotionDstOpenshiftDomain=${domainOc[$x]}
            promotionDstOpenshiftRegistry=${registryOc[$x]}
            promotionDstOpenshiftToken=${tokenOc[$x]}
            echo ""
            infoMsg 'openshiftLib.sh->setDetailsPromotion : Detalhes do projeto Dst '${promotionDstProject}' no openshift encontrados para promocao'
            echo "Server Dst deploy: $promotionDstOpenshiftServer"
            echo "Dominio Dst deploy: $promotionDstOpenshiftDomain"
            echo "Registry Dst deploy: $promotionDstOpenshiftRegistry"
            echo "Project Dst: $promotionDstProject"
            echo "Application Dst: $promotionDstApp"
            echo "Tag Dst: $promotionDstTag"
            echo "Command Dst: $promotionDst"
            echo "Versao do openshift: $openshiftVersion"
            echo "Cli do openshift: $openshiftCli"
            echo "Token Dst: hahahahahaha nao podemos contar"
            echo ""
            x=100000
            flagPromotion='true'
        else
           flagPromotion='false'
        fi
    done
    if [ "$flagPromotion" == "false" ];then
        errorMsg 'openshiftLib.sh->setDetailsPromotion: Name Space Dst pesquisado '${promotionDstProject}' para promocao de images nao foi localizado no arquivo de credenciais do openshift!'
        exit 1
    fi
}

# /**
# * checkEnvironment
# * Método que valida enrironment informada do openshift
# * @version VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @return
# */
checkEnvironment (){
    infoMsg 'openshiftLib.sh->checkEnvironment : Verificando enrironment '${enrironment}''
    case $environment in
        develop)
            if  [ "$openshiftServer" == "https://br-console.br.appcanvas.net:8443" ] || [ "$openshiftRegistry" == "docker-registry-default.f-internal.br.appcanvas.net" ]; then
                errorMsg 'openshiftLib.sh->checkEnvironment : Deploy nao permitido em openshift de producao para environment '${environment}''
                exit 1
            fi
        ;;
        prod)
            if  [ "$openshiftServer" == "https://console.appcanvas.net:8443" ] || [ "$openshiftRegistry" == "docker-registry-default.apps.appcanvas.net" ]; then
                errorMsg 'openshiftLib.sh->checkEnvironment : Deploy nao permitido em openshift de desenvolvimento para environment '${environment}''
                exit 1
            fi
        ;;
    esac
    infoMsg 'openshiftLib.sh->checkEnvironment : Deploy permitido'
}

# /**
# * loginOpenshift
# * Método que se loga no openshift
# * @version VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @return
# */
loginOpenshift (){
    kubeConfigFile=/tmp/$(date +%s)_$project.yml

    infoMsg 'openshiftLib.sh->loginOpenshift : Definindo KUBECONFIG'
    export KUBECONFIG=$kubeConfigFile
    echo "$(env |grep KUBECONFIG)"

    if [ "$openshiftServer" == "https://us-console.appcanvas.net:8443" ] || [ "$openshiftServer" == "https://api.internal.appcanvas.net:6443" ] || [ "$openshiftServer" == "https://api.zocp.br.experian.local:6443" ] || [ "$openshiftServer" == "https://api.zocprd1.br.experian.local:6443" ] || [ "$openshiftServer" == "https://api.us-external.appcanvas.net:6443" ];then
        skipTlsVerify="--insecure-skip-tls-verify"
    fi

    if [ "$flagPromotion" == "same_cluster" ]; then
        if ! $openshiftCli login $skipTlsVerify --token=$promotionSrcOpenshiftToken --server=$promotionSrcOpenshiftServer; then
            errorMsg 'openshiftLib.sh->loginOpenshift : Nao foi possivel se conectar ao openshift '${promotionSrcOpenshiftServer}' para promocao de images, verifique token informado'
            exit 1
        fi
        infoMsg 'openshiftLib.sh->loginOpenshift : Bem vindo em '${promotionSrcProject}' - '${promotionSrcOpenshiftServer}' [Promocao Images Mesmo Cluster]'
    elif [ "$flagPromotion" == "different_clusters" ]; then 
        if ! $openshiftCli login $skipTlsVerify --token=$promotionDstOpenshiftToken --server=$promotionDstOpenshiftServer; then
            errorMsg 'openshiftLib.sh->loginOpenshift : Nao foi possivel se conectar ao openshift '${promotionDstOpenshiftServer}' para promocao de images, verifique token informado'
            exit 1
        fi
        infoMsg 'openshiftLib.sh->loginOpenshift : Bem vindo em '${promotionDstProject}' - '${promotionDstOpenshiftServer}' [Promocao Images Diferente Cluster]'
    else
        if ! $openshiftCli login $skipTlsVerify --token=$openshiftToken --server=$openshiftServer; then
            errorMsg 'openshiftLib.sh->loginOpenshift : Nao foi possivel se conectar ao openshift '${openshiftServer}', verifique token informado'
            exit 1
        fi
        infoMsg 'openshiftLib.sh->loginOpenshift : Bem vindo em '${project}' - '${openshiftServer}''
    fi

}

# /**
# * logoutOpenshift
# * Método que faz o logout no openshift
# * @version VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @return
# */
logoutOpenshift (){
    if ! $openshiftCli logout; then
        warnMsg 'openshiftLib.sh->logoutOpenshift : Nao foi possivel desconectar do openshift '${openshiftServer}''
    fi

    infoMsg 'openshiftLib.sh->logoutOpenshift : Removendo KUBECONFIG['${kubeConfigFile}']'
    rm -f $kubeConfigFile

    infoMsg 'openshiftLib.sh->logoutOpenshift : ByBy'
}

# /**
# * checkProject
# * Método que verifica se projeto existe no openshift
# * @version VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   $project - Nome do projeto
# * @return
# */
checkProject (){
    test ! -z $1 || { errorMsg 'openshiftLib.sh->checkProject : Projeto nao informado' ; exit 1; }
 
    local flagProject=`$openshiftCli get projects|grep $1|wc -l`
    if [ $flagProject -eq 0 ]; then
        errorMsg 'openshiftLib.sh->checkProject : Projeto '${project}' nao existe em '${openshiftServer}''
        errorMsg 'openshiftLib.sh->checkProject : Solicite a criacao do projeto via Service Now'
        logoutOpenshift
        exit 1
    elif [ $flagProject -eq 1 ]; then
        infoMsg 'openshiftLib.sh->checkProject : Projeto '${project}' exite em '${openshiftServer}' \o/'
    else
        errorMsg 'openshiftLib.sh->checkProject : Ops algo de errado aconteceu a checar projetos em '${openshiftServer}''
    fi  
}

# /**
# * checkService
# * Método que verifica se servico existe no openshift
# * @version VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   $service - Nome do servico
# * @return
# */
checkService (){
    test ! -z "$1" || { errorMsg 'openshiftLib.sh->checkService : Servico nao informado' ; exit 1; }
 
    keepGoing=1
    while [ $keepGoing -le 5 ]; do
        loginOpenshift 
        checkProject $project
        if ! $openshiftCli project $project; then
            errorMsg 'openshiftLib.sh->checkService : Algo de errado aconteceu ao selecionar '${project}' em '${openshiftServer}', tentando novamente'
            keepGoing=$((keepGoing + 1))
            sleep 2
        else
            keepGoing=99
        fi 

        if [ $keepGoing -eq 5 ]; then
            errorMsg 'openshiftLib.sh->checkService : Ops erro ao selecionar '${project}' em '${openshiftServer}''
            logoutOpenshift
            exit 1
        fi
    done      

    local nameService=$(echo "$1" | cut -d ':' -f 1)
    local flagService=`$openshiftCli get services|grep "^$nameService "|awk '{print $1}'`
    local extraVars=''
    local templateFiles="/tmp/$nameService"
    local servicePort="8080"

    #if [ "$tribe" != "" ]; then
        #`$openshiftCli label namespace $project tribe=$tribe`
        #infoMsg 'openshiftLib.sh->deploymentsContainer : Label aplicada com sucesso '${project}'/tribe' = '${tribe}'
    #fi

    if [ "$nameService" != "$flagService" ]; then
        warnMsg 'openshiftLib.sh->checkService : Servico '${nameService}' nao existe em '${openshiftServer}', vou criar para voce ...'
        if [ "$pathPackage" == "" ]; then
            infoMsg 'openshiftLib.sh->checkService : Criando servico com template padrao'
            
            templateFiles="/tmp/$nameService"
            local sizeName=`echo ${nameService} | grep -o '-' | wc -l`

            if [ $sizeName -gt 2 ]; then
                local nameServiceSmall=`echo "$nameService" | cut -d '-' -f $(echo $sizeName + 1 |bc)`
                nameServiceSmall=$nameServiceSmall-`echo "$nameService" | cut -d '-' -f $sizeName`
                nameServiceSmall=$nameServiceSmall-`echo "$nameService" | cut -d '-' -f $(echo $sizeName - 1 |bc)`
            else
                local nameServiceSmall=`echo "$nameService" | cut -d '-' -f $(echo $sizeName + 1 |bc)`
                nameServiceSmall=$nameServiceSmall-`echo "$nameService" | cut -d '-' -f $sizeName`
            fi
            
            if [[ -d "/tmp/$nameService" ]]; then
                infoMsg 'openshiftLib.sh->checkService : Removendo template anterior'
                rm -rf  /tmp/$nameService
            fi

            infoMsg 'openshiftLib.sh->checkService : Copiando template para '${templateFiles}' '
            cp -rfv "$baseDir"/conf/openshift /tmp/$nameService

            infoMsg 'openshiftLib.sh->checkService : Fazendo replace em template /tmp/'${nameService}'/DeploymentConfig.yml'
            sed -i "s/@@artifactId@@/${nameService}/" /tmp/$nameService/DeploymentConfig.yml
            sed -i "s/@@project@@/${project}/" /tmp/$nameService/DeploymentConfig.yml
            sed -i "s/@@registry@@/${openshiftRegistry}/" /tmp/$nameService/DeploymentConfig.yml

            infoMsg 'openshiftLib.sh->checkService : Fazendo replace em template /tmp/'${nameService}'/ImageStream.yml'
            sed -i "s/@@artifactId@@/${nameService}/" /tmp/$nameService/ImageStream.yml
            sed -i "s/@@project@@/${project}/" /tmp/$nameService/ImageStream.yml
            sed -i "s/@@registry@@/${openshiftRegistry}/" /tmp/$nameService/ImageStream.yml

            if [ "$noRoute" == "true" ]; then
                warnMsg 'openshiftLib.sh->checkService : A criacao de rotas sera ignorada, pois o parametro em --no-route esta '${noRoute}''    
                rm -f /tmp/$nameService/Route.yml
            elif [ "$metodoCreateRoute" != "template-yaml" ]; then
                infoMsg 'openshiftLib.sh->checkService : Rota sera criada via '${metodoCreateRoute}' na regiao latam '${regionLatam}''    
                rm -f /tmp/$nameService/Route.yml
            else 
                infoMsg 'openshiftLib.sh->checkService : Rota sera criada via '${metodoCreateRoute}''
                infoMsg 'openshiftLib.sh->checkService : Fazendo replace em template /tmp/'${nameService}'/Route.yml'
                sed -i "s/@@artifactIdSmall@@/${nameServiceSmall}/" /tmp/$nameService/Route.yml
                sed -i "s/@@artifactId@@/${nameService}/" /tmp/$nameService/Route.yml
                sed -i "s/@@project@@/${project}/" /tmp/$nameService/Route.yml
                sed -i "s/@@domain@@/${openshiftDomain}/" /tmp/$nameService/Route.yml
            fi

            infoMsg 'openshiftLib.sh->checkService : Fazendo replace em template /tmp/'${nameService}'/Service.yml'
            sed -i "s/@@artifactId@@/${nameService}/" /tmp/$nameService/Service.yml
            sed -i "s/@@project@@/${project}/" /tmp/$nameService/Service.yml
        else
            infoMsg 'openshiftLib.sh->checkService : Usando template informado '${pathPackage}' para criacao do servico'
            templateFiles=$pathPackage
            case $nameService in
                mongo-express) servicePort="8081";;
                maas-prometheus) servicePort="9090";;
                maas-grafana) servicePort="3000";;
                *) servicePort="8080";;
            esac
            infoMsg 'openshiftLib.sh->checkService : Alterando service_port para '${servicePort}' para criacao de rota do servico'
        fi
        
        infoMsg 'openshiftLib.sh->checkService : Criando o servico '${nameService}''
        infoMsg 'openshiftLib.sh->checkService : Aplicando template '${templateFiles}''
        if ! $openshiftCli apply -f $templateFiles; then
            errorMsg 'openshiftLib.sh->checkService : Ops erro ao criar service '${nameService}' em '${openshiftServer}''
            logoutOpenshift
            exit 1
        fi
        
        if [ "$regionLatam" == "colombia" ] && [ "$metodoCreateRoute" != "template-yaml" ] && [ "$noRoute" == "false" ]; then
            extraVars="secret=X&EKt@8M5H_fW#d project=$project service_name=$nameService service_port=$servicePort secure_route=true hostname_prefix=$nameService-$project"
            infoMsg 'openshiftLib.sh->checkService : Criando rota para o projeto '${project}' no ambiente '${environment}' via ansible US'  
            deploymentsAnsible tower-experian-us job 0 565 "$extraVars"
        elif [ "$regionLatam" == "brasil" ] && [ "$metodoCreateRoute" != "template-yaml" ] && [ "$noRoute" == "false" ]; then
            extraVars="secret=n+8N\$*-YDhzSae#e project=$project service_name=$nameService service_port=$servicePort secure_route=true hostname_prefix=$nameService-$project"
            infoMsg 'openshiftLib.sh->checkService : Criando rota para o projeto '${project}' no ambiente '${environment}' via ansible BR'  
            deploymentsAnsible tower-experian job 0 530 "$extraVars"
        fi

        infoMsg 'openshiftLib.sh->checkService : Informacoes do servico '${nameService}''
        $openshiftCli describe service $nameService
    elif [ "$nameService" == "$flagService" ]; then
        infoMsg 'openshiftLib.sh->checkService : Servico '${nameService}' exite em '${openshiftServer}' \o/'
        #if $openshiftCli set resources dc $nameService --limits=cpu=500m,memory=1024Mi --requests=cpu=10m,memory=64Mi; then
        #    warnMsg 'openshiftLib.sh->checkService : Troubleshooting aplicado ao servico '${nameService}' exite em '${openshiftServer}''
        #    echo "Set --limits=cpu=500m,memory=1024Mi --requests=cpu=10m,memory=64Mi"
        #fi
    else
        errorMsg 'openshiftLib.sh->checkService : Ops algo de errado aconteceu a checar servico em '${openshiftServer}''
    fi 

    logoutOpenshift 
}

# /**
# * checkServicePromotion
# * Método que verifica se servico existe no openshift modo promoção
# * @version VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   $service - Nome do servico
# * @return
# */
checkServicePromotion (){
    test ! -z "$1" || { errorMsg 'openshiftLib.sh->checkServicePromotion : Servico nao informado' ; exit 1; }  

    local nameService=$(echo "$1" | cut -d ':' -f 1)
    local flagService=`$openshiftCli get services|grep "^$nameService "|awk '{print $1}'`
    local extraVars=''
    local templateFiles="/tmp/$nameService"
    local servicePort="8080"

    #if [ "$tribe" != "" ]; then
        #`$openshiftCli label namespace $project tribe=$tribe`
        #infoMsg 'openshiftLib.sh->deploymentsContainer : Label aplicada com sucesso '${project}'/tribe' = '${tribe}'
    #fi

    if [ "$nameService" != "$flagService" ]; then
        warnMsg 'openshiftLib.sh->checkServicePromotion : Servico '${nameService}' nao existe em '${openshiftServer}', vou criar para voce ...'
        if [ "$pathPackage" == "" ]; then
            infoMsg 'openshiftLib.sh->checkServicePromotion : Criando servico com template padrao'
            
            templateFiles="/tmp/$nameService"
            local sizeName=`echo ${nameService} | grep -o '-' | wc -l`

            if [ $sizeName -gt 2 ]; then
                local nameServiceSmall=`echo "$nameService" | cut -d '-' -f $(echo $sizeName + 1 |bc)`
                nameServiceSmall=$nameServiceSmall-`echo "$nameService" | cut -d '-' -f $sizeName`
                nameServiceSmall=$nameServiceSmall-`echo "$nameService" | cut -d '-' -f $(echo $sizeName - 1 |bc)`
            else
                local nameServiceSmall=`echo "$nameService" | cut -d '-' -f $(echo $sizeName + 1 |bc)`
                nameServiceSmall=$nameServiceSmall-`echo "$nameService" | cut -d '-' -f $sizeName`
            fi
            
            if [[ -d "/tmp/$nameService" ]]; then
                infoMsg 'openshiftLib.sh->checkServicePromotion : Removendo template anterior'
                rm -rf  /tmp/$nameService
            fi

            infoMsg 'openshiftLib.sh->checkServicePromotion : Copiando template para '${templateFiles}' '
            cp -rfv "$baseDir"/conf/openshift /tmp/$nameService

            infoMsg 'openshiftLib.sh->checkServicePromotion : Fazendo replace em template /tmp/'${nameService}'/DeploymentConfig.yml'
            sed -i "s/@@artifactId@@/${nameService}/" /tmp/$nameService/DeploymentConfig.yml
            sed -i "s/@@project@@/${project}/" /tmp/$nameService/DeploymentConfig.yml
            sed -i "s/@@registry@@/${openshiftRegistry}/" /tmp/$nameService/DeploymentConfig.yml

            infoMsg 'openshiftLib.sh->checkServicePromotion : Fazendo replace em template /tmp/'${nameService}'/ImageStream.yml'
            sed -i "s/@@artifactId@@/${nameService}/" /tmp/$nameService/ImageStream.yml
            sed -i "s/@@project@@/${project}/" /tmp/$nameService/ImageStream.yml
            sed -i "s/@@registry@@/${openshiftRegistry}/" /tmp/$nameService/ImageStream.yml

            if [ "$noRoute" == "true" ]; then
                warnMsg 'openshiftLib.sh->checkServicePromotion : A criacao de rotas sera ignorada, pois o parametro em --no-route esta '${noRoute}''    
                rm -f /tmp/$nameService/Route.yml
            elif [ "$metodoCreateRoute" != "template-yaml" ]; then
                infoMsg 'openshiftLib.sh->checkServicePromotion : Rota sera criada via '${metodoCreateRoute}' na regiao latam '${regionLatam}''    
                rm -f /tmp/$nameService/Route.yml
            else 
                infoMsg 'openshiftLib.sh->checkServicePromotion : Rota sera criada via '${metodoCreateRoute}''
                infoMsg 'openshiftLib.sh->checkServicePromotion : Fazendo replace em template /tmp/'${nameService}'/Route.yml'
                sed -i "s/@@artifactIdSmall@@/${nameServiceSmall}/" /tmp/$nameService/Route.yml
                sed -i "s/@@artifactId@@/${nameService}/" /tmp/$nameService/Route.yml
                sed -i "s/@@project@@/${project}/" /tmp/$nameService/Route.yml
                sed -i "s/@@domain@@/${openshiftDomain}/" /tmp/$nameService/Route.yml
            fi

            infoMsg 'openshiftLib.sh->checkServicePromotion : Fazendo replace em template /tmp/'${nameService}'/Service.yml'
            sed -i "s/@@artifactId@@/${nameService}/" /tmp/$nameService/Service.yml
            sed -i "s/@@project@@/${project}/" /tmp/$nameService/Service.yml
        else
            infoMsg 'openshiftLib.sh->checkServicePromotion : Usando template informado '${pathPackage}' para criacao do servico'
            templateFiles=$pathPackage
            case $nameService in
                mongo-express) servicePort="8081";;
                maas-prometheus) servicePort="9090";;
                maas-grafana) servicePort="3000";;
                *) servicePort="8080";;
            esac
            infoMsg 'openshiftLib.sh->checkServicePromotion : Alterando service_port para '${servicePort}' para criacao de rota do servico'
        fi
        
        infoMsg 'openshiftLib.sh->checkServicePromotion : Criando o servico '${nameService}''
        infoMsg 'openshiftLib.sh->checkServicePromotion : Aplicando template '${templateFiles}''
        if ! $openshiftCli create -f $templateFiles; then
            errorMsg 'openshiftLib.sh->checkServicePromotion : Ops erro ao criar service '${nameService}' em '${openshiftServer}''
            logoutOpenshift
            exit 1
        fi
        
        if [ "$regionLatam" == "colombia" ] && [ "$metodoCreateRoute" != "template-yaml" ] && [ "$noRoute" == "false" ]; then
            extraVars="secret=X&EKt@8M5H_fW#d project=$project service_name=$nameService service_port=$servicePort secure_route=true hostname_prefix=$nameService-$project"
            infoMsg 'openshiftLib.sh->checkServicePromotion : Criando rota para o projeto '${project}' no ambiente '${environment}' via ansible US'  
            deploymentsAnsible tower-experian-us job 0 565 "$extraVars"
        elif [ "$regionLatam" == "brasil" ] && [ "$metodoCreateRoute" != "template-yaml" ] && [ "$noRoute" == "false" ]; then
            extraVars="secret=n+8N\$*-YDhzSae#e project=$project service_name=$nameService service_port=$servicePort secure_route=true hostname_prefix=$nameService-$project"
            infoMsg 'openshiftLib.sh->checkServicePromotion : Criando rota para o projeto '${project}' no ambiente '${environment}' via ansible BR'  
            deploymentsAnsible tower-experian job 0 530 "$extraVars"
        fi

        infoMsg 'openshiftLib.sh->checkServicePromotion : Informacoes do servico '${nameService}''
        $openshiftCli describe service $nameService
    elif [ "$nameService" == "$flagService" ]; then
        infoMsg 'openshiftLib.sh->checkServicePromotion : Servico '${nameService}' exite em '${openshiftServer}' \o/'
        #if $openshiftCli set resources dc $nameService --limits=cpu=500m,memory=1024Mi --requests=cpu=10m,memory=64Mi; then
        #    warnMsg 'openshiftLib.sh->checkServicePromotion : Troubleshooting aplicado ao servico '${nameService}' exite em '${openshiftServer}''
        #    echo "Set --limits=cpu=500m,memory=1024Mi --requests=cpu=10m,memory=64Mi"
        #fi
    else
        errorMsg 'openshiftLib.sh->checkServicePromotion : Ops algo de errado aconteceu a checar servico em '${openshiftServer}''
    fi 
}

# /**
# * deploymentsPackage
# * Método que orquestra o deploy no openshift tipo package
# * @version VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   $project 
# *          $image 
# *          $environment 
# *          $pathPackage
# * @return  true / false
# */
deploymentsPackage (){
    project=''
    image=''
    environment=''
    pathPackage=''

    test ! -z $1 || { errorMsg 'openshiftLib.sh->deploymentsPackage : Project nao informada' ; exit 1; }
    test ! -z $2 || { errorMsg 'openshiftLib.sh->deploymentsPackage : Application nao informado' ; exit 1; }
    test ! -z $3 || { errorMsg 'openshiftLib.sh->deploymentsPackage : Ambiente nao informada' ; exit 1; }
    test ! -z $4 || { errorMsg 'openshiftLib.sh->deploymentsPackage : Caminho de pacote para deploy nao informada' ; exit 1; }

    project=$1
    image="$2"
    environment=$3
    pathPackage=$4

    getDetailsAppOpenshift $project

    #checkEnvironment

    loginOpenshift

    checkProject $project
 
    if ! $openshiftCli project $project; then
        errorMsg 'openshiftLib.sh->deploymentsPackage : Projeto informado '${project}' nao existe, verifique no canvas '${openshiftServer}' o projeto correto'
        logoutOpenshift
        exit 1
    fi       

    infoMsg 'openshiftLib.sh->deploymentsPackage : Iniciando deploy da aplicacao '${image}' do pacote '${pathPackage}' no '${project}''
                        
    $openshiftCli start-build $image --from-file=$pathPackage
    if [ "$?" -ne 0 ]; then
        errorMsg 'openshiftLib.sh->deploymentsPackage : Algo de errado aconteceu ao tentar executar o deploy do pacote '${pathPackage}' no '${project}''
        logoutOpenshift
        errors='true'
    else
        infoMsg 'openshiftLib.sh->deploymentsPackage : Deploy para aplicacao '${image}' realizando com sucesso no '${project}''
        logoutOpenshift
    fi

    if [ "$errors" == "true" ]; then
        errorMsg 'openshiftLib.sh->deploymentsPackage : Deploy apresentou erros, realizando rollback'
        exit 1
    fi
}

# /**
# * deploymentsDiscovery
# * Método que discovery no openshift em um projeto
# * @version VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   $project 
# * @return  true / false
# */
deploymentsDiscovery (){
    project=''

    test ! -z $1 || { errorMsg 'openshiftLib.sh->deploymentsDiscovery : Project nao informada' ; exit 1; }

    project=$1

    getDetailsAppOpenshift $project

    loginOpenshift

    checkProject $project
 
    if ! $openshiftCli project $project; then
        errorMsg 'openshiftLib.sh->deploymentsDiscovery : Projeto informado '${project}' nao existe, verifique no canvas '${openshiftServer}' o projeto correto'
        logoutOpenshift
        exit 1
    fi       
                        
    echo "Discovery: $($openshiftCli get svc| awk '{print $1}'| sort | egrep -v 'glusterfs|NAME' |tr '\n' ';')"
    if [ "$?" -ne 0 ]; then
        errorMsg 'openshiftLib.sh->deploymentsDiscovery : Algo de errado aconteceu ao tentar executar o discovery no '${project}''
        logoutOpenshift
        errors='true'
    fi

    if [ "$errors" == "true" ]; then
        errorMsg 'openshiftLib.sh->deploymentsDiscovery : Discovery apresentou erros'
        exit 1
    fi
}

# /**
# * deploymentsRollout
# * Método que rollout no openshift em um projeto
# * @version VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   $project 
# * @param   $image
# * @return  true / false
# */
deploymentsRollout (){
    project=''
    image=''

    test ! -z $1 || { errorMsg 'openshiftLib.sh->deploymentsRollout : Project nao informada' ; exit 1; }
    test ! -z $2 || { errorMsg 'openshiftLib.sh->deploymentsRollout : Image nao informada' ; exit 1; }

    project=$1
    image=$2

    getDetailsAppOpenshift $project

    loginOpenshift

    checkProject $project
 
    if ! $openshiftCli project $project; then
        errorMsg 'openshiftLib.sh->deploymentsDiscovery : Projeto informado '${project}' nao existe, verifique no canvas '${openshiftServer}' o projeto correto'
        logoutOpenshift
        exit 1
    fi       
                   
    infoMsg 'openshiftLib.sh->deploymentsRollout : Realizando rollout de '${image}' '     
    $openshiftCli rollout latest dc/$image
    if [ "$?" -ne 0 ]; then
        errorMsg 'openshiftLib.sh->deploymentsRollout : Algo de errado aconteceu ao tentar executar o rollout no '${project}''
        logoutOpenshift
        errors='true'
    fi

    infoMsg 'openshiftLib.sh->deploymentsRollout : Aguardando rollout de '${image}''
    sleep 60 

    infoMsg 'openshiftLib.sh->deploymentsRollout : Listando ultimo 10 rollout de '${image}''
    $openshiftCli rollout history  dc/$image|tail -10
    if [ "$?" -ne 0 ]; then
        errorMsg 'openshiftLib.sh->deploymentsRollout : Algo de errado aconteceu ao tentar executar o rollout no '${project}''
        logoutOpenshift
        errors='true'
    fi

    if [ "$errors" == "true" ]; then
        errorMsg 'openshiftLib.sh->deploymentsDiscovery : Discovery apresentou erros'
        exit 1
    fi
}

# /**
# * stopApi
# * Método que faz o stop de api no openshift em um projeto
# * @version VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   $project 
# * @param   $image
# * @return  true / false
# */
stopApi (){
    project=''
    image=''
    local podList=''

    test ! -z $1 || { errorMsg 'openshiftLib.sh->stopApi : Project nao informada' ; exit 1; }
    test ! -z $2 || { errorMsg 'openshiftLib.sh->stopApi : Image nao informada' ; exit 1; }

    project=$1
    image=$2

    getDetailsAppOpenshift $project

    loginOpenshift

    checkProject $project
 
    if ! $openshiftCli project $project; then
        errorMsg 'openshiftLib.sh->stopApi : Projeto informado '${project}' nao existe, verifique no canvas '${openshiftServer}' o projeto correto'
        logoutOpenshift
        exit 1
    fi       

    infoMsg 'openshiftLib.sh->stopApi : Informacoes da api '${image}' em '${project}''   
    $openshiftCli describe dc ${image}

    infoMsg 'openshiftLib.sh->stopApi : Realizando o stop da api '${image}' em '${project}''     
    for podList in `$openshiftCli get pods |grep ${image}|awk '{print $1}'`; do 
        infoMsg 'openshiftLib.sh->stopApi : Deletando pod '${podList}''    
        $openshiftCli delete pod $podList; 
    done 
    
    infoMsg 'openshiftLib.sh->stopApi : Desativando novos rollout da api '${image}' em '${project}''   
    $openshiftCli scale --replicas=0 dc ${image}

    if [ "$?" -ne 0 ]; then
        errorMsg 'openshiftLib.sh->stopApi : Algo de errado aconteceu ao tentar executar o stop da api '${image}' no '${project}''
        logoutOpenshift
        errors='true'
    fi

    if [ "$errors" == "true" ]; then
        errorMsg 'openshiftLib.sh->stopApi : Stop da api '${image}' apresentou erros'
        exit 1
    fi
}

# /**
# * startpApi
# * Método que faz o start de api no openshift em um projeto
# * @version VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   $project 
# * @param   $image
# * @param   $replicas
# * @return  true / false
# */
startpApi (){
    project=''
    image=''
    replicas=''

    test ! -z $1 || { errorMsg 'openshiftLib.sh->startpApi : Project nao informada' ; exit 1; }
    test ! -z $2 || { errorMsg 'openshiftLib.sh->startpApi : Image nao informada' ; exit 1; }
    test ! -z $3 || { errorMsg 'openshiftLib.sh->startpApi : Replicas nao informada' ; exit 1; }

    project=$1
    image=$2
    replicas=$3

    getDetailsAppOpenshift $project

    loginOpenshift

    checkProject $project
 
    if ! $openshiftCli project $project; then
        errorMsg 'openshiftLib.sh->startpApi : Projeto informado '${project}' nao existe, verifique no canvas '${openshiftServer}' o projeto correto'
        logoutOpenshift
        exit 1
    fi       

    infoMsg 'openshiftLib.sh->startpApi : Ativando '${replicas}' replicas novas da api '${image}' em '${project}''   
    $openshiftCli scale --replicas=${replicas} dc ${image}
    if [ "$?" -ne 0 ]; then
        errorMsg 'openshiftLib.sh->startpApi : Algo de errado aconteceu ao tentar executar o start da api '${image}' no '${project}''
        logoutOpenshift
        errors='true'
    fi

    sleep 10

    infoMsg 'openshiftLib.sh->startpApi : Informacoes da api '${image}' em '${project}''   
    $openshiftCli describe dc ${image}
    if [ "$?" -ne 0 ]; then
        errorMsg 'openshiftLib.sh->startpApi : Algo de errado aconteceu ao tentar executar o start da api '${image}' no '${project}''
        logoutOpenshift
        errors='true'
    fi

    if [ "$errors" == "true" ]; then
        errorMsg 'openshiftLib.sh->startpApi : Start da api '${image}' apresentou erros'
        exit 1
    fi
}

# /**
# * deploymentsContainer
# * Método que orquestra o deploy no openshift tipo conteiner
# * @version VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   $project 
# *          $image 
# *          $environment 
# *          $noRoute
# *          $regionLatam
# *          $tribe
# *          $promotionSrc
# *          $promotionDst
# *          $noDeleteImage
# * @return  true / false
# */
deploymentsContainer (){
    project=''
    image=''
    local imageSize=''
    environment=''
    keepGoing=1
    promotionSrc=''
    promotionDst=''
    tribe=''

    test ! -z $1 || { errorMsg 'openshiftLib.sh->deploymentsContainer : Project nao informada' ; exit 1; }
    test ! -z $2 || { errorMsg 'openshiftLib.sh->deploymentsContainer : Imagem de conteiner nao informada' ; exit 1; }
    test ! -z $3 || { errorMsg 'openshiftLib.sh->deploymentsContainer : Ambiente nao informada' ; exit 1; }

    project=$1
    image="$2"
    environment=$3
    noRoute=$4
    regionLatam=$5
    tribe=$6
    noDeleteImage=$7
    promotionSrc=$8
    promotionDst=$9

    if [ "$promotionSrc" != "" ] && [ "$promotionDst" != "" ]; then
        infoMsg 'openshiftLib.sh->deploymentsContainer : Promocao de images foi ativada' 
        setDetailsPromotion 
        if [ "$promotionSrcOpenshiftServer" == "$promotionDstOpenshiftServer" ]; then
            if [ "$promotionSrcOpenshiftServer" == "https://api.internal.appcanvas.net:6443" ]; then
                openshiftCli='/opt/oc-v4.4/oc'
                skipTlsVerify="--insecure-skip-tls-verify"
            fi
            infoMsg 'openshiftLib.sh->deploymentsContainer : Aplicando promocao'
            echo "Modo: Mesmo Cluster"
            echo "Src: $promotionSrc"
            echo "Dst: $promotionDst"
            flagPromotion="same_cluster"
            loginOpenshift
            $openshiftCli project $promotionSrcProject
            checkServicePromotion $image
            if $openshiftCli tag $promotionSrc $promotionDst; then
                echo "Sucesso na promocao $promotionSrc > $promotionDst"
            else
                echo "Erro na promocao $promotionSrc > $promotionDst"
                errors='true'
            fi
            infoMsg 'openshiftLib.sh->deploymentsContainer : Aplicando tag '${promotionDstTag}' para latest'
            $openshiftCli project $promotionDstProject
            $openshiftCli tag $promotionDst $promotionDstProject/$promotionDstApp:latest
            logoutOpenshift
        else
            infoMsg 'openshiftLib.sh->deploymentsContainer : Aplicando promocao'
            echo "Modo: Diferente Cluster"
            echo "Src: $promotionSrc"
            echo "Dst: $promotionDstProject/$promotionDstApp-promotion:$versionPromotion-$promotionDstTag"
            flagPromotion="different_clusters"
            loginOpenshift
            $openshiftCli project $promotionDstProject
            checkServicePromotion $image
            if $openshiftCli import-image $promotionDstApp-promotion --confirm --from="$promotionSrcOpenshiftRegistry/$promotionSrcProject/$promotionSrcApp:latest" --reference-policy="local" --insecure=true; then
                echo "Sucesso na promocao $promotionSrc > $promotionDst"
            else
                echo "Erro na promocao $promotionSrc > $promotionDst"
                errors='true'
            fi    
            infoMsg 'openshiftLib.sh->deploymentsContainer : Aplicando tag '${promotionDstTag}' para latest'
            $openshiftCli tag $promotionDstProject/$promotionDstApp-promotion:latest $promotionDstProject/$promotionDstApp-promotion:$versionPromotion-$promotionDstTag
            logoutOpenshift  
        fi
    else
        getDetailsAppOpenshift $project

        #checkEnvironment

        checkService $image

        local tagImage=`echo $image|cut -d':' -f1`
        local imageClean=`echo $image|cut -d':' -f1`
        local version=`echo $image|cut -d':' -f2`
        tagImage=$tagImage:latest

        docker tag $image "$openshiftRegistry/$project/$image"
        sleep 2
        imageSize=$(docker images | grep "$openshiftRegistry/$project/$imageClean" | grep $version | awk '{print $7}')

        infoMsg 'openshiftLib.sh->deploymentsContainer : Fazendo o deploy do conteiner '${image}'['${imageSize}'] em '${openshiftRegistry}''
        docker login -p $openshiftToken -u unused $openshiftRegistry
        docker push "$openshiftRegistry/$project/$image"
        if [ "$?" -ne 0 ]; then
            errorMsg 'openshiftLib.sh->deploymentsContainer : Algo de errado aconteceu ao tentar executar o deploy do conteiner '${image}''
            errors='true'
        fi

        infoMsg 'openshiftLib.sh->deploymentsContainer : Tag da versao '${version}' sera aplicada em latest'
        keepGoing=1
        while [ $keepGoing -le 5 ]; do
            loginOpenshift
            if ! $openshiftCli tag $project/$image $project/$tagImage; then
                errorMsg 'openshiftLib.sh->deploymentsContainer : Algo de errado aconteceu ao tentar aplicar a tag '${project}'/'${image}' -> '${project}'/'${tagImage}', tentando novamente'
                errors='true'
                keepGoing=$((keepGoing + 1))
                sleep 2
            else
                infoMsg 'openshiftLib.sh->deploymentsContainer : Tag aplicada com sucesso '${project}'/'${image}' -> '${project}'/'${tagImage}' '
                keepGoing=99
            fi
            if [ $keepGoing -eq 5 ]; then
                errorMsg 'openshiftLib.sh->deploymentsContainer : Nao foi possivel aplicar a tag '${project}'/'${image}' -> '${project}'/'${tagImage}', impossivel continuar'
                errors='true'
                keepGoing=99
            fi
            logoutOpenshift
        done 

        if [ "$noDeleteImage" == "true" ]; then
            warnMsg 'openshiftLib.sh->deploymentsContainer : Ignorando limpeza de conteiner do deploy'
        else
            infoMsg 'openshiftLib.sh->deploymentsContainer : Limpando imagens criadas para deploy'
            docker rmi -f $(docker images|grep ${imageClean}) 2>/dev/null
        fi

        infoMsg 'openshiftLib.sh->deploymentsContainer : ByBy registry '${openshiftRegistry}' '
        #docker logout $openshiftRegistry
    fi

    if [ "$errors" == "true" ]; then
        errorMsg 'openshiftLib.sh->deploymentsContainer : Deploy apresentou erros, realizando rollback'
        exit 1
    fi
}

# /**
# * deploymentsInfra
# * Método faz chamadas a criação/equalização para infra as code com playbook's
# * @version VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   $project 
# *          $image
# *          $environment 
# *          $pathPackage
# * @return  true / false
# */
deploymentsInfra (){
    project='' 
    image=''
    environment=''
    pathPackage=''

    test ! -z $1 || { errorMsg 'openshiftLib.sh->deploymentsInfra : Project nao informada' ; exit 1; }
    test ! -z $2 || { errorMsg 'openshiftLib.sh->deploymentsInfra : Application nao informado' ; exit 1; }
    test ! -z $3 || { errorMsg 'openshiftLib.sh->deploymentsInfra : Ambiente nao informado' ; exit 1; }
    test ! -z $4 || { errorMsg 'openshiftLib.sh->deploymentsInfra : Caminho dos playbook para deploy nao informada' ; exit 1; }

    project=$1 
    image="$2"
    environment=$3
    pathPackage=$4
    local nameService=$(echo "$image")

    getDetailsAppOpenshift $project

    #checkEnvironment

    keepGoing=1
    while [ $keepGoing -le 5 ]; do
        loginOpenshift 
        checkProject $project
        if ! $openshiftCli project $project; then
            errorMsg 'openshiftLib.sh->deploymentsInfra : Algo de errado aconteceu ao selecionar '${project}' em '${openshiftServer}', tentando novamente'
            keepGoing=$((keepGoing + 1))
            sleep 2
        else
            keepGoing=99
        fi 

        if [ $keepGoing -eq 5 ]; then
            errorMsg 'openshiftLib.sh->deploymentsInfra : Ops erro ao selecionar '${project}' em '${openshiftServer}''
            logoutOpenshift
            exit 1
        fi
    done     

    local flagService=`$openshiftCli get services|grep "^$nameService "|awk '{print $1}'`

    if [ "$nameService" != "$flagService" ]; then
        infoMsg 'openshiftLib.sh->deploymentsInfra : Servico '${nameService}' nao existe em '${openshiftServer}', vou criar para voce ...'
        if ! $openshiftCli create -f $pathPackage; then
            errorMsg 'openshiftLib.sh->deploymentsInfra : Ops erro ao criar o service '${nameService}' em '${openshiftServer}''
            logoutOpenshift
            exit 1
        fi
        infoMsg 'openshiftLib.sh->deploymentsInfra : Servico '${nameService}' criado com sucesso em '${openshiftServer}''
        infoMsg 'openshiftLib.sh->deploymentsInfra : Configuracoes do servico '${nameService}''
        $openshiftCli describe service $nameService
    else
        warnMsg 'openshiftLib.sh->deploymentsInfra : Servico '${nameService}' existe em '${openshiftServer}', vamos atualizar o mesmo ...' 
        if ! $openshiftCli apply -f $pathPackage; then
            errorMsg 'openshiftLib.sh->deploymentsInfra : Ops erro ao atualizar o service '${nameService}' em '${openshiftServer}''
            logoutOpenshift
            exit 1
        fi
        infoMsg 'openshiftLib.sh->deploymentsInfra : Servico '${nameService}' atualizado com sucesso em '${openshiftServer}''
        infoMsg 'openshiftLib.sh->deploymentsInfra : Novas configuracoes do servico '${nameService}''
        $openshiftCli describe service $nameService
    fi

    logoutOpenshift
}

# /**
# * deploymentsTemplate
# * Método faz chamadas a criação aplicações no openshift por templates
# * @version VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   $project  
# *          $image
# *          $environment 
# *          $pathPackage
# *          $regionLatam
# *          $noRoute
# * @return  true / false
# */
deploymentsTemplate (){
    project='' 
    image=''
    environment=''
    pathPackage=''
    noService=false
    imageTag=''

    test ! -z $1 || { errorMsg 'openshiftLib.sh->deploymentsTemplate : Project nao informada' ; exit 1; }
    test ! -z $2 || { errorMsg 'openshiftLib.sh->deploymentsTemplate : Application nao informado' ; exit 1; }
    test ! -z $3 || { errorMsg 'openshiftLib.sh->deploymentsTemplate : Ambiente nao informado' ; exit 1; }
    test ! -z $4 || { errorMsg 'openshiftLib.sh->deploymentsTemplate : Caminho dos playbook para deploy nao informada' ; exit 1; }

    project=$1 
    image="$2"
    environment=$3
    pathPackage=$4
    regionLatam=$5
    noRoute=$6
    noService=$7
    imageTag=$8

    getDetailsAppOpenshift $project

    #checkEnvironment

    if [ "$noService" == "true" ]; then
        warnMsg "openshiftLib.sh->deploymentsTemplate : Fazendo bypass da criação de serviço/deployment"
    else
        checkService $image
    fi

    local tagImage=`echo $image|cut -d':' -f1`
    local imageClean=`echo $image|cut -d':' -f1`
    local version=`echo $image|cut -d':' -f2`

    if [[ "$noService" == "true" && -n $imageTag ]]; then
        tagImage=$tagImage:$imageTag
    else
        tagImage=$tagImage:latest
    fi

    docker tag $image "$openshiftRegistry/$project/$image"
    docker tag $image "$openshiftRegistry/$project/$tagImage"

    infoMsg 'openshiftLib.sh->deploymentsTemplate : Fazendo o deploy do conteiner '${image}' em '${openshiftRegistry}''
    docker login -p $openshiftToken -u unused $openshiftRegistry
    docker push "$openshiftRegistry/$project/$image"
    if [ "$?" -ne 0 ]; then
        errorMsg 'openshiftLib.sh->deploymentsTemplate : Algo de errado aconteceu ao tentar executar o deploy do conteiner '${image}''
        errors='true'
    fi

    infoMsg 'openshiftLib.sh->deploymentsTemplate : Fazendo o deploy do conteiner '${tagImage}' em '${openshiftRegistry}''
    docker login -p $openshiftToken -u unused $openshiftRegistry
    docker push "$openshiftRegistry/$project/$tagImage"
    if [ "$?" -ne 0 ]; then
        errorMsg 'openshiftLib.sh->deploymentsTemplate : Algo de errado aconteceu ao tentar executar o deploy do conteiner '${tagImage}''
        errors='true'
    fi

    infoMsg 'openshiftLib.sh->deploymentsTemplate : Limpando imagens criadas para deploy'
    docker rmi -f $(docker images|grep ${imageClean}|awk '{print $3}') 2>/dev/null

    infoMsg 'openshiftLib.sh->deploymentsTemplate : ByBy registry '${openshiftRegistry}' '
    #docker logout $openshiftRegistry

    if [ "$errors" == "true" ]; then
        errorMsg 'openshiftLib.sh->deploymentsTemplate : Deploy apresentou erros, realizando rollback'
        exit 1
    fi
}

# /**
# * pushImage
# * Método que faz push de imagem docker gerada para o registry do openshift
# * @version VERSION
# * @package DevOps
# * @author  Renato Thomazine <renato.thomazine@br.experian.com>
# * @param   $project  
# *          $image
# *          $imageTag
# * @return  true / false
# */
pushImage () {

    local project=$1
    local image="$2"
    local imageTag=$3

    deploymentsTemplate $project $image none none none true true $imageTag

    exit 0
}
