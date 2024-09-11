#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           veracode.sh
# * @version        $VERSION
# * @description    Script que integra via API ao veracode
# * @copyright      2024 &copy Serasa Experian
# *
# * @version        10.0.0
# * @change         - Reescrita do script para integração com as APIs de DevSecOps.
# * @contribution   Andre Arioli <andre.arioli@.br.experian.com>
# * @dependencies   common.sh
# *                 iamLib.sh
# * @date           26-Jun-2024

# /**
# * Configurações iniciais
# */

# Diretorio base
baseDir="/opt/infratransac/core"

# Carrega commons
test -e "$baseDir"/br/com/experian/utils/common.sh || echo 'Ops, biblioteca common nao encontrada'
source "$baseDir"/br/com/experian/utils/common.sh

# Carrega iamLib
test -e "$baseDir"/br/com/experian/utils/iamLib.sh || echo 'Ops, biblioteca iamLib nao encontrada'
source "$baseDir"/br/com/experian/utils/iamLib.sh

# /**
# * Variaveis
# */

# /**
# * VERSION
# * Versão do script
# */
VERSION='10.0.0'

# /**
# * TEMP
# * Leitura de opções
# * @var string
# */
TEMP=`getopt -o vue::h --long veracode-id::,application-name::,application-type::,upload-dir::,version-app::,extensao::,force::,piaas-entity-id:: -n "$0" -- "$@"`
eval set -- "$TEMP"

# /**
# * veracodeForce
# * Forcar criação de veracode ignorando reports validos
# * @var string
# */
veracodeForce='false'

# /**
# * appId
# * Id da aplicacao no veracode
# * @var int
# */
appId=

# /**
# * applicationName
# * Nome da aplicacao 
# * @var string
# */
applicationName=

# /**
# * applicationType
# * Tipo da aplicacao 
# * @var string
# */
applicationType=

# /**
# * extensao
# * Extensao da aplicacao 
# * @var int
# */
extensao=

# /**
# * buildName
# * nome do build
# * @var string
# */
buildName=

# /**
# * piaasEntityId
# * Identificador do piaas entity
# * @var int
# */
piaasEntityId=

# /**
# * uploadDir
# * Diretorio da aplicacao para upload
# * @var string
# */
uploadDir=

# /**
# * versionApp 
# * Versao da aplicacao que sera submetida
# * @var string
# */
versionApp=

# /**
# * packagePath 
# * Path onde se encontra o artefato da aplicação
# * @var string
# */
packagePath=""

# /**
# * veracodeApiURI 
# * URI da API Veracode
# * @var string
# */
veracodeApiURI=""

# /**
# * usage
# * Método help do script
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
usage () {
    echo "veracode.sh version $VERSION"
    echo "Copyright (C) 2024 Serasa Experian"
    echo ""
    echo -e "veracode.sh script responsável por iniciar os processos do Veracode.\n"

    echo -e "Usage: veracode.sh --veracode-id=2585 --application-name=experian-magellan-crawler --upload-dir=/path/app1 --version-app=1.0.1 --extensao=ear
    or veracode.sh --veracode-id=2585 --application-name=experian-magellan-crawler --upload-dir=/path/app1 --version-app=1.0.1 --extensao=ear --force\n"

    echo -e "Options
    --v, --veracode-id   Id da aplicacao no veracode
    --u, --upload-dir    Diretorio da aplicacao para upload
    --e, --extensao      Extensao do arquivo para upload 
    --application-name   Nome da aplicacao 
    --application-type   Tipo da aplicacao [hadoop|INTERNET|EXTRANET|INTRANET]
    --force              Forcar criacao de veracode ignorando reports validos
    --help               Ajuda"

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

    if [ "$extensao" == "" ]; then
        errorMsg 'veracode.sh->validParameters : Extensao da aplicacao nao definida. Exemplo --extensao=jar'
        exit 1
    fi

    if [ "$appId" == "" ]; then
        errorMsg 'veracode.sh->validParameters : App ID do Veracode não definido. Exemplo: --veracode-id=12345678901'
        exit 1
    fi

    if [ "$piaasEntityId" == "0" ]; then
        errorMsg 'veracode.sh->validateParameters: ID da execução não definido. Tente novamente mais tarde.'
        exit 0
    fi

}

