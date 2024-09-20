#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           apply.sh
# * @description    Check de grupo AD para restringir execução da automação
# * @copyright      2024 &copy Serasa Experian
# *
# **/

ldapCredentials="@@USER_INTEGRACAO_LDAP@@"

ldapUser=$(echo $ldapCredentials | cut -d' ' -f1)

ldapPassword=$(echo $ldapCredentials | cut -d' ' -f2)

ldapSearchResult=$(ldapsearch -h 10.96.215.11 -p 389 -x -D CN=$ldapUser,CN=Users,DC=serasa,DC=intranet -b  DC=serasa,DC=intranet -w $ldapPassword -z 5 sAMAccountName=$legacy_logon | grep Br_Aws_DevOpsPaas_Adm | wc -l)

if [ "$ldapSearchResult" == "1" ]; then
    echo "[INFO] Usuário $legacy_logon liberado para executar a automação."
    exit 0
else
    echo "[ERROR] Usuário $legacy_logon não liberado para executar a automação."
    exit 1
fi