#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           dockerBuildZLinux.sh
# * @version        $VERSION
# * @description    Script que faz o build de conteiner no zlinux
# * @copyright      2020 &copy Serasa Experian
# *
# * @version        1.0.0
# * @change         Script que faz o build de conteiner no zlinux
# * @copyright      2020 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @dependencies   
# * @date           30-Jun-2020
# *
# * @version        1.1.0
# * @change         Incluindo possibilidade de passar o workspace
# * @copyright      2020 &copy Serasa Experian
# * @author         Daniel Miyamoto <Daniel.Miyamoto@br.experian.com>
# * @dependencies   
# * @date           16-Nov-2020
# *
# * @version        1.1.0
# * @change         Incluindo possibilidade de passar tags
# * @copyright      2020 &copy Serasa Experian
# * @author         Daniel Miyamoto <Daniel.Miyamoto@br.experian.com>
# * @dependencies   
# * @date           30-Nov-2020
# **/

# /**
# * Configurações iniciais
# */

# Exit on errors
#set -eu # Liga Debug

# Diretorio base
baseDir="/opt/infratransac/core"

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
TEMP=`getopt -o h --long container-layer::,application-name::,version::,url-package::,help::,workspace::,tags:: -n "$0" -- "$@"`
eval set -- "$TEMP"

# /**
# * containerLayer
# * Define o layer da image
# * @var string
# */
containerLayer=""

# /**
# * application
# * Define a aplicação
# * @var string
# */
application=""

# /**
# * versionApplication
# * Define a versão da aplicação
# * @var string
# */
versionApplication=""

# /**
# * urlPackage
# * Url do pacote 
# * @var string
# */
urlPackage=""

# /**
# * pathTemplate
# * Define path do template
# * @var string
# */
pathTemplate=$(mktemp -d)


# /**
# * set do proxy
# */
export http_proxy="http://10.96.215.26:3128"
export https_proxy="http://10.96.215.26:3128"


# /**
# * usage
# * Método help do script
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <Joao.Leite2@br.experian.com>
# */
usage () {
    echo "dockerBuildZLinux.sh version $VERSION - by DevSecOps COE Team"
    echo "Copyright (C) 2020 Serasa Experian"
    echo ""
    echo -e "dockerBuildZLinux.sh script que faz o build de conteiner no zlinux.\n"

    echo -e "Usage: dockerBuildZLinux.sh --container-layer=go --application-name=go-demo --version=1.0.0-SNAPSHOT\n"
    echo -e "dockerBuildZLinux.sh --workspace=/tmp/tmp.123456.tar.gz --application-name=go-demo --version=1.0.0-SNAPSHOT\n"
    echo -e "dockerBuildZLinux.sh --workspace=/tmp/tmp.123456.tar.gz --application-name=go-demo --version=1.0.0-SNAPSHOT --tags='1-SNAPSHOT latest'\n"
    
    echo -e "Options
    --container-layer     Define o layer da image a ser usada
    --application-name    Aplicacao 
    --version             Versao da aplicacao
    --url-package         Url do pacote
    --workspace           Caminho do workspace
    --tags                Tags adicionais da imagem
    --h, --help           Ajuda"

    exit 1
}

