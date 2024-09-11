#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           getImage.sh
# * @version        $VERSION
# * @description    Script que baixa images padrão do registry DevsecOps PaaS
# * @copyright      2022 &copy Serasa Experian
# *
# * @version        1.0.0
# * @change         Script que baixa images padrão do registry DevsecOps PaaS
# * @copyright      2022 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 
# * @date           31-Jan-2022
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
TEMP=$(getopt -o h --long image-name::,docker-tag::,ecr-image::,help -n "$0" -- "$@")
eval set -- "$TEMP"

# /**
# * imageName
# * Define a imageName
# * @var string
# */
imageName=""

# /**
# * dockerTag
# * Define a dockerTag
# * @var string
# */
dockerTag=""

# /**
# * tag
# * Define a tag
# * @var string
# */
tag=""

# /**
# * ecrImage
# * Define se a imagem está no ECR
# * @var string
# */
ecrImage=""

# /**
# * tokenRegistryDevSecOpsBr
# * Define a tokenRegistryDevSecOpsBr
# * @var string
# */
# tokenRegistryDevSecOpsBr=""
# tokenRegistryDevSecOpsBr="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZXYtc2Vjb3BzLWJyIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImplbmtpbnMtdG9rZW4tdDY4NnIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiamVua2lucyIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjI1MDY2YmEzLWY0NDAtMTFlOC04YzBkLTBhNTU5NzYzZDdkZSIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZXYtc2Vjb3BzLWJyOmplbmtpbnMifQ.hRSixmYTphX347sOfKnSmJFOcBBIWXmv-F6K39IuByuNYhG4uv7Btm4-oeAJFAeksS2dMisY6myEQAm-IEROn5o7NGtexkyjZI-xeR_o_FFffrVcqkm8AyFtVyVuHkr3C1VBqSEJd3M_A__NB-7wW9ZOvB_IpmSGkcHYjWk9xLMifnKSU2F8SNtMxO_dpyqZKGWOVpTXZm8zz1y2OhP0KODSDqvHtZyPyBxogncln-EgN_aaKLf4Li4LLCpiEN-NZnxKTb-r1oiSFT2C3jaUkYeVSZZXXDtUeL_9h_R-Yg79CsCU42llpwea4BEfhFspjKwiVqF_oBPDdp77QT8Prw"
tokenRegistryDevSecOpsBr=""
tokenRegistryDevSecOpsBr="eyJhbGciOiJSUzI1NiIsImtpZCI6IjNtQVhRUy0tU0FfbENBaVNDMGE4aXUyYVp3M0wxMDlyWm5uQkN0aVQycmcifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImplbmtpbnMtdG9rZW4tbGs3enMiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiamVua2lucyIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6ImViZTQ5MjdjLWI1OGItNDhlMC05Mzc5LTU1NzU1YTQ5ZDhlYiIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmplbmtpbnMifQ.iNNK3A5rH6lZpJAzGoiASRV6EwCD4S_-zwrzKaXJfl6iFNBmSiWvdThfkbbUQf20qOIXv1SnwU3k8nJW0Ek6FHyk2BlzIyU1kj9qNIsnnxjvD57moFx_EmmOoqU_SuDVR-vutXrIVfXStwicJo4DCdBXuYcQFFGjIveTWfdvj1eK0ZAW_aS0SwTGT9vjTsIaUSfA83zsaxzdvtUq1hzQUWwhWsEjWfg_JaNCle1oJIc3Xcewx0hGpj_xqzMAcaFWn_7_kUIPCx2Dw_mQATgBjnHh0mfNif2kNKmXgy-G1CZ8pUhSy2XRLA3OkWcxCRy032z5Url30pdT6ab6PW-7Iz-UIVStzsigwRP1M-v8GXXzy2s83gaFf43ulc7f6PPS9CGSZenB4Wx8Doftp9DYNRpQ956P63_-OvapnYHjxGOQsRVKFJAhZnimpiUO3T7gPpKDNruQ-r-T2sRhS2jNE1zUDEZTZW_gz00FT_1m7xpmh3j2ia5yMyTA6LcoaQkdZU9BNsqjdF5Ug9OlOKwYzz8C9z8TvkJjT6D6KGbEpaUcn0G3jWonOOQihn2z5d7J6c9dOdxjTfH0RKqYrb926whpfVlg8ERTb5IVTKH4SPmfSP0kzX5BfQqURbdcEWLqaCHvf7hFVI73aV_wEY9k8ETBOpjLVzT4-xMj7h76-Hw"

