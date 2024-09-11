#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevSecOps
# * @name           jmeter.sh
# * @version        $VERSION
# * @description    Script que integra ao jmeter
# * @copyright      2024 &copy Serasa Experian
# *
# * @version        1.0.0
# * @change         Script que integra ao jmeter
# * @copyright      2024 &copy Serasa Experian
# * @author         Douglas Pereira <douglas.pereira@br.experian.com>
# * @dependencies   common.sh
# *                 559037194348.dkr.ecr.sa-east-1.amazonaws.com/piaas-jmeter:latest
# * @date           30-May-2024
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
TEMP=`getopt -o a::h --long application-name::,geturl::,path-test::,environment::,version-app::,think-time::,virtual-users::,rampup::,test-duration::,user-login::,password-login::,loopcount::,servername::,build-number::,piaasEnv::,help -n "$0" -- "$@"`
eval set -- "$TEMP"

# /**
# * jmeterGetUrlReport
# * Define para somente retorna o url de um relatório
# * @var string
# */
jmeterGetUrlReport="false"

# /**
# * jmeterParam
# * Parametros para o jmeter quando informados
# * @var string
# */
jmeterParam=''

# /**
# * jmeterParamShow
# * Parametros para o jmeter suprimidos user e passwd para mostrar na tela
# * @var string
# */
jmeterParamShow=''

# /**
# * applicationName
# * Nome da aplicacao
# * @var string
# */
applicationName=

# /**
# * environment
# * Ambiente
# * @var string
# */
environment=''

# /**
# * nameBuild
# * nome do build
# * @var string
# */
nameBuild=

# /**
# * versionApp
# * Versao da aplicacao que sera submetida
# * @var string
# */
versionApp=

# /**
# * pathTest
# * Workspace que contem os testes
# * @var string
# */
pathTest=

# /**
# * buildNumber
# * nome do build
# * @var string
# */
buildNumber=

# /**
# * usage
# * Método help do script
# * @version $VERSION
# * @package DevSecOps
# * @author  Douglas Pereira <douglas.pereira@br.experian.com>
# */
usage () {
    echo "jmeter.sh version $VERSION - by SRE Team"
    echo "Copyright (C) 2024 Serasa Experian"
    echo ""
    echo -e "jmeter.sh script que manipula teste de performance com jmeter.\n"

    echo -e "Usage: jmeter.sh --application-name=experian-magellan-crawler --environment=develop --path-test=/path/app1 --version-app=1.0.1
    or jmeter.sh --application-name=experian-magellan-crawler --environment=develop --path-test=/path/app1 --version-app=1.0.1 --think-time=1000 --virtual-users=5 --rampup=60  --test-duration=120 --user-login=teste_user --password-login=teste_de_teste
    or jmeter.sh --application-name=experian-magellan-crawler --environment=develop --path-test=/path/app1 --version-app=1.0.1 --think-time=1000 --virtual-users=5 --rampup=60  --test-duration=120 --user-login=teste_user --password-login=teste_de_teste --servername=https://teste/login --loopcount=5
    or jmeter.sh --geturl=true --application-name=experian-magellan-crawler --environment=develop --version-app=1.0.1\n"

    echo -e "Options
    --a, --application-name   Nome da aplicacão
    --geturl                  Retorna url de relatorio [true|false]
    --path-test               Workspace que contem os testes
    --environment             Ambiente do commit [develop|qa|prod]
    --think-time              Define o tempo(de pausa) entre cada transação do script em milessegundos
    --virtual-users           Define o numero de usuário simultaneos
    --rampup                  Define o de inicialização dos usuários simultaneos em segundos
    --test-duration           Define duração total do teste em segundos
    --user-login              Define logon de acesso caso exista
    --password-login          Define senha de acesso caso exista
    --servername              Define o path de url para teste
    --loopcount               Define numero de interacões por --virtual-users
    --version-app             Versao da aplicacao que sera submetida
    --build-number            Número da build de execução
    --piaasEnv                [prod|sandbox] Ambiente do PiaaS
    --help                    Ajuda"

    exit 1
}

# /**
# * startPerformace
# * Método que inicia o teste de performance
# * @version $VERSION
# * @package DevSecOps
# * @author  Douglas Pereira <douglas.pereira@br.experian.com>
# */
startPerformance () {
    local flag=''
    local resultPerformance=''
    
    jmeterFiles=$(find $(pwd)/$pathTest -type f -iname '*.jmx')

    if [ -z "$jmeterFiles" ]; then
        errorMsg 'jmeter.sh->startPerformance : Nenhum arquivo JMX encontrado para iniciar os testes de performance'
        exit 99
    fi
    
    infoMsg 'jmeter.sh->startPerformance : Iniciando o teste de performance'

    for test in $jmeterFiles; do
        flag=`echo ${test} | grep -o '/' | wc -l`
        flag=$(( $flag + 1 ))
        resultPerformance=$(echo ${test} | cut -d '/' -f ${flag}|sed -e "s/.jmx//")

        infoMsg 'jmeter.sh->startPerformance : Executando script '${resultPerformance}''
        if [ "$jmeterParam" != "" ];then
            infoMsg 'jmeter.sh->startPerformance : Parametros definidos para execucao '${jmeterParamShow}''
            docker run --rm $jmeterParam -v $(pwd)/$pathTest/$resultPerformance.jmx:/test_plan.jmx -v $(pwd)/$pathTest/$resultPerformance-report/:/report/ $awsAccount.dkr.ecr.sa-east-1.amazonaws.com/piaas-jmeter:latest
        else
            infoMsg 'jmeter.sh->startPerformance : Usando valores default para execucao'
            docker run --rm $jmeterParam -v $(pwd)/$pathTest/$resultPerformance.jmx:/test_plan.jmx -v $(pwd)/$pathTest/$resultPerformance-report/:/report/ $awsAccount.dkr.ecr.sa-east-1.amazonaws.com/piaas-jmeter:latest
        fi

        flag=''
        resultPerformance=''
    done
}

