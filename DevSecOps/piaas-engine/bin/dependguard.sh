#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           dependguard.sh
# * @version        $VERSION
# * @description    Script que interage com testes de carga
# * @copyright      2023 &copy Serasa Experian
# *
# *
# * @version        1.0.0
# * @change         [ADD] Script que executa testes de carga
# * @copyright      2023 & copy Serasa Experian
# * @author         Lucas Francoi <lucas.francoi@br.experian.com>
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
TEMP=$(getopt -o h --long help::,repository::,base_branch::,log_level:,image:: -n "$0" -- "$@")
eval set -- "$TEMP"

# /**
# * BITBUCKET_TOKEN 
# * Token para comunicacao com Bitbucket
# * @var string
# */
bitbucket_token=''

# /**
# * image
# * image de build
# * @var string
# */
image=''

# /**
# * BITBUCKET_TOKEN 
# * Token para comunicacao com Bitbucket
# * @var string
# */
nexus_token=''

# /**
# * REPOSITORY
# * Repositorio a ser escaneado
# * @var string
# */
repository=''

# /**
# * BASE_BRANCH
# * Branch a ser escaneada e efetuaro a Pull Request
# * @var string
# */
base_branch=''

# /**
# * LOG_LEVEL
# * Log Level Renovate(info, debug, warn, error, silent, trace)
# * @var string
# */
log_level='info'

# /**
# * usage
# * Método help do script
# * @version $VERSION
# * @package DevOps
# * @author  Lucas Francoi <lucas.francoi@br.experian.com>
# */

usage () {
    echo "dependguard.sh version $VERSION - by SRE Team"
    echo "Copyright (C) 2024 Serasa Experian"
    echo ""
    echo -e "dependguard.sh script que executa teste de carga com dependguard.\n"

    echo -e "Usage: dependguard.sh --repository=EDVP/piaas-itil-api --base_branch=feature/EDPB-1251 --image --log_level=debug \n"

    echo -e "Options
    --repository              Repositorio a ser escaneado
    --base_branch             Branch a ser escaneada e gerado a Pull Request
    --log_level               Nivel de log da execucao
    --image                   Imagem que sera utilizada pelo binario"

    exit 1
}


run_dependguard() {
    
    infoMsg 'dependguard.sh->dependenciesAnalysis : Inicializando checagem de dependencias mais novas para repositorio '${repository}' na branch '${base_branch}'' 

    # Resgatando credenciais no Cyberark Dap
    if ! credentialsBitbucket=$(cyberArkDap --safe BR_PAPP_EITS_DSECOPS_STATIC -c "usr_ci_integra_bitbucket_token"); then
        warnMsg 'dependguard.sh->dependenciesAnalysis: Erro ao resgatar as credenciais do Bitbucket'
        exit 1
    fi

    if ! credentialsNexus=$(cyberArkDap --safe BR_PAPP_EITS_DSECOPS_STATIC -c "nexus admin"); then
       warnMsg 'dependguard.sh->dependenciesAnalysis: Erro ao resgatar as credenciais do Nexus.'
       exit 1
    fi
    
    bitbucket_token=$(echo $credentialsBitbucket | jq -r '.password')
    nexus_token=$(echo $credentialsNexus | jq -r '.password')


    # bitbucket_token=`getCredentialsToken usr_ci_integra_bitbucket_token`
    # nexus_token=`getCredentialsToken "nexus admin"`
    
    # Valida se as variaveis e arquivo de configuracao estao vazios

    if [[ -z "$bitbucket_token" ]]; then
        errorMsg "BITBUCKET_TOKEN is required."
        return 1
    fi

    if [[ -z "$nexus_token" ]]; then
        errorMsg "NEXUS_TOKEN is required."
        return 1
    fi

    if [[ -z "$repository" ]]; then
        errorMsg "REPOSITORY is required."
        return 1
    fi

    if [[ -z "$base_branch" ]]; then
        errorMsg "BASE_BRANCH is required."
        return 1
    fi

        docker run --rm   -e BITBUCKET_TOKEN="$bitbucket_token" \
                          -e NEXUS_TOKEN="$nexus_token" \
                          -e REPOSITORY="$repository" \
                          -e BASE_BRANCH="$base_branch" \
                          -e LOG_LEVEL="$log_level" \
                          $image

# Verifica a saida do comando Docker
if [ $? -eq 0 ]; then
   infoMsg "DependGuard executado com sucesso!"
else
  errorMsg "Ocorreu um erro na execucao do DependGuard!! $?."
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

# Extrai opcoes passadas
while true ; do
    case "$1" in
        --repository)
            case "$2" in
               "") shift 2 ;;
                *) repository="$2" ; shift 2 ;;
            esac ;;
        --base_branch)
            case "$2" in
               "") shift 2 ;;
                *) base_branch="$2" ; shift 2 ;;
            esac ;;
        --log_level)
            case "$2" in
               "") shift 2 ;;
                *) log_level="$2" ; shift 2 ;;
            esac ;;
        --image)
            case "$2" in
               "") shift 2 ;;
                *) image="$2" ; shift 2 ;;
            esac ;;
        -h|--help) usage ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
        esac
done

run_dependguard