# /**
# * registryDevSecOpsBr
# * Define a registryDevSecOpsBr
# * @var string
# */
# registryDevSecOpsBr="docker-registry-default.f-internal.br.appcanvas.net/dev-secops-br"
registryDevSecOpsBr="default-route-openshift-image-registry.apps.zocprd1.br.experian.local/devsecops-br"
# /**
# * registryDevSecOpsEcr
# * Define a registryDevSecOpsBr
# * @var string
# */
registryDevSecOpsEcr="707064604759.dkr.ecr.sa-east-1.amazonaws.com"

# /**
# * registryCoeEcr
# * Define a registryCoeEcr
# * @var string
# */
registryCoeEcr="294463638235.dkr.ecr.sa-east-1.amazonaws.com"


# /**
# * registryDevHubEcr
# * Define a registryDevHubEcr
# * @var string
# */
registryDevHubEcr="564593125549.dkr.ecr.sa-east-1.amazonaws.com"

# /**
# * flagErro
# * Define a flagErro
# * @var string
# */
flagErro=

# /**
# * registryUrl
# * Define a registryUrl
# * @var string
# */
registryUrl=

# /**
# * usage
# * Método help do script
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
usage () {
    echo "getImages.sh version $VERSION - by DevSecOps PaaS Team"
    echo "Copyright (C) 2022 Serasa Experian"
    echo ""
    echo -e "getImages.sh Script que baixa images padrão do registry DevsecOps PaaS.\n"

    echo -e "Usage: getImages.sh --image-name=experian-centos7-java8:latest
                    getImages.sh --image-name=experian-centos7-java11:latest
                    getImages.sh --image-name=experian-centos7-java12:latest
                    getImages.sh --image-name=experian-alpine-zulu-jdk:8
                    getImages.sh --image-name=experian-alpine-zulu-jdk:8
                    getImages.sh --image-name=experian-alpine-zulu-jdk:11
                    getImages.sh --image-name=experian-alpine-zulu-jdk:13
                    getImages.sh --image-name=experian-alpine-zulu-jdk:17
                    getImages.sh --image-name=experian-debian-flutter-sdk:3.7
                    getImages.sh --image-name=experian-debian-flutter-sdk:3.10
                    getImages.sh --image-name=experian-debian-flutter-sdk:3.13
                    getImages.sh --image-name=experian-debian-flutter-sdk:3.16
                    getImages.sh --image-name=experian-debian-flutter-sdk:3.19
                    getImages.sh --image-name=experian-centos7-nodejs8:latest
                    getImages.sh --image-name=sonar-scanner-python:latest --docker-tag=sonar-scanner-python
                    getImages.sh --image-name=sonar-scanner-typescript:latest --docker-tag=sonar-scanner-typescript
                    getImages.sh --image-name=sonar-scanner-python-pytest:python3.6 --docker-tag=sonar-scanner-python-pytest:python3.6
                    getImages.sh --image-name=sonar-scanner-python-pytest:python3.6 --docker-tag=sonar-scanner-python-pytest:python
                    getImages.sh --image-name=sonar-scanner-python-pytest:python3.8 --docker-tag=sonar-scanner-python-pytest:python3.8
                    getImages.sh --image-name=sonar-scanner-python-pytest:python3.9 --docker-tag=sonar-scanner-python-pytest:python3.9
                    getImages.sh --image-name=sonar-scanner-python-pytest:python3.10 --docker-tag=sonar-scanner-python-pytest:python3.10
                    getImages.sh --image-name=sonar-scanner-python-pytest:python3.11 --docker-tag=sonar-scanner-python-pytest:python3.11
                    getImages.sh --image-name=sonar-scanner-python-pytest:python3.12 --docker-tag=sonar-scanner-python-pytest:python3.12
                    getImages.sh --image-name=sonar-scanner-alpine-python-pytest:python3.6 --docker-tag=sonar-scanner-alpine-python-pytest:python3.6
                    getImages.sh --image-name=sonar-scanner-alpine-python-pytest:python3.8 --docker-tag=sonar-scanner-alpine-python-pytest:python3.8
                    getImages.sh --image-name=sonar-scanner-alpine-python-pytest:python3.10 --docker-tag=sonar-scanner-alpine-python-pytest:python3.10
                    getImages.sh --image-name=sonar-scanner-alpine-python-pytest:python3.11 --docker-tag=sonar-scanner-alpine-python-pytest:python3.11
                    getImages.sh --image-name=yamllint:latest --docker-tag=yamllint
                    getImages.sh --image-name=ansible-tower-cli:latest --docker-tag=ansible-tower-cli
                    getImages.sh --image-name=ansible-tower-cli-experian:latest --docker-tag=ansible-tower-cli-experian
                    getImages.sh --image-name=ansible-tower-cli-experian-us:latest --docker-tag=ansible-tower-cli-experian-us
                    getImages.sh --image-name=angular6:latest --docker-tag=angular6
                    getImages.sh --image-name=python3.6:latest --docker-tag=python3.6
                    getImages.sh --image-name=minify:latest --docker-tag=minify
                    getImages.sh --image-name=sqlplus:develop --docker-tag=sqlplus
                    getImages.sh --image-name=detect-secrets:develop --docker-tag=detect-secrets
                    getImages.sh --image-name=spark-docker:latest --docker-tag=spark:2.3.0
                    getImages.sh --image-name=spark-docker:2.4.0 --docker-tag=spark:2.4.0
                    getImages.sh --image-name=veracode-reports --docker-tag=veracode-reports
                    getImages.sh --image-name=qs-reports --docker-tag=qs-reports
                    getImage.sh --image-name=run-cypress-test:latest
                    getImage.sh --image-name=run-cypress-test:cypress12
                    getImage.sh --image-name=run-cypress-test:node12.18.0-chrome83-ff77
                    getImage.sh --image-name=bruno-api:latest\n"
    
    echo -e "Options
    --image-name        Nome da image base a baixar
    --docker-tag        Nome para executar o docker tag local
    --h, --help         Ajuda"

    exit 1
}