# /**
# * getApplicationPackage
# * Método responsável por identificar o pacote a ser enviado ao Veracode
# * @package DevOps
# * @author  Andre Arioli <andre.arioli@br.experian.com>
# */
getApplicationPackage () {
    if [ "$extensao" == "py" ]; then
        find "$uploadDir" -type f -iname "*.$extensao"| zip -q $applicationName.zip -@
        extensao="zip"
    fi

    if [ "$extensao" == "ts" ]; then
        find "$uploadDir" -type f -iname "*.js" -o -iname "*.jsx" -o -iname "*.json" -o -iname "*.ts" -o -iname "*.tsx" -o -iname "*.html"| zip -q $applicationName.zip -@
        extensao="zip"
    fi

    if [ "$extensao" == "php" ]; then
        find "$uploadDir" -type f -iname "*.php" -o -iname "*.module" -o -iname "*.inc" -o -iname "*.html" -o -iname "*.htm" -o -iname "*.profile" -o -iname "*.install" -o -iname "*.engine" -o -iname "*.theme" -o -iname "*.php4" -o -iname "*.php5" -o -iname "*.php7" -o -iname "*.phtml"| zip -q $applicationName.zip -@
        extensao="zip"
    fi

    if [ "$extensao" == "pl/sql" ]; then
        find "$uploadDir" -type f -iname "*.fnc" -o -iname "*.pck" -o -iname "*.pkb" -o -iname "*.pks" -o -iname "*.pls" -o -iname "*.prc" -o -iname "*.sql" -o -iname "*.tpb" -o -iname "*.tps" -o -iname "*.trg" -o -iname "*.vw"| zip -q $applicationName.zip -@
        extensao="zip"
    fi

    if [ "$extensao" == "flutter" ]; then
        searchPath=$(find "$uploadDir" -name "build")

        if [ "$searchPath" = "" ]; then
            errorMsg 'veracode.sh->getApplicationPackage: Para aplicações com extensão flutter, é necessário ter o build disponível na workspace.'
            exit 1
        else
            find "$uploadDir" -type f -iname "*.js" -o -iname "*.jsx"  -o -iname "*.ts" -o -iname "*.tsx" -o -iname "*.html" -o -iname "*.json" | zip -q $applicationName.zip -@
            extensao="zip"
        fi
    fi

    local fileUpload=`find ${uploadDir} -type f -iname "*.${extensao}"|grep "$applicationName"`

    if [ "$fileUpload" == "" ]; then
        errorMsg 'veracode.sh->getApplicationPackage : Arquivo .'${extensao}' para o envio nao existe em '${uploadDir}''
        exit 1
    fi

    buildName=${piaasEntityId}-${applicationName}-${versionApp}

    filePath=$(dirname "$fileUpload")
    fileName=$(basename "$fileUpload")

    mv "$filePath/$fileName" "$filePath/$buildName.$extensao"

    ls -lh "$filePath"

    packagePath="$filePath/$buildName.$extensao"
  
}

# /**
# * getApplicationPackage
# * Método responsável por realizar o upload do pacote e enviar a mensagem para a fila SQS
# * @package DevOps
# * @author  Andre Arioli <andre.arioli@br.experian.com>
# */
startProcess() {

    iamToken=`getJwtToken`
    veracodeApiURIForce=""

    if [ "$veracodeForce" == "true" ]; then
        veracodeApiURIForce="$veracodeApiURI?force=true"
    else
        veracodeApiURIForce="$veracodeApiURI?force=false"
    fi

    response=$(curl $veracodeApiURIForce \
    --insecure \
    --header 'Authorization: Bearer '${iamToken}'' \
    --form 'file=@'${packagePath}'' \
    --form 'execution_form="{\"executionId\":\"'${piaasEntityId}'\",\"applicationVersion\":\"'${versionApp}'\",\"buildName\":\"'${buildName}'\",\"buildId\":\"\",\"applicationName\":\"'${applicationName}'\",\"extensionFile\":\"'${extensao}'\",\"applicationId\":\"'${appId}'\"}"')

    if [[ "$response" =~ .*"statusReport".* ]]; then
        infoMsg 'veracode.sh->startProcess: Sucesso ao iniciar o Veracode!'
    else
        errorMsg 'veracode.sh->startProcess : Falha ao iniciar o Veracode. Veja mais detalhes abaixo.'
        echo $response
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
        -v|--veracode-id)
            case "$2" in
               "") shift 2 ;;
                *) appId=$2 ; shift 2 ;;
            esac ;;
        -u|--upload-dir)
            case "$2" in
               "") shift 2 ;;
                *) uploadDir=$2 ; shift 2 ;;
            esac ;;
        --version-app)
            case "$2" in
               "") shift 2 ;;
                *) versionApp=`echo "$2" | sed -e 's/-SNAPSHOT//;s/-RC//'`; shift 2 ;;
            esac ;;
        -e|--extensao)
            case "$2" in
               "") shift 2 ;;
                *) extensao=`echo ${2} | tr [:upper:] [:lower:]` ; shift 2 ;;
            esac ;;
        --application-name)
            case "$2" in
               "") shift 2 ;;
                *) applicationName="$2" ; shift 2 ;;
            esac ;;
        --application-type)
            case "$2" in
               "") shift 2 ;;
                *) applicationType="$2" ; shift 2 ;;
            esac ;;
        --piaas-entity-id)
            case "$2" in
               "") shift 2 ;;
                *) piaasEntityId="$2" ; shift 2 ;;
            esac ;;
        --force)
            case "$2" in
               "") veracodeForce='true' ; shift 2;;
                *) veracodeForce='true' ; shift 2;;
            esac ;;
        --help) usage ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

if [ "$piaasEnv" == "prod" ]; then
    veracodeApiURI="https://piaas-veracode-api-prod.devsecops-paas-prd.br.experian.eeca/piaas-veracode/v1/executions"
else
    veracodeApiURI="https://piaas-veracode-api-sand.sandbox-devsecops-paas.br.experian.eeca/piaas-veracode/v1/executions"
fi

validateParameters
getApplicationPackage
startProcess