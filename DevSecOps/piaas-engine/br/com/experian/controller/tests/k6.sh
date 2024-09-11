#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           k6.sh
# * @version        $VERSION
# * @description    Script que interage com testes de carga
# * @copyright      2023 &copy Serasa Experian
# *
# *
# * @version        1.0.0
# * @change         [ADD] Script que executa testes de carga
# * @copyright      2023 & copy Serasa Experian
# * @author         Fabio P. Zinato <fabio.zinato@br.experian.com>
# * @dependencies   common.sh
# *                 
# * @date           02-Mai-2023
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
TEMP=$(getopt -o h --long js-test-path::,virtual-users::,test-duration::,strategy-test::,max-req-duration::,version::,script::,method::,image::,help -n "$0" -- "$@")
eval set -- "$TEMP"

# /**
# * jsTestPath
# * Caminho do arquivo .js para teste
# * @var string
# */
jsTestPath=''

# /**
# * image
# * image de build
# * @var string
# */
image=''

# /**
# * virtualUsers
# * Numero de usuarios virtuais
# * @var int
# */
virtualUsers=''

# /**
# * testDuration
# * Tempo de duracao do teste em segundos
# * @var string
# */
testDuration=''

# /**
# * testDuration
# * Tempo maximo em milisegundos de resposta para 95% das requisicoes para obter sucesso
# * @var string
# */
maxReqDuration=''

# /**
# * k6Param
# * Parametros para o jmeter quando informados
# * @var string
# */
k6Param=''

# /**
# * k6ParamShow
# * Parametros para o jmeter suprimidos user e passwd para mostrar na tela
# * @var string
# */
k6ParamShow=''

# /**
# * versionAppK6
# * Versao da app testada
# * @var string
# */
versionAppK6=''

# /**
# * usage
# * Método help do script
# * @version $VERSION
# * @package DevOps
# * @author  Fabio P. Zinato <fabio.zinato@br.experian.com>
# */
usage () {
    echo "k6.sh version $VERSION - by SRE Team"
    echo "Copyright (C) 2023 Serasa Experian"
    echo ""
    echo -e "k6.sh script que executa teste de carga com k6.\n"

    echo -e "Usage: k6.sh --virtual-users=30 --test-duration=20000 --max-req-duration=400\n"
    echo -e "Usage: k6.sh --strategy-test=canary ou --strategy-test=multiple\n"

    echo -e "Options
    --virtual-users           Numero de usuarios virtuais
    --max-req-duration        Tempo maximo em milisegundos de resposta para 95% das requisicoes para obter sucesso
    --test-duration           Tempo de duracao do teste em milisegundos
    --strategy-test           Executa o teste direto em uma versão canary com argo-rollouts [canary|multiple]"

    exit 1
}