# /**
# * getImage
# * Método de getImage
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
getImage () {
    flagErro=1
    registryUrl="$registryDevSecOpsBr/$imageName"

    if [ "$ecrImage" == "" ]; then
        infoMsg 'getImages.sh->getImage: Get image '${imageName}' in registry '${registryUrl}''   
        while [ $flagErro -eq 1 ]; do
            docker login -p $tokenRegistryDevSecOpsBr -u unused $registryDevSecOpsBr
            if docker pull "$registryUrl"; then
                infoMsg 'getImages.sh->getImage: Sucess in get '${imageName}''
                if [ "$dockerTag" != "" ];then 
                    infoMsg 'getImages.sh->getImage: Apply tag '${dockerTag}' for image '${imageName}''
                    docker tag "$registryDevSecOpsBr/$imageName" "$dockerTag"
                fi
                flagErro=0
            else
                warnMsg 'getImages.sh->getImage: Ops, erros in get image '${imageName}', retry in 5 seconds'
                sleep 5
            fi  
        done
    fi

    if [ "$ecrImage" != "" ]; then
        registryUrl="$registryDevSecOpsEcr/$imageName"

        infoMsg 'getImages.sh->getImage: Get image '${imageName}' in registry '${registryDevSecOpsEcr}''  
   
        if docker pull "$registryUrl"; then
            infoMsg 'getImages.sh->getImage: Sucess in get '${imageName}''
            if [ "$dockerTag" != "" ];then 
                infoMsg 'getImages.sh->getImage: Apply tag '${dockerTag}' for image '${imageName}''
                docker tag "$registryDevSecOpsEcr/$imageName" "$dockerTag"
            fi
        else
            warnMsg 'getImages.sh->getImage: Ops, erros in get image '${imageName}''
        fi
    fi
}

