#!/usr/bin/env bash

# /**
# *
# * Este arquivo e parte do launch joaquinx-launch-onboarding
# *
# * @name           apply.sh
# * @version        1.0.0
# * @description    Script que controla o motor de execucao
# * @copyright      2023 &copy Serasa Experian
# *
# * @version        1.0.0
# * @change         - [FEATURE] Criacao e inicializacao do launch;
# * @author         DevSecOps Architecture Brazil
# * @contribution   Fabio Zinato <fabio.zinato@br.experian.com>
# * @dependencies   cockpit_common/common.sh
# * @references     
# * @date           18-Mai-2023
# *
# **/  

# /**
# * Configurações iniciais
# */

# Exit on errors
#set -eu # Liga Debug

# Carrega cockpit_common/common.sh
test -e "cockpit_common/common.sh" || { echo 'Ops, biblioteca cockpit_common/common.sh nao encontrada' ; exit 1; }
source cockpit_common/common.sh

# /**
# * Variaveis de parametros
# */

#/**
# * var1
# * Recebe o parametro de var1 
# * @var string
# **/
var1='@@VAR1@@'

#/**
# * var2
# * Recebe o parametro de var2
# * @var string
# **/
var2='@@VAR2@@'

#/**
# * var3
# * Recebe o parametro de var4 
# * @var string
# **/
var3='@@VAR3@@'

#/**
# * var4
# * Recebe o parametro de var4
# * @var string
# **/
var4='@@VAR4@@'

#/**
# * credentials
# * Recebe o parametro de credentials
# * @var string
# **/
credentials='@@USER_INTEGRACAO@@'
#credentials='@@CYBERARK_CREDENTIAL@@'

# /**
# * Funções
# */

# /**
# * Start
# */

# Forçar para não usar proxy
unset HTTP_PROXY
unset HTTPS_PROXY

# Exemplos de funcoes existentes no cockpit-common

# //log_msg 'mensagem' 'tipo'
log_msg 'apply.sh : Initialize launch aws-create-vpc-endpoint' 'INFO'
log_msg 'var1: '${var1}'' 'INFO'
log_msg 'var2: '${var2}'' 'INFO'
log_msg 'var1Warn: '${var1}'' 'WARNING'
log_msg 'var2Error: '${var2}'' 'FAILED'
log_msg 'apply.sh : Success in run aws-create-vpc-endpoint launcher' 'SUCCESS'

# //mount_cifs_path 'shared_path' 'mount_dir' 'username' 'password'
mount_cifs_path ${var1} ${var2} ${var3} ${var4}

# //umount_cifs_path 'mount_dir'
umount_cifs_path ${var1}

# //get_credentials 'tipo' 'credentials'
get_credentials "vault" "${credentials}"
username="$userCredentials"
password="$passCredentials"

# //get_credentials 'tipo' 'credentials'
get_credentials "cyberark_static" "${credentials}"
username="$userCredentials"
password="$passCredentials"

# //get_credentials 'tipo' 'credentials'
get_credentials "cyberark_onlysecret" "${credentials}"
password="$passCredentials"

# //get_credentials 'tipo' 'credentials'
get_credentials "cyberark_aws" "${credentials}"
accountId="$AwsAccountId"
accessKey="$AwsAccessKey"
AwsPwdKey="$AwsPwdKey"
