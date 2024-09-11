#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian 
# *
# * @package        DevOps
# * @name           updateDependencies.sh
# * @version        1.0
# * @description    Script que faz atualização de updateDependencies 3rd party , plaas global , credentials-crypto
# * @copyright      2020 &copy Serasa Experian
# *
# * @version        1.1
# * @description    Alteração do script para suporte a todas dependencias 
# * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @date           11-Fev-2021
# *
# * @version        1.0
# * @description    Script que faz atualização de updateDependencies 3rd party , plaas global , credentials-crypto
# * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @date           10-Mar-2020
# *
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
# * environmentUpdate
# * Define ambiente para update
# * @var string
# */
environmentUpdate="$1"


# /**
# * Start 3rd party community
# */
echo ""
echo "Update 3rd party community [$environmentUpdate]" 
mkdir /opt/infratransac/core/3rdparty
git clone -b $environmentUpdate ssh://git@code.experian.local/edvp/core-3rdparty.git /opt/infratransac/core/3rdparty
rm -rf /opt/infratransac/core/3rdparty/.git /opt/infratransac/core/3rdparty/.gitignore /opt/infratransac/core/3rdparty/README.md


echo "Apply 3rd party permissions [$environmentUpdate]"  
chmod 770 /opt/infratransac/core/3rdparty -Rf

echo "Finish 3rd party community" 
echo ""
# /**
# * End 3rd party community
# */


# /**
# * Start PlaaS functions
# */

#echo "Update PLaaS functions [$environmentUpdate]" 
#git clone -b feature/dockerGolangVeracodeAgentScan ssh://git@code.experian.local/jen/devopspipeline-library.git  /tmp/devopspipeline-library/ 
#mv /tmp/devopspipeline-library/vars/ /opt/infratransac/core/3rdparty/plaas/
#rm -rf /tmp/devopspipeline-library/
#echo "Normalize PLaaS functions [$environmentUpdate]" 
#for ln in $(ls -A "$baseDir/3rdparty/plaas"); do
#	sed -i "s/def call/def main/g" "$baseDir/3rdparty/plaas/$ln"
#	echo -e '\nreturn this' >> "$baseDir/3rdparty/plaas/$ln"
#done

# /**
# * End PlaaS functions
# */