# /**
# * getEcrCredentials
# * Método de retorno das credenciais para login no Ecr
# * @version $VERSION
# * @package DevOps
# * @author  andre.arioli@br.experian.com
# */
getEcrCredentials () {

    credentials=$(cyberArkDap -s USCLD_PAWS_707064604759 -c BUUserForDevSecOpsPiaaS -a 707064604759)
    awsAccessKey=$(echo $credentials | cut -d' ' -f2)
    awsSecretKey=$(echo $credentials | cut -d' ' -f3)

    export AWS_ACCESS_KEY_ID=$awsAccessKey
    export AWS_SECRET_ACCESS_KEY=$awsSecretKey
    export AWS_DEFAULT_REGION=sa-east-1

    aws ecr get-login-password | docker login --username AWS --password-stdin 707064604759.dkr.ecr.sa-east-1.amazonaws.com
}

# /**
# * getEcrCredentialsCoe
# * Método de retorno das credenciais para login no Ecr do time CoE
# * @version $VERSION
# * @package DevOps
# * @author  andre.arioli@br.experian.com
# */
getEcrCredentialsCoe () {

    credentials=$(cyberArkDap -s USCLD_PAWS_294463638235_AFL -c BUUserForAirFlow -a 294463638235)
    awsAccessKey=$(echo $credentials | cut -d' ' -f2)
    awsSecretKey=$(echo $credentials | cut -d' ' -f3)

    export AWS_ACCESS_KEY_ID=$awsAccessKey
    export AWS_SECRET_ACCESS_KEY=$awsSecretKey
    export AWS_DEFAULT_REGION=sa-east-1

    aws ecr get-login-password | docker login --username AWS --password-stdin 294463638235.dkr.ecr.sa-east-1.amazonaws.com
}


# /**
# * getEcrCredentialsDevHub
# * Método de retorno das credenciais para login no Ecr do time DEVHUB
# * @version $VERSION
# * @package DevOps
# * @author  douglas.souza@br.experian.com
# */
getEcrCredentialsDevHub() {

    credentials=$(cyberArkDap -s USCLD_PAWS_564593125549 -c BUUserForDevSecOpsPiaaS -a 564593125549)
    awsAccessKey=$(echo $credentials | cut -d' ' -f2)
    awsSecretKey=$(echo $credentials | cut -d' ' -f3)

    export AWS_ACCESS_KEY_ID=$awsAccessKey
    export AWS_SECRET_ACCESS_KEY=$awsSecretKey
    export AWS_DEFAULT_REGION=sa-east-1

    aws ecr get-login-password | docker login --username AWS --password-stdin ${registryDevHubEcr}
}

