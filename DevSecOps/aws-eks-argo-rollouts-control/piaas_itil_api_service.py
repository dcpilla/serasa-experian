import requests
import os
import json
import sys
from cockpit_common.common import *

iamToken = os.environ.get("session_token")

environment = os.environ.get("cockpit_env")


def getAwsAccount(accountId):

    if environment == "prod":
        url = 'https://piaas-itil-api-prod.devsecops-paas-prd.br.experian.eeca/piaas-itil/v1/accounts/' + accountId + '/aws'
    else:
        url = 'https://piaas-itil-api-sand.sandbox-devsecops-paas.br.experian.eeca/piaas-itil/v1/accounts/' + accountId + '/aws'

    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {iamToken}'
    }

    response = requests.get(url , verify=False, headers=headers)

    if response.status_code == 200:
        log_msg('Informações da Account AWS '+ accountId +'resgatadas com sucesso!', 'SUCCESS')
    else:
        log_msg('Não foi possivel resgatar as informações da Account AWS ' + accountId,'FAILED')
        log_msg(response.text)
        log_msg(response.status_code)
        exit(1)

    return response.json()

def getChangeOrder(changeOrder):
    if environment == "prod":
        url = 'https://piaas-itil-api-prod.devsecops-paas-prd.br.experian.eeca/piaas-itil/v1/change-orders/' + changeOrder
    else:
        url = 'https://piaas-itil-api-sand.sandbox-devsecops-paas.br.experian.eeca/piaas-itil/v1/change-orders/' + changeOrder

    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {iamToken}'
    }

    response = requests.get(url , verify=False, headers=headers)

    if response.status_code == 200:
        log_msg('Informações da Change Order '+ changeOrder +'resgatadas com sucesso!', 'SUCCESS')
    else:
        log_msg('Não foi possivel resgatar as informações da Change Order ' + changeOrder,'FAILED')
        log_msg(response.text)
        log_msg(response.status_code)
        exit(1)

    return response.json()
