#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           qsTest.sh
# * @version        $VERSION
# * @description    Script que interage com diferentes framework de testes integrado ao modulo do qs-test do CORE
# * @copyright      2020 &copy Serasa Experian
# *
# * @version        1.0.3
# * @change         [BUG] Melhoria na validação de relatorios de testes de qualidade Cucumber/Cypress
# * @copyright      2022 &copy Serasa Experian
# * @author         Felipe Olivotto <felipe.olivotto@br.experian.com>
# * @dependencies   common.sh
# *                 /opt/infratransac/core/bin/vendor/xml2json/xml2json.py
# *                 /usr/local/bin/jq
# * @date           24-Oct-2022
# *
# * @version        1.0.2
# * @change         [BUG] Quando aplicação tem nenhum teste considerando 50 de score
# * @copyright      2020 & copy Serasa Experian
# * @author         DevSecOps PaaS Brazil. 
# * @dependencies   common.sh
# *                 /opt/infratransac/core/bin/vendor/xml2json/xml2json.py
# *                 /usr/local/bin/jq
# * @date           01-Fev-2022
# *
# * @version        1.0.1
# * @change         Inclusao da validacao do relatorio cypress no metodo getScore()
# * @copyright      2020 & copy Serasa Experian
# * @author         DevSecOps PaaS Brazil. 
# * @dependencies   common.sh
# *                 /opt/infratransac/core/bin/vendor/xml2json/xml2json.py
# *                 /usr/local/bin/jq
# * @date           11-Jan-2022
# *
# * @version        1.0.0
# * @change         Script que interage com diferentes framework de testes integrado ao modulo do qs-test do CORE
# * @copyright      2020 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 /opt/infratransac/core/bin/vendor/xml2json/xml2json.py
# *                 /usr/local/bin/jq
# * @date           02-Out-2020
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
TEMP=$(getopt -o h --long score::,geturl::,runner::,version::,script::,method::,help -n "$0" -- "$@")
eval set -- "$TEMP"

# /**
# * qsTestRunner
# * Define o runner de execução
# * @var string
# */
qsTestRunner=""

# /**
# * qsTestScript
# * Define o script para execução
# * @var string
# */
qsTestScript=""

# /**
# * qsTestMethod
# * Define o tipo o framework de teste
# * @var string
# */
qsTestMethod=""

# /**
# * qsTestScore
# * Define para somente retorna o score
# * @var string
# */
qsTestScore="false"

# /**
# * qsTestGetUrlReport
# * Define para somente retorna o url de um relatório
# * @var string
# */
qsTestGetUrlReport="false"

# /**
# * qsTestUrlReports
# * Url base dos relatorios cucumber
# * @var string
# */
qsTestUrlReports=""

# /**
# * versionApp
# * Define a versão da aplicação para testes
# * @var string
# */
versionApp=""

# /**
# * resultsDir
# * Diretório base para os resultados do scan do cucumber
# * @var string
# */
resultsDir=""

# /**
# * urlPackage
# * Url do pacote no nexus
# * @var string
# */
urlPackage=""