# /**
# * getImageVeracodeReports
# * Método de getImageVeracodeReports
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
getImageVeracodeReports () {
    flagErro=1
    registryUrl="$registryDevSecOpsEcr/$imageName:latest"

    infoMsg 'getImages.sh->getImageVeracodeReports: Get image '${imageName}' in registry '${registryUrl}''

    infoMsg 'getImages.sh->getImageVeracodeReports: Stop ans remove conteiner '${imageName}' in local'
    if ! docker stop "$dockerTag"; then
       infoMsg 'getImages.sh->getImageVeracodeReports: Not exist conteiner '${imageName}' in local'
    fi
    if ! docker rm "$dockerTag"; then
       infoMsg 'getImages.sh->getImageVeracodeReports: Not exist conteiner '${imageName}' in local'
    fi

    while [ $flagErro -eq 1 ]; do
        if docker pull "$registryUrl"; then
            infoMsg 'getImages.sh->getImageVeracodeReports: Sucess in get '${imageName}''

            infoMsg 'getImages.sh->getImageVeracodeReports: Run conteiner '${imageName}''
            docker tag "$registryDevSecOpsEcr/$imageName" "$dockerTag"
            docker run -p 9091:80 --name "$dockerTag" -d -v /opt/infratransac/veracode-reports/:/var/www/html/veracode-reports "$dockerTag"
            flagErro=0
        else
            warnMsg 'getImages.sh->getImageVeracodeReports: Ops, erros in get image '${imageName}', retry in 5 seconds'  
            sleep 5
        fi
    done
}

#/**
# * getImageQsReports
# * Método de getImageQsReports
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
getImageQsReports () {
    flagErro=1
    registryUrl="$registryDevSecOpsEcr/$imageName:latest"

    infoMsg 'getImages.sh->getImageQsReports: Get image '${imageName}' in registry '${registryUrl}''

    infoMsg 'getImages.sh->getImageQsReports: Stop ans remove conteiner '${imageName}' in local'
    if ! docker stop "$dockerTag"; then
       infoMsg 'getImages.sh->getImageQsReports: Not exist conteiner '${imageName}' in local'
    fi
    if ! docker rm "$dockerTag"; then
       infoMsg 'getImages.sh->getImageQsReports: Not exist conteiner '${imageName}' in local'
    fi

    while [ $flagErro -eq 1 ]; do
        if docker pull "$registryUrl"; then
            infoMsg 'getImages.sh->getImageQsReports: Success in get '${imageName}''

            infoMsg 'getImages.sh->getImageQsReports: Run conteiner '${imageName}''
            docker tag "$registryDevSecOpsEcr/$imageName" "$dockerTag"
            docker run -p 9094:80 --name "$dockerTag" -d -v /opt/infratransac/qs-reports/:/var/www/html/qs-reports "$dockerTag"
            flagErro=0
        else
            warnMsg 'getImages.sh->getImageQsReports: Ops, erros in get image '${imageName}', retry in 5 seconds'  
            sleep 5
        fi
    done
}


#/**
# * getImageDevHub
# * Método de getImageDevHub
# * @version $VERSION
# * @package DevOps
# * @author  douglas.souza <douglas.souza@br.experian.com>
# */
getImageDevHub () {
    retry=1
    registryUrl="$registryDevHubEcr/$imageName"

    infoMsg 'getImages.sh->getImageDevHub: Authenticating to DEVHUB ECR...'

    getEcrCredentialsDevHub

    infoMsg 'getImages.sh->getImageDevHub: Get image '${imageName}' in registry '${registryUrl}''

    while [ $retry -eq 1 ]; do
        if docker pull "$registryUrl"; then
            infoMsg 'getImages.sh->getImageDevHub: Sucess in get '${imageName}''
            docker tag "$registryUrl" devhub-techdocs:latest
            docker rmi "$registryUrl"
            retry=0
        else
            warnMsg 'getImages.sh->getImageDevHub: Ops, erros in get image '${imageName}', retry in 5 seconds'  
            sleep 5
        fi
    done
}

