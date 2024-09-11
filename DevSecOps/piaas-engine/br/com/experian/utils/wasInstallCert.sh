#!/usr/bin/bash

# Carrega wasLib
test -e common.sh || echo 'Ops, biblioteca wasLib nao encontrada'
source common.sh

keytool_path="/opt/IBM/WebSphere/AppServer/java/bin/keytool"
truststore_path="/opt/IBM/WebSphere/AppServer/profiles/AppSrv01/etc/trust.p12"

# /**
# * wasDmgr
# * Define o DMGR para o deploy
# * @var string
# */
wasDmgr=''

# /**
# * environment
# * Ambiente para o deploy
# * @var string
# */
environment=$1

# /**
# * wsadminUser
# * user conexão wsadmin
# * @var string
# */
wsadminUser=$2

# /**
# * wsadminPwd
# * user conexão wsadmin
# * @var string
# */
wsadminPwd=$3


# /**
# * wasDmgrPort
# * Define o DMGR port para o deploy
# * @var string
# */
wasDmgrPort='8879'

case $environment in
    de) wasDmgr=spobrwas04-de ;;
    hi) wasDmgr=spobrwas03-hi ;;
    he) wasDmgr=spobrwas03-he ;;
    pi) wasDmgr=spobrwas03-pi ;;
    pe) wasDmgr=spobrwas10 ; wasDmgrPort="8880"  ;;
    pehttps1) wasDmgr=spobrwashttps1 ;;
    pehttps3) wasDmgr=spobrwashttps3 ;;
esac

infoMsg "Importando o certificado da console ${wasDmgr}."

echo y > /tmp/response.text
/opt/IBM/WebSphere/AppServer/profiles/AppSrv01/bin/wsadmin.sh -lang jython < /tmp/response.text > /dev/null

openssl s_client -connect $wasDmgr:$wasDmgrPort -prexit 2>/dev/null | sed -n -e '/BEGIN\ CERTIFICATE/,/END\ CERTIFICATE/ p' > /tmp/cert
$keytool_path -import -alias $wasDmgr -file /tmp/cert -keystore $truststore_path -storetype PKCS12 -storepass WebAS -noprompt 2>/dev/null

infoMsg "Testando a conexão com a console ${wasDmgr}."

if /opt/IBM/WebSphere/AppServer/profiles/AppSrv01/bin/wsadmin.sh -conntype SOAP -host ${wasDmgr} -port ${wasDmgrPort} -user ${wsadminUser} -password ${wsadminPwd} -lang jython -c 'AdminControl.getCell()' > /dev/null; then
    infoMsg "O certificado autoassinado da console $wasDmgr foi importado com sucesso!"
else
    errorMsg "Erro ao importar o certificado da dmgr $wasDmgr."
    exit 1
fi