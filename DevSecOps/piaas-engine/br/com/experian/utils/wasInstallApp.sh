#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           deploy.sh
# * @version        $VERSION
# * @description    Script que faz deploy no WebSphere
# * @copyright      2023 &copy Serasa Experian
# *
# * @version        1.0.0
# * @description    
# * @copyright      2023 &copy Serasa Experian
# * @author         Felipe Olivotto <felipe.olivotto@br.experian.com>
# * @dependencies   wasLib.sh
# *                 raLib.sh
# *
# * @date           14-Set-2023


# Carrega wasLib
test -e wasLib.sh || echo 'Ops, biblioteca wasLib nao encontrada'
source wasLib.sh

# Carrega common
test -e common.sh || echo 'Ops, biblioteca wasLib nao encontrada'
source common.sh

# /**
# * VERSION
# * Versão do script
# */
VERSION='1.0.0'

# /**
# * environment
# * Ambiente para o deploy
# * @var string
# */
environment=$1

# /**
# * urlPackage
# * Url pacote para o deploy
# * @var string
# */
urlPackage=$2

# /**
# * wsadminUser
# * user conexão wsadmin
# * @var string
# */
wsadminUser=$3

# /**
# * wsadminPwd
# * user conexão wsadmin
# * @var string
# */
wsadminPwd=$4

# /**
# * method
# * metodo de deploy
# * @var string
# */
method='wsdamin'


# /**
# * Start
# */

deploymentsWas $urlPackage $environment $method $wsadminUser $wsadminPwd

if [ $? -eq 0 ]; then
    infoMsg 'wasInstallApp.sh : Sucesso no deploy \o/' 
else
    errorMsg 'wasInstallApp.sh : Falha no deploy :('
fi
