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
# * validPackage
# * Método valida package informado
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
validPackage () {

    resp=`curl -I -k "$urlPackage"|grep 'HTTP'|cut -f2 -d" "`
        
    infoMsg 'validPackage -> Retorno do status do pacote '${resp}' '
    if [ "$resp" == "200" ] || [ "$resp" == "307" ]; then
        infoMsg 'validPackage -> Pacote '${urlPackage}' encontrado seguindo com o deploy'
    else
        errorMsg 'validPackage -> Pacote informado '${urlPackage}' nao encontrado impossivel prosseguir'
        exit 1
    fi
}

# /**
# * Start
# */

# infoMsg 'deploy.sh : Executando o deploy em '${target}''
# infoMsg 'deploy.sh : Usando o metodo de deploy '${method}''

qtdEnvs=$(echo $environment | grep -o ',' | wc -l)
qtdEnvs=$(( $qtdEnvs + 1 ))

validPackage

for (( i=1; i <= $qtdEnvs ; i++ )); do
    flagEnvWas=""
    flagEnvWas=`echo "$environment"|cut -d ',' -f${i}`

    infoMsg "deployWas.sh -> Importando o certificado da console remota."
    if ./wasInstallCert.sh $environment $wsadminUser $wsadminPwd; then

        infoMsg 'deployWas.sh : Iniciando deploy em '${flagEnvWas}''
        deploymentsWas $urlPackage $flagEnvWas 'wsadmin' $wsadminUser $wsadminPwd

        if [ $? -eq 0 ]; then
            infoMsg 'deployWas.sh : Sucesso no deploy \o/' 
        else
            errorMsg 'deployWas.sh : Falha no deploy :('
        fi
    else
        errorMsg 'deployWas.sh : Não foi possível realizar a configuração do certificado da console $flagEnvWas.'
        errorMsg 'deployWas.sh : Verifique se a console administrativa ${flagEnvWas} está ativa.'
    fi
done
