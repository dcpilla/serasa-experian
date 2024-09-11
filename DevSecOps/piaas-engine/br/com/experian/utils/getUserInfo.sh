#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian 
# *
# * @package        DevOps
# * @name           getUserInfo.sh
# * @version        1.0.0
# * @description    Script que busca infos de usuário apartir do e-mail rede
# * @copyright      2024 &copy Serasa Experian
# * @author         Fabio P. Zinato <fabio.zinato@experian.com>
# * @dependencies   common.sh
# * @date           19-Jun-2024
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
# * infoUser
# * info do usuário
# * @var string
# */
infoUser="$2"

# /**
# * Funções
# */

# /**
# * usage
# * Método help do script
# * @version 1.0.0
# * @package DevOps
# * @author  Fabio P. Zinato <fabio.zinato@experian.com>
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

if [ "$infoUser" == "title" ]; then
   resp=`getTitleUser ${emailUser}`
   resp=`echo ${resp}|sed 's/^[ \t]*//;s/[ \t]*$//'`
elif [ "$infoUser" == "name" ]; then   
   resp=`getNameUser ${emailUser}`
   resp=`echo ${resp}|sed 's/^[ \t]*//;s/[ \t]*$//'`
fi

if [ "$?" -eq 1 ] ; then
    errorMsg 'getUserInfo : Informações sobre '${infoUser}' não foram encontradas para '${emailUser}' informado na pesquisa.'
    exit 1
fi

echo "$resp"
exit 0