# /**
# * startLoadTest
# * Método que inicia o teste de carga
# * @version $VERSION
# * @package DevOps
# * @author  Fabio P. Zinato <fabio.zinato@br.experian.com>
# */
startLoadTest () {
    getOutputTest=''
    hrdAvg=''
    hrdMin=''
    hrdMed=''
    hrdMax=''
    hrdP90=''
    hrdP95=''

    if [ "$maxReqDuration" == "" ]; then
        maxReqDuration='500'
    fi

    # Validação dos arquivos no path
    jsFiles=$(find $(pwd)/$jsTestPath -maxdepth 1 -type f -name "*.js")

    if [ -z "$jsFiles" ]; then
        errorMsg 'k6.sh->startPerformance : Nenhum arquivo JS encontrado para iniciar os testes de performance'
        exit 99
    fi

    infoMsg 'k6.sh->startPerformance : Iniciando o teste de performance'

    for jsFile in $jsFiles; do
        flag=`echo ${jsFile} | grep -o '/' | wc -l`
        flag=$(( $flag + 1 ))
        resultPerformance=$(echo ${jsFile} | cut -d '/' -f ${flag}|sed -e "s/.js//")

        infoMsg 'k6.sh->startPerformance : Executando script '${resultPerformance}''
        if [ "$k6Param" != "" ];then
            if [[ "$k6ParamShow" == *"--strategy-test=canary"* ]];then
                infoMsg 'k6.sh->startPerformance : Parâmetro strategy definido para execução '${k6ParamShow}''
                getOutputTest=$(docker run --rm -v $(pwd)/$jsTestPath/tests:/tests -v $(pwd)/$jsTestPath/$resultPerformance.js:/main.js $image $k6Param)
            else
                infoMsg 'k6.sh->startPerformance : Parâmetros definidos para execução '${k6ParamShow}''
                getOutputTest=$(docker run --rm -v $(pwd)/$jsTestPath/tests:/tests -v $(pwd)/$jsTestPath/$resultPerformance.js:/main.js $image $k6Param)
            fi
        else
            infoMsg 'k6.sh->startPerformance : Usando valores default para execução'
            getOutputTest=$(docker run --rm -v $(pwd)/$jsTestPath/tests:/tests -v $(pwd)/$jsTestPath/$resultPerformance.js:/main.js $image)
        fi

        if [ "$getOutputTest" == "" ]; then
            errorMsg "Nao retornou nenhum resultado na saida do comando!!!"
            exit 1
        else 
            # Show Load Test Result
            echo " "
            infoMsg "*** K6 Load Test Result - ${jsFile} ***"
            echo " "
            echo "$getOutputTest"

            # Call Convert Miliseconds Function
            hrdAvg=$(convertToMilisec "$(echo "$getOutputTest" | grep -E "http_req_duration" | awk -F' ' '{print $2}')")
            hrdMin=$(convertToMilisec "$(echo "$getOutputTest" | grep -E "http_req_duration" | awk -F' ' '{print $3}')")
            hrdMed=$(convertToMilisec "$(echo "$getOutputTest" | grep -E "http_req_duration" | awk -F' ' '{print $4}')")
            hrdMax=$(convertToMilisec "$(echo "$getOutputTest" | grep -E "http_req_duration" | awk -F' ' '{print $5}')")
            hrdP90=$(convertToMilisec "$(echo "$getOutputTest" | grep -E "http_req_duration" | awk -F' ' '{print $6}')")
            hrdP95=$(convertToMilisec "$(echo "$getOutputTest" | grep -E "http_req_duration" | awk -F' ' '{print $7}')")

            # Show Load Test Result
            if (( $(bc -l <<< "$hrdP95 > $maxReqDuration") )); then
                errorMsg "O teste de carga verificou que 95% das requisicoes tiveram uma resposta acima de ${maxReqDuration} para o arquivo ${jsFile}!!!!"
                exit 1
            fi
            if [ "$hrdP95" == "0" ]; then
                errorMsg "O teste de carga verificou que 95% das requisicoes para o arquivo ${jsFile} tiveram uma resposta igual a 0ms!!!!"
                exit 1
            fi
        fi    
    done
}

# Convert Seconds Function
convertToSec() {
    res=$(echo "$1 / 1000" | bc)
    echo $res
}

# Convert Miliseconds Function ( Miliseconds Normalize )
convertToMilisec() {
    if (echo $1 | egrep "ms" > /dev/null); then
        num=$(echo "$1" | awk -F'=' '{print $2}' | cut -d'm' -f1)
        echo $num

    elif (echo $1 | egrep "µs" > /dev/null); then
        num=$(echo "$1" | awk -F'=' '{print $2}' | cut -d'µ' -f1)
        res=$(echo "$num * 0.001" | bc)
        printf "%01.3f" $res

    else
        num=$(echo "$1" | awk -F'=' '{print $2}' | cut -d's' -f1)
        res=$(echo "$num * 1000" | bc)
        echo $res        
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

# Extrai opcoes passadas
while true ; do
    case "$1" in
        --js-test-path)
            case "$2" in
               "") shift 2 ;;
                *) jsTestPath="$2" ; shift 2 ;;
            esac ;;
        --virtual-users)
            case "$2" in
               "") shift 2 ;;
                *) k6Param=`echo "$k6Param --vus=$2"` ; k6ParamShow=`echo "$k6ParamShow --vus=$2"`; shift 2 ;;
            esac ;;
        --test-duration)
            case "$2" in
               "") shift 2 ;;
                *) k6Param=`echo "$k6Param --duration=$2ms"` ; k6ParamShow=`echo "$k6ParamShow --duration=$2ms"`; shift 2 ;;
            esac ;;
        --strategy-test)
            case "$2" in
               "") shift 2 ;;
                *) k6Param=`echo "$k6Param --env STRATEGY_TEST=$2"` ; k6ParamShow=`echo "$k6ParamShow --env --strategy-test=$2"`; shift 2 ;;
            esac ;;   
        --max-req-duration)
            case "$2" in
               "") shift 2 ;;
                *) maxReqDuration="$2" ; shift 2 ;;
            esac ;;
        --version)
            case "$2" in
               "") shift 2 ;;
                *) versionAppK6="$2" ; shift 2 ;;
            esac ;;
        --image)
            case "$2" in
               "") shift 2 ;;
                *) image=$2 ; shift 2 ;;
            esac ;;
        -h|--help) usage ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

startLoadTest
