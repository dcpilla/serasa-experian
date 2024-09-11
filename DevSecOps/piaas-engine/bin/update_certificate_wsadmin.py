#!/bin/bash

###############################################################################
# Descrição: Script criado para importar e atualizar certificados             #
#            no trust store do wsadmin para execução da Esteira Deploy        #
# Data: 2023/06/19                                                            #
# Revisão: 2.2                                                                #
# Criado por: Thiago Costa                                                    #
# Refatorado por: Felipe Olivotto											  #
# Alteração: Validação das datas modo epoch e incluido teste de conexão		  #
###############################################################################

import os
import subprocess
import re
import time
from datetime import datetime

keytool_path = "/opt/infratransac/IBM/WebSphere/AppServer/java/bin/keytool"
truststore_path = "/opt/infratransac/IBM/WebSphere/AppServer/profiles/Deploy/etc/trust.p12"

# Get usr_ci_integra credentials
credentials = subprocess.getoutput("cyberArkDap -s 'BR_PAPP_EITS_DSECOPS_STATIC' -c 'connection_was'").split(" ")

def epoch_to_datetime(epoch):
    return datetime.fromtimestamp(epoch)

def read_files(path):
    with open(path, 'r') as f:
        output = f.read()
    return output


def delete_alias(host):
    code_exec = os.system("{} -delete -alias {} -keystore {} -storepass WebAS -noprompt".format(keytool_path, host, truststore_path))
    if code_exec == 0:
        print("O alias {} foi removido com sucesso da keystore.".format(host))


def import_expired_date(host, cert_info):

    print("\nO alias {} foi encontrado. Validando se ainda está válido...".format(host))

    until_date = re.search(r'until: (\d+\/\d+\/\d+ \d+:\d+ [AM|PM]+)', cert_info)
    until_date = until_date.group(1)

    initial_data = int(time.time())
    final_data = int(time.mktime(time.strptime(until_date, '%m/%d/%y %I:%M %p')))
   
    delta = final_data - initial_data
    
    # 60 days to expire
    if delta >= 5184000:
        print("O {} certificado ainda está valido e expirará em {} dias.\nVálido até: {}.".format(host, int(delta / 86400), epoch_to_datetime(final_data)))
    else:
        print("O certificado expirará em {} dias. Importando o novo certificado.".format(int(delta / 86400)))
        delete_alias(host)
        import_cert(host)


def import_cert(host):
    print("Importando o Certificado do DMGR {}".format(host))
    os.system("echo '' | openssl s_client -connect {}:9043 -prexit 2>/dev/null | sed -n -e '/BEGIN\ CERTIFICATE/,/END\ CERTIFICATE/ p' > /tmp/cert.txt".format(host))
    code_exec = os.system("{} -import -alias {} -file /tmp/cert.txt -keystore {} -storetype PKCS12 -storepass WebAS -noprompt > /dev/null".format(keytool_path, host, truststore_path))
    if code_exec == 0:
        print("O certificado da dmgr {} foi importado com sucesso.".format(host))


def test_connection(host):
    dmgr_port = 8879 if not host == "spobrwas10" else 8880
    wasadmin_path = "/opt/infratransac/IBM/WebSphere/AppServer/profiles/Deploy/bin/wsadmin.sh"
    output = subprocess.getoutput("{} -conntype SOAP -host {} -port {} -user {} -password {} -lang jython -c 'AdminControl.getCell()'".format(wasadmin_path, host, dmgr_port, credentials[0], credentials[1]))
    if "Connected to process \"dmgr\" on node" in output:
        return True    
    else:
        return False
       

def main():

    hosts_was_version_path = ["/opt/infratransac/IBM/WebSphere/dmgrs.txt", "/opt/infratransac/IBM/WebSphere9/dmgrs.txt"]
    
    for host_path in hosts_was_version_path:
    
        print("\n\nPath : {}".format(host_path))

        hosts = read_files(host_path)

        for host in hosts.split("\n"):
            if host:
                os.system("{} -list -alias {} -v -keystore {} -storetype PKCS12 -storepass WebAS > /tmp/validar.txt".format(keytool_path, host, truststore_path))
                cert_info = read_files("/tmp/validar.txt")
                
                if "keytool error: java.lang.Exception: Alias <{}> does not exist".format(host) in cert_info:
                    print("\nO certificado não encontrado na keystore do WebSphere para o alias {}. Importando...".format(host))
                    import_cert(host)
                
                if "Alias name: {}".format(host) in cert_info:
                    print("\nO alias {} foi encontrado. na truststore. Atualizando o certificado".format(host))
    #               import_expired_date(host, cert_info)                
                    delete_alias(host)
                    import_cert(host)
                else:
                    print("O alias {} não foi encontrado na keystore do WebSphere.".format(host))

                print("Iniciando teste de conexão remota entre o PiaaS e a DMGR {}.".format(host))
                
                if test_connection(host):
                    print("O teste de conexão na dmgr {} foi realizado com sucesso.".format(host))
                else:
                    print("O teste de conexão na dmgr {} falhou. Possíveis problemas:\n \
    * Verifique se o serviço DMGR está ativo;\n \
    * Verifique se a porta SOAP está correta;\n \
    * Verifique se o certificado PKCS12 foi importado corretamente na truststore;\n \
    * Verifique se o usuário usr_ci_integra está devidamente configurado na DMGR destino;\n \
    * Verifique se a senha do usuário usr_ci_integra está expirada.".format(host))

if __name__=="__main__":
    main()
