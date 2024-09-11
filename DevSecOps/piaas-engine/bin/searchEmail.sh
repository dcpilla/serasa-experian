#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian 
# *
# * @package        DevOps
# * @name           searchEmail.sh
# * @version        1.0.0
# * @description    Script que pesquisa email de usuário pelo seu login de rede e o retorna 
# * @copyright      2017 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# * @date           28-Jul-2017
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
# * login
# * Login do usuário 
# * @var string
# */
login=$1

# /**
# * mailDest
# * Email do usuário
# * @var string
# */
mailDest=

# /**
# * Funções
# */

# /**
# * usage
# * Método help do script
# * @version 1.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
usage () {
  echo "Usage: $0 <login>"
  echo ""
  echo "login            Login de rede de usuario"
  echo ""
  exit 1
}


# /**
# * Start 
# */

test ! -z $login || usage

mailDest=`getEmailUser ${login}`
if [ "$?" -eq 1 ] ; then
    errorMsg 'searchEmail : Email não encontrado para '${login}' informado na pesquisa'
    exit 1
fi

echo "$mailDest"
exit 0