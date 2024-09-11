#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           cucumber.sh
# * @version        $VERSION
# * @description    Script que interage com testes de cucumber
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

# /**
# * Variaveis
# */

# /**
# * VERSION
# * Versão do script
# */
VERSION='1.1.0'

# /**
# * TEMP
# * Leitura de opções
# * @var string
# */
TEMP=`getopt -o h --long piaasEnv::,application-name::,version::,build-number::,jdk::,score::,environment::,tag::,branch::,project-repo::,external-repo::,help -n "$0" -- "$@"`
eval set -- "$TEMP"

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
# * cucumberEnv
# * Define o ambiente de execução
# * @var string
# * ST=Stage | QA=QA | PRD=Produção
# */
cucumberEnv=""

# /**
# * cucumberTag
# * Define a tag para execução
# * @var string
# */
cucumberTag=""

# /**
# * cucumberScore
# * Define para somente retorna o score
# * @var string
# */
cucumberScore="false"

# /**
# * usage
# * Método help do script
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
usage () {
    echo "cucumber.sh version $VERSION - by DevSecOps Team"
    echo "Copyright (C) 2024 Serasa Experian"
    echo ""
    echo -e "cucumber.sh script que manipula teste com cucumber.\n"

    echo -e "Usage: cucumber.sh --version=1.0.0 --tag=@DEV
            or cucumber.sh --version=1.0.0 
            or cucumber.sh --score=true --environment=ST --version=1.0.0\n"
    
    echo -e "Options
    --application-name  Nome da aplicacao
    --version           Versao da aplicao para testes
    --build-number      Id da execucao da pipeline
    --piaasEnv          [prod|sandbox] Ambiente do PiaaS
    --score             [true|false] Calculo de score
    --tag               Tag para execução
    --environment       [ST|QA|PRD] Ambiente que os testes serão executados 
                        ST=Stage 
                        QA=QA 
                        PRD=Produção
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
    if [ "$versionApp" == "" ]; then
        errorMsg 'cucumber.sh->validateParameters : Versao da aplicacao nao definida para os testes. Exemplo --version=1.0.0'
        exit 1
    fi
    if [ "$applicationName" == "" ]; then
        errorMsg 'cucumber.sh->validateParameters : Nome da aplicacao. Exemplo --application-name=catalogo-infra-bitbucket-api'
        exit 1
    fi
}

# /**
# * getScore
# * Método retorna o score da aplicação
# *     Regras:
# *       - Se existir erros nos testes -> score=0
# *       - Se quantidade de testes for = 1 E não existir erros nos testes -> score=50
# *       - Se quantidade de testes for > 1 E não existir erros nos testes -> score=100
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
getScore () {
    local qtdTest=0
    local score=0

    fileReportDone="$PWD/quality_tests/cucumber/cucumber_reports/cucumber.json"
   
    qtdTest=$(jq -c '.[].elements[].keyword' $fileReportDone | wc -l)

    if [ "$qtdTest" == "" ];then
        errorMsg 'cucumber.sh->getScore : Report 'cucumber.json' para versao '${versionApp}' esta vazio. Impossivel continuar!'
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
# * Método que copia os reports para o bucketS3
# * @version $VERSION
# * @package DevOps
# */
uploadReportToS3() {
    infoMsg 'cucumber.sh-> uploadReportToS3()...'
    local bucket="piaas-reports-$awsAccount"
    local path="$applicationName/$buildNumber/cucumber"
	
    reports=$(find ./quality_tests/cucumber -type d -name '*_reports')

    zip_files=$(zip -r report.zip $reports 2>&1)
    zip_files_status=$?

    if [ $zip_files_status -eq 0 ]; then
        cucumberGetUrlReport=$(aws s3 cp report.zip "s3://$bucket/$path/" 2>&1)
        cucumberGetUrlReport_status=$?

        if [ $cucumberGetUrlReport_status -ne 0 ]; then
            errorMsg "cucumber.sh-> Erro ao enviar o zip para S3: $cucumberGetUrlReport"
            exit 0
        else
            infoMsg "cucumber.sh-> Concluído! Reports do cucumber zipados e disponibilizados no S3"
        fi
    else
        errorMsg "cucumber.sh-> Erro ao gerar o arquivo ZIP: $zip_files"
        exit 0
    fi
}

# /**
# * runnerCucumberTests
# * Método executa a aplicação
# * @version $VERSION
# * @package DevOps
# */
runnerCucumberTests () {
    infoMsg 'cucumber.sh->runnerCucumberTests...'

    javaCommand=""

    if [ "${cucumberEnv}" == "" ]; then
        if [ "${cucumberTag}" != "" ]; then
            echo "Aplicando a tag ${cucumberTag} para execucao do runner"
            javaCommand="-jar /app/target/*.jar ${cucumberTag}"
        else
            javaCommand="-jar /app/target/*.jar"
        fi
    else
        echo "Variável de ambiente => ${cucumberEnv}"
        if [ "${cucumberTag}" != "" ]; then
            echo "Aplicando a tag ${cucumberTag} para execucao do runner"
            javaCommand="-jar -D${cucumberEnv} /app/target/*.jar ${cucumberTag}"
        else
            javaCommand="-jar -D${cucumberEnv} /app/target/*.jar"
        fi
    fi

    infoMsg 'cucumber.sh->Iniciando piaas-mvn-builder...'
    if ! docker run --rm \
        -e JDK=$jdkVersion \
        -e MVNCMD='clean install verify' \
        -e JAVACMD="$javaCommand" \
        -v $PWD/quality_tests/cucumber:/app \
        $awsAccount.dkr.ecr.sa-east-1.amazonaws.com/piaas-mvn-builder:latest; \
    then
        errorMsg "Erro ao carregar piaas-mvn-builder"
        exit 1
    fi

    if [[ -d "$PWD/quality_tests/cucumber/cucumber_reports" ]]; then
        infoMsg "cucumber.sh->Diretorio 'cucumber_reports' localizado"
        if [[ -f "$PWD/quality_tests/cucumber/cucumber_reports/cucumber.json" ]]; then
            infoMsg "cucumber.sh->Arquivo cucumber.json' localizado"
            cp $PWD/quality_tests/cucumber/cucumber_reports/cucumber-html-reports/overview-features.html $PWD/quality_tests/cucumber/cucumber_reports/cucumber-html-reports/index.html
            uploadReportToS3
        else
            errorMsg "cucumber.sh->Arquivo cucumber.json' não localizado"
            exit 1
        fi
    else
        errorMsg "cucumber.sh->Diretorio 'cucumber_reports' nao localizado"
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
        --tag)
            case "$2" in
               "") shift 2 ;;
                *) cucumberTag="$2" ; shift 2 ;;
            esac ;;
        --environment)
            case "$2" in
               "") shift 2 ;;
                *) cucumberEnv="environment.name=$2" ; shift 2 ;;
            esac ;;
        --score)
            case "$2" in
               "") shift 2 ;;
                *) cucumberScore=`echo ${2} | tr [:upper:] [:lower:]` ; shift 2 ;;
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

if [ "$piaasEnv" == "prod" ]; then
    awsAccount="707064604759"
else
    awsAccount="559037194348"
fi



if [ "$cucumberScore" == "true" ]; then
    getScore
else
    validateParameters
    runnerCucumberTests
fi
