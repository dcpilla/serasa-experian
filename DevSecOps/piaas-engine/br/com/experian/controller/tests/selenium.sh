#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevSecOps Serasa Experian
# *
# * @version        1.0.0
# * @change         Script que interage com testes de selenium
# * @copyright      2024 &copy Serasa Experian
# * @author         Felipe Moura <felipe.moura@br.experian.com>
# * @date           13-May-2024
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
TEMP=`getopt -o h --long piaasEnv::,jdk::,application-name::,version::,build-number::,browser::,score::,branch::,project-repo::,external-repo::,help -n "$0" -- "$@"`
eval set -- "$TEMP"

# /**
# * piaasEnv
# * Define o ambiente do piaas
# * @var string
# */
piaasEnv=""

# /**
# * applicationName
# * Nome da aplicacao
# * @var string
# */
applicationName=""

# /**
# * branch
# * Branch utilizada no repositório de testes
# * @var string
# */
branch=""

# /**
# * externalRepo
# * Informe se será usado ou não repositório externo para testes
# * @var string
# */
externalRepo=""

# /**
# * projectRepo
# * Project do Bitbucket onde se encontra o repositório de teste
# * @var string
# */
projectRepo=""

# /**
# * versionApp
# * Define a versão da aplicação para testes
# * @var string
# */
versionApp=""

# /**
# * buildNumber
# * id do build
# * @var string
# */
buildNumber=""

# /**
# * jdkVersion
# * versao do jdk
# * @var string
# */
jdkVersion=""

# /**
# * seleniumBrowser
# * Define o browser para executar os testes
# * @var string
# */
seleniumBrowser=""

# /**
# * seleniumScore
# * Define para somente retorna o score
# * @var string
# */
seleniumScore="false"

# /**
# * usage
# * Método help do script
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
usage () {
    echo "selenium.sh version $VERSION - by DevSecOps Team"
    echo "Copyright (C) 2024 Serasa Experian"
    echo ""
    echo -e "selenium.sh script que manipula testes com selenium.\n"
    echo -e "Usage: selenium.sh --browser=chrome"
    echo -e "Options
    --score             Calculo de score [true|false] 
    --browser           browser que serao executados os testes     
    --h, --help         Ajuda"

    exit 1
}

# /**
# * validateParameters
# * Método que valida parametros
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
validateParameters () {
    if [[ "$seleniumBrowser" == "" || "$seleniumBrowser" != "chrome" && "$seleniumBrowser" != "edge" && "$seleniumBrowser" != "firefox" ]]; then
        errorMsg 'selenium.sh->validateParameters : Browser definido inválido'
        exit 1
    fi
}

# /**
# * getScore
# * Método retorna o score da aplicação
# *     Regras:
# *       - Se existir erros nos testes -> score=0
# *       - Se quantidade de testes for = 1 E não existir erros nos testes  -> score=50
# *       - Se quantidade de testes for > 1 E não existir erros nos teste -> score=100
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
getScore () {
    local qtdTest=0
    local score=0

    fileReportDone="$PWD/quality_tests/selenium/selenium_reports/selenium.json"
   
    qtdTest=$(jq -c '.[].elements[].keyword' $fileReportDone | wc -l)

    if [ "$qtdTest" == "" ];then
        errorMsg 'selenium.sh->getScore : Report 'selenium.json' para versao '${versionApp}' esta vazio. Impossivel continuar!'
        exit 1
    fi

    for line in `jq -c '.[].elements[].steps[].result.status' $fileReportDone |sed -e 's/"//;s/"//'`
    do
        if [ "$line" != "passed" ];then
            score=0
            echo $score
            exit 0
        fi
    done

    if [ $qtdTest -eq 0 ]; then
        score=0
        echo $score
        exit 0
    else
        score=100
        echo $score
        exit 0
    fi
}

