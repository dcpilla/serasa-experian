#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian 
# *
# * @package        DevOps
# * @name           getLogonUser.sh
# * @version        1.0.0
# * @description    Script que busca logon de usuário apartir do e-mail rede
# * @copyright      2018 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# * @date           19-Jul-2018
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
# * emailUser
# * Email do usuário
# * @var string
# */
emailUser="$1"

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
  echo "Usage: $0 <emailUser>"
  echo ""
  echo "emailUser          Email do usuário"
  echo ""
  exit 1
}


# /**
# * Start
# */

test ! -z "$emailUser" || usage

resp=`getLogonUser ${emailUser}`
resp=`echo ${resp}|sed 's/^[ \t]*//;s/[ \t]*$//'`

if [ "$resp" == "" ]; then
   emailUserNew=$(echo $emailUser | sed 's/@br\./@/')
   resp=`getLogonUser ${emailUserNew}`
   resp=`echo ${resp}|sed 's/^[ \t]*//;s/[ \t]*$//'`
fi

if [ "$?" -eq 1 ] ; then
    errorMsg 'getLogonUser : Logon não encontrado para '${emailUser}' informado na pesquisa'
    exit 1
fi

echo "$resp"
exit 0
