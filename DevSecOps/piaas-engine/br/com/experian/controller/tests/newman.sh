#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           newman.sh
# * @version        1.0.0
# * @description    Realiza testes e validações com Newman
# * @copyright      2022 &copy Serasa Experian
# *
# **/

# Diretorio base
baseDir="/opt/infratransac/core"

# Carrega commons
test -e "$baseDir"/br/com/experian/utils/common.sh || echo 'Ops, biblioteca common nao encontrada'
source "$baseDir"/br/com/experian/utils/common.sh

# /**
# * TEMP
# * Leitura de opções
# * @var string
# */

TEMP=`getopt -o tuemirwj::h --long workspace::,js-test-path::,strategy-test::,image:: -n "$0" -- "$@"`
eval set -- "$TEMP"

#Variaveis

# /**
# * workspace
# * Workspace de build
# * @var string
# */
workspace=''

# /**
# * image
# * image de build
# * @var string
# */
image=''

# /**
# * environment
# * Environment da aplicação
# * @var string
# */
jsTestPath=''

# /**
# * newmanParam
# * Parametros para o newman quando informados
# * @var string
# */
newmanParam=''

# /**
# * newmanParamShow
# * Parametros para o newman suprimidos user e passwd para mostrar na tela
# * @var string
# */
newmanParamShow=''

# /**
# * newmanTests
# * Método inicia os testes e realiza validações para atribuição de score
# * @package DevOps
# */
newmanTests() {

    newmanFiles=$(find $(pwd)/$jsTestPath -maxdepth 1 -type f -iname "*.json")
    newmanSwagger=$(find $(pwd)/$jsTestPath -maxdepth 1 -type f -iname "*.yaml")

    if [ -z "$newmanFiles" ]; then
        errorMsg 'newman.sh->startPerformance : Nenhum arquivo collection foi encontrado para iniciar os testes de performance'
        exit 99
    fi

    infoMsg 'newman.sh->startPerformance : Iniciando o teste de performance'

    for newmanFile in $newmanFiles; do
        flag=`echo ${newmanFile} | grep -o '/' | wc -l`
        flag=$(( $flag + 1 ))
        resultPerformance=$(echo ${newmanFile} | cut -d '/' -f ${flag}|sed -e "s/.json//")

        infoMsg 'newman.sh->startPerformance : Executando script '${resultPerformance}''

        if [ "$newmanSwagger" != "" ]; then
            if [[ "$newmanParamShow" == *"--strategy-test=canary"* ]]; then
                infoMsg 'newman.sh->startPerformance : Execução do newman com openapi e canary '${k6ParamShow}''
                docker run --rm \
                    -v $(pwd)/$jsTestPath/$resultPerformance.json:/collection.json \
                    -v $newmanSwagger:/swagger.yaml \
                    -v $(pwd)/$jsTestPath/$resultPerformance-report/:/results.json \
                    -v $(pwd)/$jsTestPath/$resultPerformance-report/:/swagger.json \
                    -e newmanSwagger=true \
                    -e strategyTest=true $image
            else
                infoMsg 'newman.sh->startPerformance : Execução do newman com openapi'
                docker run --rm \
                    -v $(pwd)/$jsTestPath/$resultPerformance.json:/collection.json \
                    -v $newmanSwagger:/swagger.yaml \
                    -v $(pwd)/$jsTestPath/$resultPerformance-report/:/results.json \
                    -v $(pwd)/$jsTestPath/$resultPerformance-report/:/swagger.json \
                    -e newmanSwagger=true $image
            fi
        else
            if [[ "$newmanParamShow" == *"--strategy-test=canary"* ]]; then
                infoMsg 'newman.sh->startPerformance : Execução do newman default com canary '${k6ParamShow}''
                docker run --rm \
                    -v $(pwd)/$jsTestPath/$resultPerformance.json:/collection.json \
                    -v $(pwd)/$jsTestPath/$resultPerformance-report/:/results.json \
                    -e strategyTest=true $image
            else
                infoMsg 'newman.sh->startPerformance : Execução do newman default'
                docker run --rm \
                    -v $(pwd)/$jsTestPath/$resultPerformance.json:/collection.json \
                    -v $(pwd)/$jsTestPath/$resultPerformance-report/:/results.json $image
            fi
        fi

        if [ $? -eq 1 ]; then
            errorMsg 'newman.sh->newmanTests: Ocorreu um erro ao realizar os testes com Newman. Não são permitidos testes com falhas.'
            exit 1
        fi

        totalTestsFailed=$(cat $(pwd)/$jsTestPath/$resultPerformance-report/newman-run-report-*.json | jq -s 'map(.run.stats.tests.failed) | add')

        if [ "$totalTestsFailed" -ge "1" ]; then
            errorMsg 'newman.sh->newmanTests: Seus testes restornaram com '$totalTestsFailed' falhas. Não são permitidos testes com falhas.'
            exit 1
        fi
    done
}

# Extrai opcoes passadas
while true ; do
    case "$1" in
        --workspace)
            case "$2" in
               "") shift 2 ;;
                *) workspace="$2" ; shift 2 ;;
            esac ;;
        --strategy-test)
            case "$2" in
               "") shift 2 ;;
                *) newmanParam=`echo "$newmanParam --env-var strategyTest=$2"` ; newmanParamShow=`echo "$newmanParamShow --strategy-test=$2"`; shift 2 ;;
            esac ;;
        --image)
            case "$2" in
               "") shift 2 ;;
                *) image="$2" ; shift 2 ;;
            esac ;;
        --js-test-path)
            case "$2" in
               "") shift 2 ;;
                *) jsTestPath="$2" ; shift 2 ;;
            esac ;;
        -h|--help) usage ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

newmanTests