# /**
# * uploadReportToS3
# * Método copia o report para buckets3
# * @version $VERSION
# * @package DevOps
# */
uploadReportToS3() {
    infoMsg 'selenium.sh-> uploadReportToS3()...'
    local bucket="piaas-reports-$awsAccount"
    local path="$applicationName/$buildNumber/selenium"
	
    reports=$(find ./quality_tests/selenium -type d -name '*_reports')

    zip_files=$(zip -r report.zip $reports 2>&1)
    zip_files_status=$?

    if [ $zip_files_status -eq 0 ]; then
        seleniumGetUrlReport=$(aws s3 cp report.zip "s3://$bucket/$path/" 2>&1)
        seleniumGetUrlReport_status=$?

        if [ $seleniumGetUrlReport_status -ne 0 ]; then
            errorMsg "selenium.sh-> Erro ao enviar o zip para S3: $seleniumGetUrlReport"
            exit 0
        else
            infoMsg "selenium.sh-> Concluído! Reports do selenium zipados e disponibilizados no S3"
        fi
    else
        errorMsg "selenium.sh-> Erro ao gerar o arquivo ZIP: $zip_files"
        exit 0
    fi
}

# /**
# * runnerExecute
# * Método executa a aplicação
# * @version $VERSION
# * @package DevOps
# * @author  Felipe Moura<felipe.moura@br.experian.com>
# */
runSeleniumTests () {

    infoMsg 'selenium.sh->runSeleniumTests()...'

    infoMsg "selenium.sh->Iniciando Container Selenium $seleniumBrowser..."
    if ! docker run -d \
        --shm-size="512mb" \
        --name selenium-$seleniumBrowser-$buildNumber \
        $awsAccount.dkr.ecr.sa-east-1.amazonaws.com/piaas-selenium-$seleniumBrowser:latest; \
    then
        errorMsg "Erro ao carregar selenium-$seleniumBrowser-$buildNumber"
        exit 1
    fi
    sleep 2

    infoMsg 'selenium.sh->Iniciando piaas-mvn-builder...'
    if ! docker run --rm \
        -e JDK=$jdkVersion \
        -e MVNCMD='clean install verify' \
        -e SELENIUM_SERVER=http://selenium-$seleniumBrowser-$buildNumber:4444 \
        -v $PWD/quality_tests/selenium:/app \
        --link selenium-$seleniumBrowser-$buildNumber \
        $awsAccount.dkr.ecr.sa-east-1.amazonaws.com/piaas-mvn-builder:latest; \
    then
        errorMsg "Erro ao carregar piaas-mvn-builder"
        exit 1
    fi

    echo ''
    infoMsg "selenium.sh->Parando containers..."
    seleniumContainerID=$(docker ps | grep "selenium-$seleniumBrowser-$buildNumber" | awk '{print $1}')
    docker stop $seleniumContainerID
    docker rm $seleniumContainerID

    if [[ -d "$PWD/quality_tests/selenium/selenium_reports" ]]; then
        infoMsg "selenium.sh->Diretorio 'selenium_reports' localizado"
        if [[ -f "$PWD/quality_tests/selenium/selenium_reports/selenium.json" ]]; then
            infoMsg "selenium.sh->Arquivo selenium.json' localizado"
            uploadReportToS3
        else
            errorMsg "selenium.sh->Arquivo selenium.json' não localizado"
            exit 1
        fi
    else
        errorMsg "selenium.sh->Diretorio 'selenium_reports' nao localizado"
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
        --version)
            case "$2" in
               "") shift 2 ;;
                *) versionApp="$2" ; shift 2 ;;
            esac ;;
        --build-number)
            case "$2" in
               "") shift 2 ;;
                *) buildNumber=$2 ; shift 2 ;;
            esac ;;
        --jdk)
            case "$2" in
               "") shift 2 ;;
                *) jdkVersion=$2 ; shift 2 ;;
            esac ;;
        --browser)
            case "$2" in
               "") shift 2 ;;
                *) seleniumBrowser="$2" ; shift 2 ;;
            esac ;;
        --score)
            case "$2" in
               "") shift 2 ;;
                *) seleniumScore=`echo ${2} | tr [:upper:] [:lower:]` ; shift 2 ;;
            esac ;;
        --external-repo)
            case "$2" in
               "") shift 2 ;;
                *) externalRepo="$2" ; shift 2 ;;
            esac ;;
        --branch)
            case "$2" in
               "") shift 2 ;;
                *) branch="$2" ; shift 2 ;;
            esac ;;
        --project-repo)
            case "$2" in
               "") shift 2 ;;
                *) projectRepo="$2" ; shift 2 ;;
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

if [ "$seleniumScore" == "true" ]; then
    getScore
else
    validateParameters
    runSeleniumTests
fi