# /**
# * usage
# * Método help do script
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
usage () {
    echo "qsTest.sh version $VERSION - by SRE Team"
    echo "Copyright (C) 2020 Serasa Experian"
    echo ""
    echo -e "qsTest.sh script que manipula testes com diferentes framework.\n"

    echo -e "Usage: qsTest.sh --method=protractor --score=true --runner=experian-eauth-identific-devplace-api-test --version=1.0.0 
            or qsTest.sh --method=protractor --geturl=true --runner=experian-eauth-identific-devplace-api-test --type=api --version=1.0.0\n"
    
    echo -e "Options
    --score             Calculo de score [true|false] 
    --geturl            Retorna url de relatorio [true|false] 
    --runner            Runner para executar
    --method            Framework usado para os testes
    --script            Execução de script customizado para testes
    --version           Versao da aplicao para testes
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

    if [ "$qsTestRunner" == "" ]; then
        errorMsg 'qsTest.sh->validateParameters : Runner de execucao nao definido. Exemplo --runner=experian-eauth-identific-devplace-api-test'
        exit 1
    fi

    if [ "$qsTestMethod" == "" ]; then
        errorMsg 'qsTest.sh->validateParameters : Metodo de execucao do runner nao definido. Exemplo --method=protractor ou --method=selenium'
        exit 1
    fi

    if [ "$versionApp" == "" ]; then
        errorMsg 'qsTest.sh->validateParameters : Versao da aplicao nao definida para os testes. Exemplo --version=1.0.0'
        exit 1
    fi

    case $qsTestMethod in
        protractor) 
            resultsDir="/opt/infratransac/qs-reports/protractor"
            qsTestUrlReports="http://spobrjenkins:9094/qs-reports/protractor/${qsTestRunner}/${reportDone}"
        ;;
        cypress) 
            resultsDir="/opt/infratransac/qs-reports/cypress"
            qsTestUrlReports="http://spobrjenkins:9094/qs-reports/cypress/${qsTestRunner}/${reportDone}"
        ;;
        mocha) 
            resultsDir="/opt/infratransac/qs-reports/mocha"
            qsTestUrlReports="http://spobrjenkins:9094/qs-reports/mocha/${qsTestRunner}/${reportDone}"
        ;;
        *) errorMsg 'qsTest.sh->validateParameters : Metodo informado '${qsTestMethod}' nao implementado' ; exit 1;;
    esac
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
    local reportDone=''
    local fileReportJson=''
    local flagReportCustomized=''

    reportDone=$(ls -lt "$resultsDir/$qsTestRunner"| grep "$versionApp"|head -1|awk '{print $9}')
    if [ "$reportDone" == "" ]; then
        echo "0"
        exit 0
    fi

    fileReportDone=$(ls "$resultsDir/$qsTestRunner/$reportDone/"*.json 2> /dev/null)
    if [ "$fileReportDone" == "" ]; then # Se o ultimo não estiver concluido  será considerado o penultimo
        reportDone=$(ls -lt "$resultsDir/$qsTestRunner"| grep "$versionApp"|head -2|awk '{print $9}'|tail -1)
        fileReportDone=$(ls "$resultsDir/$qsTestRunner/$reportDone/"*.json 2> /dev/null)
        if [ "$fileReportDone" == "" ]; then 
            echo "0"
            exit 0
        fi    
    fi
   
    echo $fileReportDone |grep "customized.json" > /dev/null
    flagReportCustomized=$?
    if [ $flagReportCustomized -eq 0 ]; then
        qtdTest=$(/usr/local/bin/jq -r '.total' $fileReportDone)

        if [ $(/usr/local/bin/jq -r '.test_fail' $fileReportDone) -gt 0 ]; then 
            score=0
            echo $score
            exit 0
        fi
    elif [ "$qsTestMethod" == "cypress" ]; then
        if [[ $fileReportDone == *"mochawesome"* ]]; then
            score=0
            echo $score
            errorMsg 'qsTest.sh->getScore : We found file mochawesome with in your reports.Please check your Cypress script in merge step!'
            exit 99
        fi

        qtdTest=$(/usr/local/bin/jq -r '.stats.tests' $fileReportDone)
            if [ "$qtdTest" == null ]; then 
                score=0
                echo $score
                exit 0
            fi

        if [ $(/usr/local/bin/jq -r '.stats.failures' $fileReportDone) -gt 0 ]; then 
            score=0
            echo $score
            exit 0
        fi
    else
        qtdTest=$(/usr/local/bin/jq -c '.[].elements[].keyword' $fileReportDone |wc -l)

        for line in $(/usr/local/bin/jq -r -c '.[].elements[].steps[].result.status' $fileReportDone)
        do
            if [ "$line" != "passed" ];then
                score=0
                echo $score
                exit 0
            fi
        done
    fi

    if [ "$qtdTest" == "" ];then
        errorMsg 'qsTest.sh->getScore : Report '${fileReportDone}' para versao '${versionApp}' esta vazio. Impossivel continuar!'
        exit 1
    fi

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
# * urlFormatter
# * Método formata a url do relatorio da aplicação 
# * @version $VERSION
# * @package DevOps
# * @author  Felipe Olivotto <felipe.olivotto@br.experian.com>
# */

