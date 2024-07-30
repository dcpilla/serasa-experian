#!/usr/bin/env python3.6
# -*- coding: utf-8 -*-

# /**
# *
# * Nota:
# * Script copiada do launch 'aws-fix-sqs-encrypt'
# * @name           main.py
# * @version        1.0.0
# * @autor          Felipe Olivotto <Felipe.Olivotto@br.experian.com>
# * @dependencies   kms-sqs-policy.json
# * @date           27-Out-2021
# *
# * Adaptada para uso nesse projeto (aws-service-sqs)
# * @name           kms-config.py
# * @version        1.0.0
# * @autor          Adaptada por Gleise Teixeira <Gleise.Teixeira@br.experian.com>
# * @dependencies   kms-sqs-policy.json
# * @date           04-Fev-2022
# *
# **/ 

# Passos:
# 
# 1 - Validar se o user tem permissao no IAM
# 
# 2 - Configurar um KMS (com rotate)
# 	2.1 - Criar uma policy default
# 	2.2 - Criar o kms chamada SQS, apontando o json de policy.
# 	
# 3 - Configurar a criptografia no sqs, apontando o KEY ID SQS criado acima

import re
import os
import json
import subprocess

vars=subprocess.getoutput('aws sts assume-role \
--role-arn arn:aws:iam::@@AWS_ACCOUNT_ID@@:role/BURoleForDevSecOpsCockpitService \
--role-session-name Session_kms_enable_key_rotation_for_bu_@@BU@@ \
--query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
--output text')

# Set environment variables
os.environ['AWS_ACCESS_KEY_ID'] = vars.split()[0]
os.environ['AWS_SECRET_ACCESS_KEY'] = vars.split()[1]
os.environ['AWS_SESSION_TOKEN'] = vars.split()[2]

def main():

#   Validando se o assume role foi realizado com sucesso.
    try:
        accessRole = subprocess.getoutput("aws sts get-caller-identity")
        account = json.loads(accessRole)['Account']
        if account == "@@AWS_ACCOUNT_ID@@":
            print("Assume role realizado com sucesso. Conta: %s." % account)
    except:
        raise("Nao foi possivel realizar o assume role. Terminando o script.")

    regiao = "@@REGION@@"

    flag = False

    try:
#       Validar se a key ja existe
        kmsAliases = json.loads(subprocess.getoutput("aws kms list-aliases --region %s" % regiao))
        for kmsAlias in kmsAliases["Aliases"]:
            if re.search("sqs", kmsAlias["AliasName"]):
                kmsId = kmsAlias["TargetKeyId"]
                flag = True

        if flag == True:
            print("A key sqs ja existe. KeyID: %s" % kmsId)
        else:
#           Criar um KMS Key ID
            print("Criando uma key padrao. Nome: sqs.")
            output = subprocess.getoutput("aws kms create-key --region %s" % regiao)
            kmsId = json.loads(output)["KeyMetadata"]["KeyId"]

#           Define um alias
            print("Definindo um alias para o kms %s." % kmsId)
            subprocess.getoutput("aws kms create-alias --alias-name alias/sqs --region %s --target-key-id %s" % (regiao, kmsId))

#           Configura o kms-sqs-policy.json
            print("Configurando uma policy padrao para o kms sqs.")
            subprocess.getoutput("aws kms put-key-policy --policy-name default --region %s --key-id %s --policy file://kms-sqs-policy.json" % (regiao, kmsId))

#           Configurando o rotacionamento das keys.
            print("Configurando o rotacionamento da key sqs.")
            subprocess.getoutput("aws kms enable-key-rotation --region %s --key-id %s"  % (regiao, kmsId))
    except:
        raise("Nao foi possivel configurar a key. Possiveis razoes:\n\
            * Voce nao tem permissao para ler ou editar as configuracoes KMS;\n\
            * Houve uma falha para configurar o nome da key;\n\
            * Houve uma falha para configurar a policy;\n\
            * Houve uma falha para habilitar o rotacionamento da key.")

#   Recuperando o nome da fila SQS
    file = open("queue-name.info")
    queue_name = file.read()
    file.close()

#   Apontando o KMS no SQS.
    print("Iniciando a validacao da criptografia da fila SQS.")
    sqsAlias = queue_name
    output = subprocess.getoutput("aws sqs list-queues --region %s --queue-name-prefix %s" % (regiao, sqsAlias))
    if output and not re.search(r'AccessDenied', output) and re.search(sqsAlias, output):
        url = json.loads(output)["QueueUrls"][0]
        encript = subprocess.getoutput("aws sqs get-queue-attributes --region %s --queue-url %s --attribute-names KmsMasterKeyId" % (regiao, url))
        if not encript:
            print("Queue %s nao esta com a criptografia habilitada." % sqsAlias)
            subprocess.getoutput("aws sqs set-queue-attributes --region %s --queue-url %s --attributes KmsMasterKeyId=%s" % (regiao, url, kmsId))
            print("Criptografia configurada com sucesso.")
        else:
            print("A criptografia ja esta habilitada na queue %s." % sqsAlias)
    elif not output:
        print("A queue %s nao foi encontrada. Verifique se o nome esta correto." % sqsAlias)
        exit(1)
    else:
        print("Acesso negado. Verifique se voce possui permissoes de edicao nas politicas IAM.")
        exit(1)

if __name__=="__main__":
    main()