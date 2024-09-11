#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           brunoApi.sh
# * @version        1.0.0
# * @description    Realiza testes e validações com brunoApi
# * @copyright      2024 &copy Serasa Experian
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
TEMP=`getopt -o tuemirwj::h --long workspace::,environment::,image:: -n "$0" -- "$@"`
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
environment=''
 
# /**
# * brunoApiTests
# * Método inicia os testes e realiza validações para atribuição de score
# * @package DevOps
# */
brunoApiTests() {

    ##Cria arquivo de config para Bruno Api reconhecer raiz da collection
    echo '{ "version": "1", "name": "'$environment'", "type": "collection" }' > $workspace/bruno.json
    
    getOutputTest=$(docker run --rm -v $workspace:/app -e ENVIRONMENT=$environment -e https_proxy= $image)
 
    if [ $? -eq 1 ]; then
        errorMsg 'brunoApi.sh->brunoApiTests: Ocorreu um erro ao realizar os testes com bruno-api. Não são permitidos testes com falhas.'
        echo ""
        getOutputTestFinal=$(echo "$getOutputTest" | sed '/^    at/d')
        echo "$getOutputTestFinal"
        exit 1
    else
        echo "$getOutputTest"
    fi
}
 

# Extrai opcoes passadas
while true ; do
    case "$1" in
        --workspace)
            case "$2" in
               "") shift 2 ;;
                *) workspace="$2" ; shift 2 ;;
            esac ;;
        --image)
            case "$2" in
               "") shift 2 ;;
                *) image="$2" ; shift 2 ;;
            esac ;;
        --environment)
            case "$2" in
               "") shift 2 ;;
                *) environment="$2" ; shift 2 ;;
            esac ;;
        -h|--help) usage ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

brunoApiTests