#   NIKEDEVSEC-2462 - Melhoria na validação de relatorios de testes de qualidade Cucumber/Cypress
urlFormatter () {
    reportDone=$1
    qsTestRunner=$2
    qsTestMethod=$3

    case $qsTestMethod in
        protractor) qsTestUrlReports="http://spobrjenkins:9094/qs-reports/protractor/${qsTestRunner}/${reportDone}";;
        cypress) qsTestUrlReports="http://spobrjenkins:9094/qs-reports/cypress/${qsTestRunner}/${reportDone}";;
        mocha) qsTestUrlReports="http://spobrjenkins:9094/qs-reports/mocha/${qsTestRunner}/${reportDone}";;
        *) errorMsg 'qsTest.sh->getUrlReport : Metodo informado '${qsTestMethod}' nao implementado' ; exit 1;;
    esac

    echo $qsTestUrlReports
}


# /**
# * getUrlReport
# * Método retorna a url do relatorio da aplicação
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
getUrlReport () {
    local reportDone=''
    
#   NIKEDEVSEC-2462 - Melhoria na validação de relatorios de testes de qualidade Cucumber/Cypress
    reportDone=$(ls -lt "$resultsDir/$qsTestRunner"| grep "$versionApp"|head -1|awk '{print $9}')
    if [ "$reportDone" == "" ]; then
        echo "Relatorio qsTest $qsTestRunner da versao $versionApp nao encontrado"
        exit 0
    else
        fileReportDone=$(ls "$resultsDir/$qsTestRunner/$reportDone/"*.json 2> /dev/null)
        if [ "$fileReportDone" == "" ]; then # Se o ultimo não estiver concluido  será considerado o penultimo
            echo "O ultimo relatorio da versao $versionApp ainda nao foi concluido. Validando o penultimo relatorio..."
            reportDone=$(ls -lt "$resultsDir/$qsTestRunner"| grep "$versionApp"|head -2|awk '{print $9}'|tail -1)
            fileReportDone=$(ls "$resultsDir/$qsTestRunner/$reportDone/"*.json 2> /dev/null)
            if [ "$fileReportDone" == "" ]; then 
                echo "Relatorio qsTest $qsTestRunner da versao $versionApp nao encontrado"
                exit 0
            else
                urlFormatter $reportDone $qsTestRunner $qsTestMethod
            fi
        else
            urlFormatter $reportDone $qsTestRunner $qsTestMethod
        fi
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
        --score)
            case "$2" in
               "") shift 2 ;;
                *) qsTestScore=$(echo ${2} | tr [:upper:] [:lower:]) ; shift 2 ;;
            esac ;;
        --geturl)
            case "$2" in
               "") shift 2 ;;
                *) qsTestGetUrlReport=$(echo ${2} | tr [:upper:] [:lower:]) ; shift 2 ;;
            esac ;;
        --runner)
            case "$2" in
               "") shift 2 ;;
                *) qsTestRunner="$2" ; shift 2 ;;
            esac ;;
        --method)
            case "$2" in
               "") shift 2 ;;
                *) qsTestMethod=$(echo ${2} | tr [:upper:] [:lower:]) ; shift 2 ;;
            esac ;;
        --script)
            case "$2" in
               "") shift 2 ;;
                *) cucumberScript="$2" ; shift 2 ;;
            esac ;;
        --version)
            case "$2" in
               "") shift 2 ;;
                *) versionApp="$2" ; shift 2 ;;
            esac ;;
        -h|--help) usage ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

validateParameters

if [ "$qsTestScore" == "true" ]; then
    getScore
elif [ "$qsTestGetUrlReport" == "true" ]; then
    getUrlReport
fi