#/**
# * getImageMagellanImageBase
# * Método de getImageMagellanImageBase
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
getImageMagellanImageBase () {
    flagErro=1
    registryUrl="712494193032.dkr.ecr.sa-east-1.amazonaws.com/$imageName"

    infoMsg 'getImages.sh->getImageMagellanImageBase: Get image '${imageName}' in registry '${registryUrl}''
    echo "images magellan"

    while [ $flagErro -eq 1 ]; do
        $(/var/lib/jenkins/.local/bin/aws ecr get-login --no-include-email --region sa-east-1 --profile=magellan)
        if docker pull "$registryUrl"; then
            infoMsg 'getImages.sh->getImageMagellanImageBase: Sucess in get '${imageName}''
            flagErro=0
        else
            warnMsg 'getImages.sh->getImageMagellanImageBase: Ops, erros in get image '${imageName}', retry in 5 seconds'  
            sleep 5
        fi
    done
}

#/**
# * getImageAirflowV1
# * Método de getImageAirflowV1
# * @version $VERSION
# * @package DevOps
# * @author  andre.arioli <andre.arioli@br.experian.com>
# */
getImageAirflowV1 () {
    retry=1
    registryUrl="$registryCoeEcr/$imageName"

    infoMsg 'getImages.sh->getImageAirflowV1: Authenticating to CoE ECR...'

    getEcrCredentialsCoe

    infoMsg 'getImages.sh->getImageAirflowV1: Get image '${imageName}' in registry '${registryUrl}''

    while [ $retry -eq 1 ]; do
        if docker pull "$registryUrl"; then
            infoMsg 'getImages.sh->getImageAirflowV1: Sucess in get '${imageName}''
            docker tag "$registryUrl" airflow-qs-test:v1
            docker rmi "$registryUrl"
            retry=0
        else
            warnMsg 'getImages.sh->getImageAirflowV1: Ops, erros in get image '${imageName}', retry in 5 seconds'  
            sleep 5
        fi
    done
}

#/**
# * getImageAirflowV2
# * Método de getImageAirflowV2
# * @version $VERSION
# * @package DevOps
# * @author  andre.arioli <andre.arioli@br.experian.com>
# */
getImageAirflowV2 () {
    retry=1
    registryUrl="$registryCoeEcr/$imageName"

    infoMsg 'getImages.sh->getImageAirflowV2: Authenticating to CoE ECR...'

    getEcrCredentialsCoe

    infoMsg 'getImages.sh->getImageAirflowV2: Get image '${imageName}' in registry '${registryUrl}''

    while [ $retry -eq 1 ]; do
        if docker pull "$registryUrl"; then
            infoMsg 'getImages.sh->getImageAirflowV2: Sucess in get '${imageName}''
            docker tag "$registryUrl" airflow-qs-test:v2
            docker rmi "$registryUrl"
            retry=0
        else
            warnMsg 'getImages.sh->getImageAirflowV2: Ops, erros in get image '${imageName}', retry in 5 seconds'  
            sleep 5
        fi
    done
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
        --image-name)
            case "$2" in
               "") shift 2 ;;
                *) imageName="$2" ; shift 2 ;;
            esac ;;
        --ecr-image)
            case "$2" in
               "") shift 2 ;;
                *) ecrImage="$2" ; shift 2 ;;
            esac ;;
        --docker-tag)
            case "$2" in
               "") shift 2 ;;
                *) dockerTag="$2" ; shift 2 ;;
            esac ;;
        -h|--help) usage ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

infoMsg 'getImages.sh: Start get image '${imageName}''

infoMsg 'getImages.sh: Set proxy'
export https_proxy=http://spobrproxy:3128
export http_proxy=http://spobrproxy:3128 

if [ "$ecrImage" != "" ]; then
    getEcrCredentials
fi

if [ "$imageName" == "veracode-reports" ]; then
    getImageVeracodeReports
elif [ "$imageName" == "qs-reports" ]; then
    getImageQsReports
elif [ "$imageName" == "devhub-techdocs:latest" ]; then
    getImageDevHub
elif [ "$imageName" == "odin:airflow-qs-test-v1" ]; then
    getImageAirflowV1
elif [ "$imageName" == "odin:airflow-qs-test-v2" ]; then
    getImageAirflowV2
else
    getImage
fi