# /**
# * uploadReportToS3
# * Método que faz o upload para o s3
# * @version $VERSION
# * @package DevSecOps
# * @author  Douglas Pereira <douglas.pereira@br.experian.com>
# */
uploadReportToS3() {
    infoMsg 'jmeter.sh-> uploadReportToS3()...'
    local bucket="piaas-reports-$awsAccount"
    local path="$applicationName/$buildNumber/jmeter"

    reports=$(find ./jmeter -type d -name '*-report')

    zip_files=$(zip -r report.zip $reports 2>&1)
    zip_files_status=$?

    if [ $zip_files_status -eq 0 ]; then
        jmeterGetUrlReport=$(aws s3 cp report.zip "s3://$bucket/$path/" 2>&1)
        jmeterGetUrlReport_status=$?

        if [ $jmeterGetUrlReport_status -ne 0 ]; then
            errorMsg "jmeter.sh-> Erro ao enviar o zip para S3: $jmeterGetUrlReport"
            exit 0
        else
            infoMsg "jmeter.sh-> Concluído! Reports do Jmeter zipados e disponibilizados no S3"
        fi
    else
        errorMsg "jmeter.sh-> Erro ao gerar o arquivo ZIP: $zip_files"
        exit 0
    fi
 }

# Valida passagem de parametros
if [ $# -eq 1 ];then
    usage
    exit 1
fi

# Extrai opções passadas
while true ; do
    case "$1" in
        -a|--application-name)
            case "$2" in
               "") shift 2 ;;
                *) applicationName="$2" ; shift 2 ;;
            esac ;;
        --geturl)
            case "$2" in
               "") shift 2 ;;
                *) jmeterGetUrlReport=`echo ${2} | tr [:upper:] [:lower:]` ; shift 2 ;;
            esac ;;
        --path-test)
            case "$2" in
               "") shift 2 ;;
                *) pathTest="$2" ; shift 2 ;;
            esac ;;
        --think-time)
            case "$2" in
               "") shift 2 ;;
                *) jmeterParam=`echo "$jmeterParam -v -Jthinktime=$2"` ; jmeterParamShow=`echo "$jmeterParamShow -Jthinktime=$2"` ; shift 2 ;;
            esac ;;
        --virtual-users)
            case "$2" in
               "") shift 2 ;;
                *) jmeterParam=`echo "$jmeterParam -v -Jvirtualusers=$2"` ; jmeterParamShow=`echo "$jmeterParamShow -Jvirtualusers=$2"` ; shift 2 ;;
            esac ;;
        --rampup)
            case "$2" in
               "") shift 2 ;;
                *) jmeterParam=`echo "$jmeterParam -v -Jrampup=$2"` ; jmeterParamShow=`echo "$jmeterParamShow -Jrampup=$2"` ; shift 2 ;;
            esac ;;
        --test-duration)
            case "$2" in
               "") shift 2 ;;
                *) jmeterParam=`echo "$jmeterParam -v -Jtestduration=$2"` ; jmeterParamShow=`echo "$jmeterParamShow -Jtestduration=$2"` ; shift 2 ;;
            esac ;;
        --user-login)
            case "$2" in
               "") shift 2 ;;
                *) jmeterParam=`echo "$jmeterParam -v -Juser=$2"` ; jmeterParamShow=`echo "$jmeterParamShow -Juser=NUNCA_TE_CONTAREI_hehe"` ; shift 2 ;;
            esac ;;
        --password-login)
            case "$2" in
               "") shift 2 ;;
                 *) jmeterParam=`echo "$jmeterParam -v -Jpassword=$2"` ; jmeterParamShow=`echo "$jmeterParamShow -Jpassword=NUNCA_TE_CONTAREI_hehe"` ; shift 2 ;;
            esac ;;
        --servername)
            case "$2" in
               "") shift 2 ;;
                 *) jmeterParam=`echo "$jmeterParam -v -Jservername=$2"` ; jmeterParamShow=`echo "$jmeterParamShow -Jservername=$2"` ; shift 2 ;;
            esac ;;
        --loopcount)
            case "$2" in
               "") shift 2 ;;
                 *) jmeterParam=`echo "$jmeterParam -v -Jloopcount=$2"` ; jmeterParamShow=`echo "$jmeterParamShow -Jloopcount=$2"` ; shift 2 ;;
            esac ;;
        --version-app)
            case "$2" in
               "") shift 2 ;;
                *) versionApp=$2 ; shift 2 ;;
            esac ;;
        --environment)
            case "$2" in
               "") shift 2 ;;
                *) environment=`echo ${2} | tr [:upper:] [:lower:]` ; shift 2 ;;
            esac ;;
        --build-number)
            case "$2" in
               "") shift 2 ;;
                *) buildNumber=$2 ; shift 2 ;;
            esac ;;
        --piaasEnv)
            case "$2" in
               "") shift 2 ;;
                *) piaasEnv=$2 ; shift 2 ;;
            esac ;;
        --help) usage ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

if [ "$piaasEnv" == "prod" ]; then
    awsAccount="707064604759"
else
    awsAccount="559037194348"
fi

if [ "$jmeterGetUrlReport" == "true" ]; then
    uploadReportToS3
else
    startPerformance
fi
