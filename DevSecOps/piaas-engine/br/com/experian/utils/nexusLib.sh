#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian 
# *
# * @package        DevOps
# * @name           nexusLib.sh
# * @version        2.2.0
# * @description    Biblioteca com as chamadas para manipulação do nexus
# * @copyright      2017 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# * @date           12-Out-2017
# *
# **/  

# /**
# * Configurações iniciais
# */

# Exit se erros 
#set -eu   # Liga Debug

# Diretorio base 
baseDir="/opt/infratransac/core"

# Carrega commons 
test -e "$baseDir"/br/com/experian/utils/common.sh || echo 'Ops, biblioteca common nao encontrada'
source "$baseDir"/br/com/experian/utils/common.sh

# /**
# * Variaveis
# */


# /**
# * Funções
# */

# /**
# * getInfoPackage
# * Método que pega informações do pacote no nexus
# * @version 2.2.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   $1 - typeInfo
# *          $2 - urlQuery
# * @return  $resp 
# */
getInfoPackage (){
    typeInfo=""
    urlQuery=""

    test ! -z "$1" || errorMsg 'nexusLib.sh->getInfoPackage : Tipo de infomacao nao informada'
    test ! -z "$2" || errorMsg 'nexusLib.sh->getInfoPackage : Url do pacote para consulta nao informado'
    typeInfo="$1"
    urlQuery="$2"
    
    case $typeInfo in
        statusPackage)
            resp=$(curl -k -I "$urlQuery"|grep 'HTTP'|cut -f2 -d" ")
            echo $resp
        ;;
        lastCommitDate)  
            dia=""
            mes=""
            ano=""
            resp=""

            ano=$(curl -k -I "$urlQuery"|grep 'Last-Modified:'|cut -f5 -d" ")
            mes=$(curl -k -I "$urlQuery"|grep 'Last-Modified:'|cut -f4 -d" ")
            dia=$(curl -k -I "$urlQuery"|grep 'Last-Modified:'|cut -f3 -d" ")

            resp=$(date -d "$dia $mes $ano" "+%Y-%m-%d")
            echo $resp
        ;;
        lastCommitDateTimestamp)  
            dia=""
            mes=""
            ano=""
            resp=""

            ano=$(curl -k -I "$urlQuery"|grep 'Last-Modified:'|cut -f5 -d" ")
            mes=$(curl -k -I "$urlQuery"|grep 'Last-Modified:'|cut -f4 -d" ")
            dia=$(curl -I "$urlQuery"|grep 'Last-Modified:'|cut -f3 -d" ")

            resp=$(date -d "$dia $mes $ano" "+%Y-%m-%d")
            resp=$(date -d "$resp" "+%s")
            echo $resp
        ;;
        lastCommitTime)
            resp=""

            resp=$(curl -k -I "$urlQuery"|grep 'Last-Modified:'|cut -f6 -d" ")
            echo $resp
        ;;
        *)
            errorMsg 'nexusLib.sh->getInfoPackage : Tipo de informacao '${typeInfo}' nao implementada. informacoes disponiveis para consulta [lastCommitDate | lastCommitDateTimestamp | lastCommitTime]'
            usage
            exit 1
        ;;
    esac
}