# /**
# * validateParameters
# * Método que valida parametros
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <Joao.Leite2@br.experian.com>
# */
validateParameters () {
    if [ "$workspace" != "" ]; then
        echo "dockerBuildZLinux.sh->validateParameters : Workspace definido $workspace"
    fi

    if [ "$containerLayer" != "" ]; then 
        echo "dockerBuildZLinux.sh->validateParameters : Container layer definido $containerLayer"
    elif [ "$workspace" = "" ]; then
        echo "dockerBuildZLinux.sh->validateParameters : --container-layer nao definido, impossivel prosseguir"
        exit 1
    fi

    if [ "$application" == "" ]; then 
        echo "dockerBuildZLinux.sh->validateParameters : --application-name nao definido, impossivel prosseguir"
        exit 1
    else
        echo "dockerBuildZLinux.sh->validateParameters : Aplicacao definida $application"
    fi

    if [ "$versionApplication" == "" ]; then 
        echo "dockerBuildZLinux.sh->validateParameters : --version nao definida, impossivel prosseguir"
        exit 1
    else
        echo "dockerBuildZLinux.sh->validateParameters : Versao definida $versionApplication"
    fi

    if [ "$urlPackage" != "" ]; then 
        echo "dockerBuildZLinux.sh->validateParameters : Url do pacote definida $urlPackage"
    elif [ "$workspace" = "" ]; then
        echo "dockerBuildZLinux.sh->validateParameters : --url-package nao definido, impossivel prosseguir"
        exit 1
    fi

    if [ "$tags" != "" ]; then
       echo "dockerBuildzLinux.sh->validateParameters : Tags $tags"
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
        --container-layer)
            case "$2" in
               "") shift 2 ;;
                *) containerLayer="$2" ; shift 2 ;;
            esac ;;
        --application-name)
            case "$2" in
               "") shift 2 ;;
                *) application="$2" ; shift 2 ;;
            esac ;;
        --version)
            case "$2" in
               "") shift 2 ;;
                *) versionApplication="$2" ; shift 2 ;;
            esac ;;
        --url-package)
            case "$2" in
               "") shift 2 ;;
                *) urlPackage="$2" ; shift 2 ;;
            esac ;;
        --workspace)
            case "$2" in
               "") shift 2 ;;
                *) workspace="$2" ; shift 2 ;;
            esac ;;
        --tags)
            case "$2" in
               "") shift 2 ;;
                *) tags="$2" ; shift 2 ;;
            esac ;;
        -h|--help) usage ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

validateParameters

if [ "$workspace" != "" ]; then
    echo "dockerBuildZLinux.sh: Descompactando workspace $workspace"
    tar -zxvf $workspace -C $pathTemplate
    rm $workspace
fi


if [ "$containerLayer" != "" ]; then
    echo "dockerBuildZLinux.sh : Copiando layer $containerLayer em $pathTemplate"
    if ! cp $baseDir/conf/dockerfile-layer-zlinux/$containerLayer/* $pathTemplate/; then
        echo "dockerBuildZLinux.sh : Copia do layer falhou, impossivel prosseguir"
        rm -rf $pathTemplate
        exit 1
    fi
    echo "dockerBuildZLinux.sh : Detalhes do layer"
fi

cd $pathTemplate
ls -lt 
cat Dockerfile
echo ""

if [ "$urlPackage" != "" ]; then 
    echo "dockerBuildZLinux.sh : Baixando pacote $urlPackage"
    wget $urlPackage
    ls -lt
    nomePacote=$(ls -A |grep $application)
fi

echo "dockerBuildZLinux.sh : Realizando o build do Dockerfile"
if [ "$nomePacote" != "" ]; then 
    echo "dockerBuildZLinux.sh : Pacote $nomePacote para build"
    if ! docker build -t="$application:$versionApplication" --build-arg NOME_PACOTE=$nomePacote .; then
        echo "dockerBuildZLinux.sh : Build falhou, impossivel prosseguir"
        cd /tmp ; rm -rf $pathTemplate
        exit 1
    fi
else
    if ! docker build -t="$application:$versionApplication" .; then
        echo "dockerBuildZLinux.sh : Build do falhou, impossivel prosseguir"
        cd /tmp ; rm -rf $pathTemplate
        exit 1
    fi
fi

echo "dockerBuildZLinux.sh : Aplicando tags"
if [ "$tags" != "" ]; then
    #Recupera ID da tag gerada no step anterior
    tag_id=$(docker image ls "$application:$versionApplication" --format='{{.ID}}')
    echo "dockerBuildZLinux.sh : ID da tag: $tag_id"

    for tag in $tags; do
        echo "dockerBuildZLinux.sh : Aplicando tag $tag"
        docker tag $tag_id "$application:$tag" 
    done
fi

echo "dockerBuildZLinux.sh : Build realizado com sucesso para $application:$versionApplication"
docker images | grep $application | grep $versionApplication

echo "dockerBuildZLinux.sh : Limpando lixos gerados para o build"
cd /tmp ; rm -rf $pathTemplate

echo "ZLinux na veia :)"

unset http_proxy
unset https_proxy