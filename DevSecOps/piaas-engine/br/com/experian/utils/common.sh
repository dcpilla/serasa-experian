#!/usr/bin/env bash

VERSION='1.5.0'

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian 
# *
# * @package        DevOps
# * @name           common.sh
# * @version        $VERSION
# * @description    Biblioteca com funcionalidades comuns
# * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @copyright      2018 &copy Serasa Experian
# *
# * @version        1.5.0
# * @change         [UPD] Get ci-cd vaults considerando get de json ou somente user_with_password;
# * @copyright      2022 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @dependencies   fusermount
# *                 gocryptfs
# *                 jq 
# *                 jenkins-credentials-decryptor (https://github.com/hoto/jenkins-credentials-decryptor)
# * @date           07-Jun-2022
# *
# * @version        1.4.0
# * @change         [FEATURE] Implementação de get ci-cd vaults
# * @copyright      2021 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @dependencies   fusermount
# *                 gocryptfs
# *                 jq 
# *                 jenkins-credentials-decryptor (https://github.com/hoto/jenkins-credentials-decryptor)
# * @date           20-Out-2021
# *
# * @version        1.3.0
# * @change         [BUG] Correção de vulnerabildiades
# * @copyright      2021 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @dependencies   fusermount
# *                 gocryptfs
# *                 jq 
# *                 jenkins-credentials-decryptor (https://github.com/hoto/jenkins-credentials-decryptor)
# * @date           11-Fev-2021
# *
# * @version        1.2.0
# * @change         Adicionado função setProxy ()
# * @copyright      2018 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @dependencies   credentials.xml
# * @date           03-Ago-2018
# * 
# * @version        1.0.0
# * @description    Biblioteca com funcionalidades comuns
# * @copyright      2017 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @date           28-Jul-2017
# **/  

# /**
# * Configurações iniciais
# */

# Exit se erros 
#set -eu   # Liga Debug

# Diretorio base 
baseDir="/opt/infratransac/core"

# OBS: DAQUI PRA BAIXO ESTA SENDO MANTIDO DEVIDO O getCredentialsCiCd utilizar as variaveis para vault JENKINS
# JENKINS_HOME
if [[ -z "$JENKINS_HOME" ]]; then JENKINS_HOME="/opt/infratransac/jenkins" ; fi

# $JENKINS_HOME/credentials.xml
JENKINS_HOME_CREDENTIALS="$JENKINS_HOME/credentials.xml"

# $JENKINS_HOME/secrets/master.key
JENKINS_HOME_MASTER="$JENKINS_HOME/secrets/master.key"

# $JENKINS_HOME/secrets/hudson.util.Secret
JENKINS_HOME_HUDSON="$JENKINS_HOME/secrets/hudson.util.Secret"

# /**
# * Funções
# */

# /**
# * infoMsg
# * Método mensagem de informação 
# * @version 1.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @parm    string de msg a ser exibida
# */
infoMsg() {
    GREEN='\033[0;32m'   
    RESET='\033[0m'      
    echo -e "${GREEN}[INFO] $(date '+%Y/%m/%d-%R:%S') - $@${RESET}"
}


# /**
# * warnMsg
# * Método mensagem de alerta
# * @version 1.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @parm    string de msg a ser exibida
# */
warnMsg() {
    YELLOW='\033[1;33m' 
    RESET='\033[0m'
    echo -e "${YELLOW}[WARN] $(date '+%Y/%m/%d-%R:%S') - $@${RESET}"
}

# /**
# * errorMsg
# * Método mensagem de erros
# * @version 1.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @parm    string de msg a ser exibida
# */
errorMsg() {
    RED='\033[0;31m'
    RESET='\033[0m'
    echo -e "${RED}[ERROR] $(date '+%Y/%m/%d-%R:%S') - $@${RESET}"
}

