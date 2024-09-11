#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevSecOps Serasa Experian
# *
# * @version        1.0.0
# * @change         Script que interage com testes de cypress
# * @copyright      2024 &copy Serasa Experian
# * @author         Paulo Ricassio <pauloricassio.dossantos@br.experian.com>
# * @date           04-Jun-2024
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
TEMP=$(getopt -o h --long piaasEnv::,application-name::,version::,build-number::,cypress-version::,score::,branch::,project-repo::,external-repo::,help -n "$0" -- "$@")
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
# * cypressVersion
# * Define a versão do cypress a ser utilizado para testes
# * @var string
# */
cypressVersion=""

# /**
# * cypressScore
# * Define para somente retorna o score
# * @var string
# */
cypressScore="false"

# /**
# * usage
# * Método help do script
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
usage () {
    echo "cypress.sh version $VERSION - by SRE Team"
    echo "Copyright (C) 2024 Serasa Experian"
    echo ""
    echo -e "cypress.sh script que manipula testes com Cypress.\n"

    echo -e "Usage: cypress.sh --method=protractor --score=true --runner=experian-eauth-identific-devplace-api-test --version=1.0.0 
            or cypress.sh --method=protractor --geturl=true --runner=experian-eauth-identific-devplace-api-test --type=api --version=1.0.0\n"
    
    echo -e "Options
    --score             Calculo de score [true|false]
    --version           Versao da aplicao para testes
    --cypressVersion    Versão do cypress para testes  
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
        errorMsg 'cypress.sh->validateParameters : Versao da aplicao nao definida para os testes. Exemplo --version=1.0.0'
        exit 1
    fi

    echo "A versão do cypress é: $cypressVersion"
    if [[ "$cypressVersion" == "" || "$cypressVersion" != "cypress12" && "$cypressVersion" != "cypress12-node20" && "$cypressVersion" != "cypress13" && "$cypressVersion" != "node12.18.0-chrome83-ff77" && "$cypressVersion" != "node16.16.0-chrome105-ff104-edge" && "$cypressVersion" != "latest" ]]; then
        errorMsg 'cypress.sh->validateParameters : Versão do cypress inválido ou não informado. Exemplo --cypress-version=cypress13'
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

    fileReportDone="$PWD/quality_tests/cypress/cypress_reports/cypress.json"
   
    qtdTest=$(jq -c '.results[].suites[]' $fileReportDone | wc -l)

    if [ "$qtdTest" == "" ];then
        errorMsg 'cypress.sh->getScore : Report 'cypress.json' para versao '${versionApp}' esta vazio. Impossivel continuar!'
        exit 1
    fi

    for line in `jq -c '.results[].suites[].tests[].state' $fileReportDone | sed -e 's/"//;s/"//'`
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
    infoMsg 'cypress.sh-> uploadReportToS3()...'
    local bucket="piaas-reports-$awsAccount"
    local path="$applicationName/$buildNumber/cypress"
	
    reports=$(find ./quality_tests/cypress -type d -name '*_reports')

    zip_files=$(zip -r report.zip $reports 2>&1)
    zip_files_status=$?

    if [ $zip_files_status -eq 0 ]; then
        cypressGetUrlReport=$(aws s3 cp report.zip "s3://$bucket/$path/" 2>&1)
        cypressGetUrlReport_status=$?

        if [ $cypressGetUrlReport_status -ne 0 ]; then
            errorMsg "cypress.sh-> Erro ao enviar o zip para S3: $cypressGetUrlReport"
            exit 0
        else
            infoMsg "cypress.sh-> Concluído! Reports do cypress zipados e disponibilizados no S3"
        fi
    else
        errorMsg "cypress.sh-> Erro ao gerar o arquivo ZIP: $zip_files"
        exit 0
    fi
}

# /**
# * runnerExecute
# * Método executa a aplicação
# * @version $VERSION
# * @package DevOps
# * @author  Paulo Ricassio<pauloricassio.dossantos@br.experian.com>
# */
runnerExecute () {
    infoMsg 'cypress.sh->runnerExecute...'

    infoMsg 'cypress.sh->Iniciando piass-cypress...'
    if ! docker run --rm \
        -v $PWD/quality_tests/cypress:/cypress \
        $awsAccount.dkr.ecr.sa-east-1.amazonaws.com/piaas-cypress:$cypressVersion; \
    then
        errorMsg "Erro ao carregar piaas-cypress"
        exit 1
    fi

    if [[ -d "$PWD/quality_tests/cypress/cypress_reports" ]]; then
        infoMsg "cypress.sh->Diretorio 'cypress_reports' localizado"
        if [[ -f "$PWD/quality_tests/cypress/cypress_reports/cypress.json" ]]; then
            infoMsg "cypress.sh->Arquivo cypress.json' localizado"
            uploadReportToS3
        else
            errorMsg "cypress.sh->Arquivo cypress.json' não localizado"
            exit 1
        fi
    else
        errorMsg "cypress.sh->Diretorio 'cypress_reports' nao localizado"
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
        --build-number)
            case "$2" in
               "") shift 2 ;;
                *) buildNumber=$2 ; shift 2 ;;
            esac ;;
        --version)
            case "$2" in
               "") shift 2 ;;
                *) versionApp="$2" ; shift 2 ;;
            esac ;;
        --cypress-version)
            case "$2" in
               "") shift 2 ;;
                *) cypressVersion="$2" ; shift 2 ;;
            esac ;;
        --score)
            case "$2" in
               "") shift 2 ;;
                *) cypressScore=$(echo ${2} | tr [:upper:] [:lower:]) ; shift 2 ;;
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

if [ "$cypressScore" == "true" ]; then
    getScore
else
    validateParameters
    runnerExecute
fi