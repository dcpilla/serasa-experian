#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           docker.sh
# * @version        1.0.0
# * @description    Compilador para realizar builds docker com scan do Wiz
# * @copyright      2022 &copy Serasa Experian
# *
# **/

# Diretorio base
baseDir="/opt/infratransac/core"

# Carrega commons
test -e "$baseDir"/br/com/experian/utils/common.sh || echo 'Ops, biblioteca common nao encontrada'
source "$baseDir"/br/com/experian/utils/common.sh

# /**
# * dockerTag
# * TAG docker
# * @var string
# */
dockerTag=''

# /**
# * wizCli
# * CI/CD Policies
# * @var string
# */
wizPolicy='DevSecOpsBR_vuln_os_app_policy_EPSS'

# /**
# * applicationName
# * Nome da aplicacao
# * @var string
# */
applicationName=''

# /**
# * fileName
# * Nome do arquivo Dockerfile, default da raiz
# * @var string
# */
fileName=''

# /**
# * dir
# * Path de build da aplicação
# * @var string
# */
dir=''

# /**
# * environment
# * environment da aplicação
# * @var string
# */
environment=''

# /**
# * buildType
# * Tipo de build (relase ou profile)
# * @var string
# */
buildType=''

# /**
# * customizedBuild
# * Exec Build compilationCmd
# * @var string
# */
customizedBuild=''

# /**
# * TEMP
# * Leitura de opcoes
# * @var string
# */
TEMP=$(getopt -o tuemirwj::h --long application-name::,docker-tag::,file-name::,dir::,environment::,customized-build:: -n "$0" -- "$@")
eval set -- "$TEMP"

dockerBuild() {

    local cmdBuild=''
    infoMsg 'docker.sh->dockerBuild: Iniciando build da imagem Docker'

    if [ "$fileName" == "" ]; then
        cmdBuild="docker build --build-arg BUILD_TYPE=$buildType -t $applicationName:$dockerTag ."
    else
        cmdBuild="docker build --build-arg BUILD_TYPE=$buildType -t $applicationName:$dockerTag -f $fileName ."
    fi

    infoMsg "docker.sh->dockerBuild: Command for build: $cmdBuild"

    if ! $cmdBuild; then
        warnMsg 'docker.sh->dockerBuild: Erro ao realizar dockerBuild da imagem.'
        exit 1
    fi

    wizAuth
    wizScanner
}

dockerBuildCustomized() {

    local cmdBuild=''
    infoMsg 'docker.sh->dockerBuildCustomized: Iniciando build da imagem customizada do Docker'

    if [[ "$customizedBuild" == *"docker build"* && "$customizedBuild" == *'-t="'* ]]; then
        applicationName=$(echo "$customizedBuild" | awk -F'-t="' '{print $2}' | awk -F'"' '{print $1}' | awk -F':' '{print $1}')
        dockerTag=$(echo "$customizedBuild" | awk -F'-t="' '{print $2}' | awk -F'"' '{print $1}' | awk -F':' '{print $2}')
        cmdBuild=$(echo "$customizedBuild" | sed 's/-t="\(.*\)"/-t=\1/')
    elif [[ "$customizedBuild" == *"docker build"* && "$customizedBuild" == *"-t="* ]]; then
        applicationName=$(echo "$customizedBuild" | awk -F'-t=' '{print $2}' | awk -F' ' '{print $1}' | awk -F':' '{print $1}')
        dockerTag=$(echo "$customizedBuild" | awk -F'-t=' '{print $2}' | awk -F' ' '{print $1}' | awk -F':' '{print $2}')
        cmdBuild=$(echo "$customizedBuild" | sed 's/-t="\(.*\)"/-t=\1/')
    else
        applicationName=$(echo "$customizedBuild" | awk -F'-t ' '{print $2}' | awk -F':' '{print $1}')
        dockerTag=$(echo "$customizedBuild" | awk -F'-t ' '{print $2}' | awk -F':' '{print $2}' | awk -F' ' '{print $1}')
        cmdBuild=$(echo "$customizedBuild" | sed 's/-t="\(.*\)"/-t=\1/')
    fi

    infoMsg "docker.sh->dockerBuildCustomized: Command for build: $cmdBuild"

    if ! $cmdBuild; then
        warnMsg 'docker.sh->dockerBuildCustomized: Erro ao realizar dockerBuild da imagem.'
        exit 1
    fi

    wizAuth
    wizScanner
}