# /**
# * promptMsg
# * Método para exibir perguntas [y/n] e tomar decisão 
# * @version 1.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @parm    string de msg a ser exibida
# */
promptMsg() {
	printf -- '\033[1;37m + \033[1;37m%s \033[0m[y/N]: ' "$@"
	if [ "$assume" = 'yes' ]; then
		printf -- '%s\n' 'y'
		return 0
	elif [ "$assume" = 'no' ]; then
		printf -- '%s\n' 'n'
		return 1
	else
		read answer
		case "$answer" in
			[yY]|[yY][eE][sS]) return 0 ;;
			*) return 1 ;;
		esac
	fi
}

# /**
# * getCredentialsCiCd
# * Método para retornar do vault ci/cd uma credencial
# * @version 1.5.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   bu 
# *          squad
# *          vault
# * @return  true | false
# */
getCredentialsCiCd() {
    local bu=""
    local squad=""
    local vault=""
    local jenkinsCredentialsId=""
    local jenkinsQueryCredentials=""
    local vaultResp=""
    local flagType=""
    
    if [ $# -eq 1 ];then
        flagType="user_with_password"
    else
        flagType="json"
    fi
    
    if [ "$flagType" == "json" ]; then
        bu="$1"
        squad="$2"
        vault="$3"
        test ! -z $bu || { errorMsg 'common.sh->getCredentialsCiCd: Bu nao informado' ; exit 1; }
        test ! -z $squad || { errorMsg 'common.sh->getCredentialsCiCd: Squad nao informado' ; exit 1; }
        test ! -z $vault || { errorMsg 'common.sh->getCredentialsCiCd: Vault nao informado' ; exit 1; }

        jenkinsCredentialsId="$bu.CICD.Vault"
        jenkinsQueryCredentials=$(/usr/local/bin/jenkins-credentials-decryptor -m $JENKINS_HOME_MASTER \
                                                                               -s $JENKINS_HOME_HUDSON \
                                                                               -c $JENKINS_HOME_CREDENTIALS \
                                                                               -o json | jq -r '.[] | select(.id | test("^'"$jenkinsCredentialsId"'$";"i")) | .secret')

        vaultResp=$(echo "$jenkinsQueryCredentials" |/usr/local/bin/jq -r '.businessUnits[]|select(.name | test("^'"$bu"'$";"i"))|.squads[]|select(.name | test("^'"$squad"'$";"i"))|.vaults[]| select(.name | test("^'"$vault"'$";"i")) | .secrets[]')
    elif [ "$flagType" == "user_with_password" ]; then
        vault="$1"
        test ! -z $vault || { errorMsg 'common.sh->getCredentialsCiCd: Vault nao informado' ; exit 1; }

        jenkinsCredentialsId="$vault"
        jenkinsQueryCredentials=$(/usr/local/bin/jenkins-credentials-decryptor -m $JENKINS_HOME_MASTER \
                                                                               -s $JENKINS_HOME_HUDSON \
                                                                               -c $JENKINS_HOME_CREDENTIALS \
                                                                               -o json | jq -r '.[] | select(.id | test("^'"$jenkinsCredentialsId"'$";"i"))')

        vaultResp=$(echo "$jenkinsQueryCredentials" | jq -r '.id,.description,.username,.password' | tr '\n' ' ')
    else
        echo 'common.sh->getCredentialsCiCd: Tipo Vault para pesquisa nao existe' 
        exit 1    
    fi

    if [ "$vaultResp" == "" ] && [ "$flagType" == "json" ]; then
        echo 'common.sh->getCredentialsCiCd: Vault tipo json nao encontrado' 
        echo 'Detalhes da busca:'
        echo "Bu: $bu"
        echo "Squad: $squad"
        echo "vault: $vault"
        exit 1
    elif [ "$vaultResp" == "" ] && [ "$flagType" == "user_with_password" ]; then
        echo 'common.sh->getCredentialsCiCd: Vault tipo user_with_password nao encontrado' 
        echo "vault: $vault"
        exit 1
    fi

    echo "$vaultResp"
    return 0
}

# /**
# * getCredentialsHost
# * Método para retornar o host de uma ferramenta
# * @version 1.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   string search - ferramenta desejada para pesquisa
# * @Cuidado Preencher os valores no Cyberark DAP mesmo que seja ficticio pois nosso script cyberArkDAP trabalha com posições
# * @return  true | false
# */
getCredentialsHost() {
    account=$1
        
    if ! credentials=$(cyberArkDap --safe BR_PAPP_EITS_DSECOPS_STATIC -c "$account"); then
        warnMsg 'common.sh->getCredentialsHost: Erro ao se autenticar no CyberArk.'
        exit 1
    fi
    
    hostname=$(echo $credentials | jq -r '.address')
    echo "$hostname"
    return 0
}

# /**
# * getCredentialsUser
# * Método para retornar o usuario de uma ferramenta
# * @version 1.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   string search - ferramenta desejada para pesquisa
# * @Cuidado Preencher os valores no Cyberark DAP mesmo que seja ficticio pois nosso script cyberArkDAP trabalha com posições
# * @return  true | false
# */
getCredentialsUser() {
    account=$1
        
    if ! credentials=$(cyberArkDap --safe BR_PAPP_EITS_DSECOPS_STATIC -c "$account"); then
        warnMsg 'common.sh->getCredentialsHost: Erro ao se autenticar no CyberArk.'
        exit 1
    fi
    
    username=$(echo $credentials | jq -r '.username')
    echo "$username"
    return 0
}

# /**
# * getCredentialsToken
# * Método para retornar o token ferramenta
# * @version 1.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   string search - ferramenta desejada para pesquisa
# * @Cuidado Preencher os valores no Cyberark DAP mesmo que seja ficticio pois nosso script cyberArkDAP trabalha com posições
# * @return  true | false
# */
getCredentialsToken() {
    account=$1
        
    if ! credentials=$(cyberArkDap --safe BR_PAPP_EITS_DSECOPS_STATIC -c "$account"); then
        warnMsg 'common.sh->getCredentialsHost: Erro ao se autenticar no CyberArk.'
        exit 1
    fi
    
    password=$(echo $credentials | jq -r '.password')
    echo "$password"
    return 0
}

# /**
# * testKeys
# * Método para testar troca de chaves entre servidores
# * @version 1.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   string servidor desejado para o teste
# * @param   string usuário desejado para test
# * @return  true | false
# */
testKeys(){
    resp=
    server=$1
    user=$2

    resp=`ssh ${user}@${server} echo 0`
    
    if [ "$resp" == "0" ]; then
        return 0
    else
        return 1
    fi    
}

# /**
# * getEmailUser
# * Método para buscar email de usuário apartir do logon de rede
# * @version 1.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   string logon 
# * @return  true | false
# */
getEmailUser(){
    logon=$1

    ldapServer=`getCredentialsHost ldap`
    ldapToken=`getCredentialsToken ldap`
    ldapToken=`echo ${ldapToken} | base64 -d`

    resp=""
    resp=`/usr/share/centrifydc/bin/ldapsearch -h ${ldapServer} -p 389 -x -D "CN=usr_ci_integra,CN=Users,DC=serasa,DC=intranet" -b "DC=serasa,DC=intranet" -w ${ldapToken} -z 5 "sAMAccountName=${logon}" |grep proxyAddresses|grep sip|cut -d ':' -f3`

    echo ${resp} | grep '^([a-zA-Z0-9_-.])+@[0-9a-zA-Z.-]+\.[a-z]{2,3}$'
    if [ ${#resp} -gt 1 ] ; then
        echo ${resp}
        return 0
    fi
    return 1
}

# /**
# * getLogonUser
# * Método para buscar logon de usuário apartir do email rede
# * @version 1.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   string logon 
# * @return  true | false
# */
getLogonUser(){
    emailRede=$1

    ldapServer=`getCredentialsHost ldap`
    ldapToken=`getCredentialsToken ldap`
    ldapToken=`echo ${ldapToken} | base64 -d`

    resp=""
    resp=`/usr/share/centrifydc/bin/ldapsearch -h ${ldapServer} -p 389 -x -D "CN=usr_ci_integra,CN=Users,DC=serasa,DC=intranet" -b "DC=serasa,DC=intranet" -w ${ldapToken} -z 5 "mail=${emailRede}"|grep sAMAccountName|cut -d':' -f2|sed 's/^[ \t]*//;s/[ \t]*$//'`

    echo ${resp} | fgrep '^([a-zA-Z0-9_-.])+@[0-9a-zA-Z.-]+\.[a-z]{2,3}$'
    if [ ${#resp} -gt 1 ] ; then
        echo ${resp}
        return 0
    fi
    return 1
}

# /**
# * getTitleUser
# * Método para buscar titulo de usuário apartir do logon de rede
# * @version 1.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   string logon 
# * @return  true | false
# */
getTitleUser(){
    emailRede=$1

    ldapServer=`getCredentialsHost ldap`
    ldapToken=`getCredentialsToken ldap`
    ldapToken=`echo ${ldapToken} | base64 -d`

    resp=""
    resp=`/usr/share/centrifydc/bin/ldapsearch -h ${ldapServer} -p 389 -x -D "CN=usr_ci_integra,CN=Users,DC=serasa,DC=intranet" -b "DC=serasa,DC=intranet" -w ${ldapToken} -z 5 "mail=${emailRede}" | grep title | cut -d':' -f2 | sed 's/^[ \t]*//;s/[ \t]*$//'`

    echo ${resp} | fgrep '^([a-zA-Z0-9_-.])+@[0-9a-zA-Z.-]+\.[a-z]{2,3}$'
    if [ ${#resp} -gt 1 ] ; then
        echo ${resp}
        return 0
    fi
    return 1
}

# /**
# * getNameUser
# * Método para buscar nome de usuário apartir do logon de rede
# * @version 1.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   string logon 
# * @return  true | false
# */
getNameUser(){
    emailRede=$1

    ldapServer=`getCredentialsHost ldap`
    ldapToken=`getCredentialsToken ldap`
    ldapToken=`echo ${ldapToken} | base64 -d`

    resp=""
    resp=`/usr/share/centrifydc/bin/ldapsearch -h ${ldapServer} -p 389 -x -D "CN=usr_ci_integra,CN=Users,DC=serasa,DC=intranet" -b "DC=serasa,DC=intranet" -w ${ldapToken} -z 5 "mail=${emailRede}" | grep name | cut -d':' -f2 | sed 's/^[ \t]*//;s/[ \t]*$//'`

    echo ${resp} | fgrep '^([a-zA-Z0-9_-.])+@[0-9a-zA-Z.-]+\.[a-z]{2,3}$'
    if [ ${#resp} -gt 1 ] ; then
        echo ${resp}
        return 0
    fi
    return 1
}

# /**
# * sendEmail
# * Método para envio de email para o adm DevOps
# * @version 1.0.0
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# * @param   string msg desejada
# * @param   string mailDest 
# * @return  true | false
# */
sendEmail(){
    msg=$1
    mailDest=$2
    mailHost=`getCredentialsHost email`

    if [ $(hostname) != "${mailHost}" ] ; then
        if ! testKeys $mailHost $(whoami) ; then
            errorMsg 'common->sendEmail : OPS, Este host nao tem troca de chaves com o host de envio de email setado em credenciais!'
            return 1
        fi
        ssh $mailHost mail -s 'Automatizacoes_DevOps' $mailDest <<< "$msg"
    else
        mail -s 'Automatizacoes_DevOps' $mailDest <<< $msg
    fi

    return 0
}

# /**
# * urlencode
# * Método para codificar string para padrão de url web
# * @version 1.0.0
# * @package DevOps
# * @author  Andre Colavite <Andre.Colavite@br.experian.com>
# * @param   string  
# * @return  string codificada
# */
urlencode(){
        tab="`echo -en "\x9"`"
        local i="$@"
        i=${i//%/%25}  ; i=${i//' '/%20} ; i=${i//$tab/%09}
        i=${i//!/%21}  ; i=${i//\"/%22}  ; i=${i//#/%23}
        i=${i//\$/%24} ; i=${i//\&/%26}  ; i=${i//\'/%27}
        i=${i//(/%28}  ; i=${i//)/%29}   ; i=${i//\*/%2a}
        i=${i//+/%2b}  ; i=${i//,/%2c}   ; i=${i//-/%2d}
        i=${i//\./%2e} ; i=${i//\//%2f}  ; i=${i//:/%3a}
        i=${i//;/%3b}  ; i=${i//</%3c}   ; i=${i//=/%3d}
        i=${i//>/%3e}  ; i=${i//\?/%3f}  ; i=${i//@/%40}
        i=${i//\[/%5b} ; i=${i//\\/%5c}  ; i=${i//\]/%5d}
        i=${i//\^/%5e} ; i=${i//_/%5f}   ; i=${i//\`/%60}
        i=${i//\{/%7b} ; i=${i//|/%7c}   ; i=${i//\}/%7d}
        i=${i//\~/%7e}
        echo "$i"
}

# /**
# * urldecode
# * Método para decodificar string para padrão de url web
# * @version 1.0.0
# * @package DevOps
# * @author  Andre Colavite <Andre.Colavite@br.experian.com>
# * @param   string  
# * @return  string decodificada
# */
urldecode() {
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}


# /**
# * lerJSON
# * Método para ler string no formato JSON e retornar o valor do campo especificado
# * @version 1.0.0
# * @package DevOps
# * @author  Andre Colavite <Andre.Colavite@br.experian.com>
# *
# * @alter   Validação da passagem de parametro
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# *
# * @param   string campoNome 
# * @param   string textoJson
# * @return  string valor do campo
# */
lerJSON (){
    test ! -z "$1" || errorMsg 'common.sh->lerJSON : Nome do campo para leitura nao informado'
    test ! -z "$2" || errorMsg 'common.sh->lerJSON : String do JSON nao informada'

    campoNome="${1}"
    textoJson="${2}"

    #substituir a , por | para leitura do JSon, necessário pois tivemos casos onde o valor do campo continha ,
    vlDe=',"'
    vlPara='|"'
    textoJson=${textoJson//${vlDe}/${vlPara}}
    #ler a qtde de | no texto
    qtde=$(echo ${textoJson} | grep -o '|' | wc -l)
    for (( i=1; i<=${qtde}+1; i++ ))
    do
        #ler o json pela divisão de coluna por virgula
        coluna=$(echo ${textoJson} | cut -d '|' -f $i)
        #ler coluna 1
        col1=$(echo ${coluna} | cut -d ':' -f 1)
        #tirar aspas do texto
        col1="${col1//'"'/}"
        #tirar barra do texto
        col1="${col1//'{'/}"
        #ler coluna 2
        col2=$(echo ${coluna} | cut -d ':' -f 2)
        #tirar aspas do texto
        col2="${col2//'"'/}"
        #tirar barra do texto
        col2="${col2//'}'/}"
        #validar se o campo a ser retorna é o lido nas colunas
        if [ "${campoNome}" == "${col1}" ]; then
            echo "${col2}"      
        fi
    done
}

# /**
# * setProxy
# * Método que seta o proxy
# * @version $VERSION
# * @package DevOps
# * @author  Joao Paulo Bastos <Joao.Leite2@br.experian.com>
# */
setProxy () {
    infoMsg 'common.sh->setProxy : Setando configuracoes de proxy'
    export http_proxy=http://spobrproxy.serasa.intranet:3128
    export https_proxy=http://spobrproxy.serasa.intranet:3128
}