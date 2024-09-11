#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           outsystemLib.sh
# * @version        $VERSION
# * @description    Biblioteca com as chamadas para Outsystem
# * @copyright      2018 &copy Serasa Experian
# *
# * @version        1.0.0
# * @change         Biblioteca com as chamadas para Outsystem
# * @copyright      2018 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 curl
# *                 /usr/local/bin/jq
# * @date           24-Jan-2019
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
# * VERSION
# * Versão do script
# */
VERSION='1.0.0'

# /**
# * outsystemServer
# * Servidor Outsystem
# * @var string
# */
outsystemServer=`getCredentialsHost outsystem`

# /**
# * outsystemUser
# * Usuário Outsystem
# * @var string
# */
outsystemUser=`getCredentialsUser outsystem`

# /**
# * outsystemToken
# * Token Outsystem
# * @var string
# */
outsystemToken=`getCredentialsToken outsystem`

# /**
# * applicationName
# * Nome da aplicacao 
# * @var string
# */
applicationName=

# /**
# * keyApplication
# * Key da aplicacao 
# * @var string
# */
keyApplication=

# /**
# * environment
# * Ambiente para o deploy
# * @var string
# */
environment=''

# /**
# * keyEnvironment
# * Key do ambiente
# * @var string
# */
keyEnvironment=

# /**
# * Stringresp
# * Armazena string de respostas ao usuario
# * @var string
# */
stringResp=''

# /**
# * resp
# * Armazena respostas
# * @var string
# */
resp=''

# /**
# * Funções
# */

# /**
# * getApplications
# * Método que pega as aplicações da plataforma
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @return  $stringResp
# */
getApplications (){
    resp=''     
    applicationName=''     
    keyApplication=''     
    stringResp=''

    resp=$(curl --request GET \
                --url $outsystemServer'applications' \
                --header 'authorization: Bearer '$outsystemToken'' \
                --header 'cache-control: no-cache' 2>/dev/null)

    for (( i=0; i < $(echo $resp | /usr/local/bin/jq '. | length') ; i++ ))
    do
        applicationName=$(echo $resp | /usr/local/bin/jq -r '.['${i}'].Name')
        keyApplication=$(echo $resp | /usr/local/bin/jq -r '.['${i}'].Key')
        stringResp=$(echo "$applicationName:$keyApplication;$stringResp")
     
        applicationName=''     
        keyApplication=''     
    done

    echo $stringResp 
}

# /**
# * getEnvironmets
# * Método que pega os ambientes da plataforma
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @return  $stringResp
# */
getEnvironmets (){
    resp=''     
    environment=''     
    keyEnvironment=''     
    stringResp=''

    resp=$(curl --request GET \
                --url $outsystemServer'environments' \
                --header 'authorization: Bearer '$outsystemToken'' \
                --header 'cache-control: no-cache'  2>/dev/null)

   for (( i=0; i < $(echo $resp | /usr/local/bin/jq '. | length') ; i++ ))
   do
       environment=$(echo $resp | /usr/local/bin/jq -r '.['${i}'].Name')
       keyEnvironment=$(echo $resp | /usr/local/bin/jq -r '.['${i}'].Key')
       stringResp=$(echo "$environment:$keyEnvironment;$stringResp")
    
       environment=''     
       keyEnvironment=''     
   done

   echo $stringResp
}