wizScanner() {
    local wizResult=''
    local pkg_vulns=''
    local cveName=''
    local suggestionToPipeline=''
    local pipelineCve=''
    local riskStratification=''
    local flagWizCheck='false'
    local patchable=''
    local scanResult=''
    local flagBlockTribe=0
    local api_response=''

    infoMsg 'docker.sh->wizScanner: Iniciando scan da imagem Docker'

    wizResult=$(wizcli docker scan --show-vulnerability-details --image $applicationName:$dockerTag --tag shiftleft=eks-latam --policy $wizPolicy --format json)

    if [ "$wizResult" == "" ]; then
        warnMsg "docker.sh->wizScanner: Erro na integracao com wiz.io"
        exit 148
    fi

    # Extrair infos do json que serão utilizadas no while
    pkg_vulns=$(echo "$wizResult" | jq -c '.result.osPackages[]? | {name: .name, vulnerabilities: .vulnerabilities[]}')
    cveName=$(echo "$pkg_vulns" | jq -r '.vulnerabilities.name' | sort -u)

    # Valida osPackages é valido e se o valor é null
    if [ -z "$pkg_vulns" ] || [ "$pkg_vulns" == "null" ]; then
        infoMsg 'docker.sh->wizScanner: Não foram encontradas vulnerabilidades em seu ambiente de contêiner \o/'
        exit 0
    fi

    # Processamento das informações em lote e validações de status da api
    max_cves=100
    cve_array=(${cveName//\n/ })
    num_cves=${#cve_array[@]}
    max_attempts=3

    for ((attempt = 1; attempt <= max_attempts; attempt++)); do
        for ((i = 0; i < num_cves; i += max_cves)); do
            cve_subset=("${cve_array[@]:i:max_cves}")
            cve_query=$(printf "\"%s\"," "${cve_subset[@]}")
            cve_query=${cve_query%,}
            response_part=$(curl -k -s -X 'POST' 'https://devsecops-vulnerability-api-prod.devsecops-paas-prd.br.experian.eeca/devsecops-vulnerability/v1/vulnerabilities' -H 'accept: */*' -H 'Content-Type: application/json' -d [$cve_query] | jq -r '.[]')
            api_response="$api_response $response_part"
        done
        # Validação na integração com a api
        if [ -z "$api_response" ]; then
            if [ "$attempt" -eq "$max_attempts" ]; then
                echo "docker.sh->wizScanner: Erro na integracao com a api"
                exit 148
            else
                echo "docker.sh->wizScanner: Tentando conexão com a api $attempt."
                sleep 5
                api_response=''
            fi
        else
            echo "docker.sh->wizScanner: Conectado com sucesso na tentativa $attempt."
            break
        fi
    done

    # Count dos cves retornados pela api
    totalCves=$(echo "$api_response" | grep -c '"cve"')
    blockedCves=$(echo "$api_response" | grep -o "Blocked" | wc -l)
    passedCves=$(echo "$api_response" | grep -o "Passed" | wc -l)

    # Iteração sobre cves que retornaram blocked e aplicação da regra de negócio
    while read -r blocked; do
        suggestionToPipeline=$(echo "$blocked" | jq -r '.suggestionToPipeline')
        pipelineCve=$(echo "$blocked" | jq -r '.cve')
        riskStratification=$(echo "$blocked" | jq -r '.riskStratification')
        patchable=$(echo "$pkg_vulns" | jq -r --arg pipelineCve "$pipelineCve" '.vulnerabilities | select(.name == $pipelineCve) | .fixedVersion')
        scanResult=$(echo "$pkg_vulns" | jq -r --arg pipelineCve "$pipelineCve" '.vulnerabilities | select(.name == $pipelineCve) | .description')
        if [ ! -z "$pipelineCve" ]; then
            flagWizCheck=true
            echo
            echo "Name: $pipelineCve"
            echo "Risk Stratification: $riskStratification"
            echo "Patchable: $patchable"
            echo "Scan result: $scanResult"
            echo
        fi
    done <<<"$(echo "$api_response" | jq -c 'select(.suggestionToPipeline == "Blocked")')"
    
    # Print dos contadores
    infoMsg "docker.sh->wizScanner: Total: $totalCves, Total Blocked: $blockedCves, Total Passed: $passedCves"

    # Check e log status
    if [ "$flagWizCheck" == "false" ]; then
        infoMsg 'docker.sh->wizScanner: Não foram encontradas vulnerabilidades em seu ambiente de contêiner'
        exit 0
    else
        warnMsg 'docker.sh->wizScanner: Foram encontradas vulnerabilidades de contêiner em seu ambiente, corrija ou procure nossos colegas de GSO !'
        exit 99
    fi
}

wizAuth() {

    if ! wizAuth=$(cyberArkDap --safe BR_PAPP_EITS_DSECOPS_STATIC -c "WIZ Service Account"); then
        warnMsg 'docker.sh->wizAuth: Erro ao se autenticar no CyberArk para Wiz. Ignorando scan.'
        exit 0
    fi

    wizUser=$(echo $wizAuth | jq -r '.username')
    wizPass=$(echo $wizAuth | jq -r '.password')

    if ! wizcli auth --id "$wizUser" --secret "$wizPass"; then
        warnMsg 'docker.sh->wizAuth: Erro ao se autenticar no Wiz. Ignorando scan.'
        exit 0
    fi

}

dockerExtract() {

    infoMsg "docker.sh->dockerExtract: Extraindo conteúdo do diretório $dir do container Docker para dentro do Workspace..."

    docker create --name $applicationName "$applicationName:$dockerTag"
    docker cp $applicationName:$dir WORKSPACE
    docker rm $applicationName

    infoMsg "docker.sh->dockerExtract: Extração concluída com sucesso!"
}

# Extrai opcoes passadas
while true; do
    case "$1" in
    --application-name)
        case "$2" in
        "") shift 2 ;;
        *)
            applicationName="$2"
            shift 2
            ;;
        esac
        ;;
    --docker-tag)
        case "$2" in
        "") shift 2 ;;
        *)
            dockerTag="$2"
            shift 2
            ;;
        esac
        ;;
    --file-name)
        case "$2" in
        "") shift 2 ;;
        *)
            fileName="$2"
            shift 2
            ;;
        esac
        ;;
    --dir)
        case "$2" in
        "") shift 2 ;;
        *)
            dir="$2"
            shift 2
            ;;
        esac
        ;;
    --environment)
        case "$2" in
        "") shift 2 ;;
        *)
            environment="$2"
            shift 2
            ;;
        esac
        ;;
    --customized-build)
        case "$2" in
        "") shift 2 ;;
        *)
            customizedBuild="$2"
            shift 2
            ;;
        esac
        ;;
    -h | --help) usage ;;
    --)
        shift
        break
        ;;
    *)
        echo "Internal error!"
        exit 1
        ;;
    esac
done

if [ "$environment" == "master" ]; then
    buildType="release"
else
    buildType="profile"
fi

if [ "$customizedBuild" != "" ]; then
    dockerBuildCustomized
else
    dockerBuild
fi

if [ "$dir" != "" ]; then
    dockerExtract
fi
