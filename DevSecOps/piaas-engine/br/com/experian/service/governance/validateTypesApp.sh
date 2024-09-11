#!/bin/bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           validateTypesApp.sh
# * @version        1.3.0
# * @description    Validador de tipos de aplicação no piaas.
# * @copyright      2023 &copy Serasa Experian
# *
# * @version        1.3.0
# * @change         - [FEATURE] Implementação e validação de tipo self-learning;
# * @contribution   Pedro H. Fagundes <pedrohenrique.fagundes@br.experian.com> 
# * @dependencies   common.sh
# * @date           03-Out-2023
# *
# * @version        1.2.0
# * @change         - [FEATURE] Implementação de tipo sqlserver;
# *                 - [FIX] Remoção de tipo config-nike-reports para configs-arquitetura-de-dados;
# * @contribution   João Leite <joao.leite2@br.experian.com> 
# * @dependencies   common.sh
# * @date           07-Jul-2023
# *
# * @version        1.1.1
# * @change         - Implementar validação para o tipo helm;
# * @contribution   Pedro H. Fagundes <pedrohenrique.fagundes@br.experian.com> e Paulo Ricassio <pauloricassio.dossantos@br.experian.com>
# * @dependencies   common.sh
# * @date           27-Abr-2023
# *
# * @version        1.1.0
# * @change         - [ FIX ] Ajustes do filtro para tipo validateConfigNikeReports();
# *                 - [ FIX ] Mostrar arquivos que violaram a regra;
# * @contribution   Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# * @dependencies   common.sh
# * @date           28-Mar-2023
# *
# *
# * @version        1.0.0
# * @change         - [ ADD ] Validador de tipos de aplicação no piaas;
# * @contribution   Andre Carvalho <andre.carvalho@br.experian.com>
# * @dependencies   common.sh
# * @date           01-Mar-2023
# **/

# Diretorio base
baseDir="/opt/infratransac/core"

# Carrega commons
test -e "$baseDir"/br/com/experian/utils/common.sh || echo 'Ops, biblioteca common nao encontrada'
source "$baseDir"/br/com/experian/utils/common.sh

# /**
# * typeApplication
# * Tipo de aplicação
# * @var string
# */
typeApplication=''

# /**
# * workspace
# * Diretorio de trabalho
# * @var string
# */
workspace=''

# /**
# * TEMP
# * Leitura de opções
# * @var string
# */
TEMP=$(getopt -o tuemirwj::h --long type-application::,workspace:: -n "$0" -- "$@")
eval set -- "$TEMP"


# Validate Apache Camel. Check if directory contains only yml/yaml/md files
validateApacheCamel() {

    workspaceFiles=$(find $workspace -type f | grep -v .git)
    declare -a aux=()
    i=0

    for files in $workspaceFiles; do
        if [[ ! $files =~ [a-zA-Z0-9].(yml|yaml|md|conf|properties|png|xml|sh) ]]; then
            aux[$i]=$files
            echo "Oops, we found irregular files: $files"
        fi
        ((i++))
    done

    if [[ ${#aux[@]} -eq 0 ]]; then
        echo "100"
    else
        echo "0"
    fi
}

# Validate Helm
validateHelm() {
    # Verifica se o interpretador de comando é um shell válido
    extensoes_permitidas=(sh yaml yml conf md graphql cer)
    arquivos_permitidos=(Dockerfile)
    interpretadores_permitidos=(bash sh zsh ksh csh)
    workspaceFiles==$(find $workspace -type f | grep -v .git)
    declare -a aux=()

    for files in $workspaceFiles; do
        if [[ -f $files ]]; then
            if [[ ! " ${arquivos_permitidos[@]} " =~ " ${files##*/} " ]]; then
                if [[ ! " ${extensoes_permitidas[@]} " =~ " ${files##*.} " ]]; then
                    aux[$i]=$files
                    echo "ERRO: O arquivo $files nao possui uma extensao permitida."
                    echo "Extensoes permitidas: .sh, .yaml, .yml, .conf, .md, .cer e .graphql."
                    exit 1
                fi
  
                if [[ ${files##*.} == "sh" ]]; then
                    first_line=$(head -n 1 "$files")
                    if ! echo "$first_line" | grep -qE '^#!\s*/.*\b(bash|sh|zsh|ksh|csh)\b'; then
                        aux[$i]=$first_line
                        echo "ERRO: o arquivo $files nao possui um interpretador de comando valido."
                        echo "Interpretadores válidos: bash, sh, zsh, ksh, csh."
                        exit 1
                    fi
                fi
            fi
        fi
        ((i++))
    done

    comandos_liberados=("aws eks update-kubeconfig" "helm upgrade" "echo" "exit" "export" "docker" "unset" "rm" "kubectl")

    sh_files=$(find $workspace -type f -name "*.sh")
    comandos_proibidos_encontrados=0

    for files in $sh_files; do
        lista_comandos=()
        while read -r line; do
            if [[ "$line" =~ ^[[:space:]]*$ ]]; then continue; fi # Ignora linhas em branco e espaços
            if [[ "$line" =~ ^[[:space:]]*# ]]; then continue; fi # Ignora linhas de comentário
            if [[ "$line" =~ ^[[:space:]]*function[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*\(\) ]]; then continue; fi # Ignora linhas com definição de função
            if [[ "$line" =~ ^[[:space:]]*\$ ]]; then continue; fi # Ignora linhas que começam com "$"
            if [[ "$line" =~ ^[[:space:]]*[^[:space:]]+= ]]; then continue; fi # Ignora linhas de definição de variáveis
            if [[ "$line" =~ ^[[:space:]]*(for|if|fi|then|else|done|while|break|elif|do) ]]; then continue; fi # Ignora linhas com palavras-chave

            command=$(echo "$line" | awk '{print $1}')
            if ! echo "${comandos_liberados[@]}" | grep -qw "$command"; then
                lista_comandos+=("$command")
            fi
        done < "$files"

        if [ ${#lista_comandos[@]} -gt 0 ]; then
            comandos_proibidos_encontrados=1
            aux[$i]=$lista_comandos
            echo "ERRO: Os seguintes comando(s) nao permitidos foram encontrados em $files: ${lista_comandos[*]}"
            echo "Comandos permitidos: "aws eks update-kubeconfig", "helm upgrade", "echo", "exit", "export", "docker", "unset", "rm", "kubectl"."
            exit 1
        fi
        ((i++))
    done

    echo "100"
  
}

# Validate Config Arquitetura Dados. Check if directory contains only json/cql/sql/md/yml files
validateConfigArquiteturaDados() {

    workspaceFiles=$(find $workspace -type f | grep -v .git)
    declare -a aux=()
    i=0
    for files in $workspaceFiles; do
        if [[ ! $files =~ [a-zA-Z0-9].(cql|sql|yaml|yml|md|json|conf|png|xml|csv|xls|xlsx|sh|properties) ]]; then
            aux[$i]=$files
            echo "Oops, we found irregular files: $files"
        fi
        ((i++))
    done

    if [[ ${#aux[@]} -eq 0 ]]; then
        echo "100"
    else
        echo "0"
    fi
}

# Validate sqlserver. Check if directory contains only sql/md/yaml/yml/conf files
validateSqlServer() {

    workspaceFiles=$(find $workspace -type f | grep -v .git)
    declare -a aux=()
    i=0
    for files in $workspaceFiles; do
        if [[ ! $files =~ [a-zA-Z0-9].(sql|yaml|yml|md|conf) ]]; then
            aux[$i]=$files
            echo "Oops, we found irregular files: $files"
        fi
        ((i++))
    done

    if [[ ${#aux[@]} -eq 0 ]]; then
        echo "100"
    else
        echo "0"
    fi
}

# Validate Self-learning. Check if directory contains only yml/yaml/md/txt/png/pdf/ppt files
validateSelfLearning() {

    workspaceFiles=$(find $workspace -type f | grep -v .git)
    declare -a aux=()
    i=0

    for files in $workspaceFiles; do
        if [[ ! $files =~ [a-zA-Z0-9].(yml|yaml|md|conf|png|txt|pdf|ppt|iml|xml|drawio|jpg|zip|gif|PNG|xlsx|json) ]]; then
            aux[$i]=$files
            echo "Oops, we found irregular files: $files"
        fi
        ((i++))
    done

    if [[ ${#aux[@]} -eq 0 ]]; then
        echo "100"
    else
        echo "0"
    fi
}


validateEidConfig () {
    workspaceFiles=$(find $workspace -type f | grep -v .git)
    declare -a aux=()
    i=0

    for files in $workspaceFiles; do
        if [[ ! $files =~ [a-zA-Z0-9].(yml|yaml|md|conf|png|txt|pdf|ppt|nginx|template) ]]; then
            aux[$i]=$files
            echo "Oops, we found irregular files: $files"
        fi
        ((i++))
    done

    if [[ ${#aux[@]} -eq 0 ]]; then
        echo "100"
    else
        echo "0"
    fi
}

validateServerless() {
    jenkinsYml=$(cat piaas.yml | yq '.master.deploy')

    if [[ $jenkinsYml == *"aws"* && $jenkinsYml == *"--method=lambda"* ]]; then
        echo "100"
    else
        echo "0"
    fi

}

validateDevopsTool() {

    assignmentGroup=$(cat piaas.yml | yq '.team.assignment_group')
    group="DevSecOps PaaS Brazil"

    if [[ "${group,,}" == "${assignmentGroup,,}" ]]; then
        echo "100"
    else
        echo "0"
    fi

}


main() {
    case "$typeApplication" in
    "configs-arquitetura-de-dados")
        validateConfigArquiteturaDados
        ;;
    "apache-camel")
        validateApacheCamel
        ;;
    "helm")
        validateHelm
        ;;
    "sqlserver")
        validateSqlServer
        ;;
    "self-learning")
        validateSelfLearning
        ;;
    "eid-config")
        validateEidConfig
        ;;
    "serverless")
        validateServerless
        ;;
    "devops-tool")
        validateDevopsTool
        ;;
    *)
        errorMsg "Tipo de aplicação inválido: $typeApplication"
        exit 1
        ;;
    esac
}

# Extrai opções passadas
while true; do
    case "$1" in
    --type-application)
        case "$2" in
        "") shift 2 ;;
        *)
            typeApplication="$2"
            shift 2
            ;;
        esac
        ;;
    --workspace)
        case "$2" in
        "") shift 2 ;;
        *)
            workspace="$2"
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
        echo 0
        ;;
    esac
done

main
