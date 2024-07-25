import json
import os
import sys
from cockpit_common.common import *
from piaas_itil_api_service import *

changeOrderId = "@@CHANGE_ORDER@@"
eksDeploymentName = "@@EKS_DEPLOYMENT_NAME@@"


def validateItilChangeOrder():

    if changeOrderId is None or changeOrderId == '':
        log_msg('CHANGE ORDER INVALIDA, FAVOR REALIZAR A CORREÇÃO NO PREENCHIMENTO DO FORMULARIO','FAILED')
        exit(1)

    changeOrder = getChangeOrder(changeOrderId)
    changeStatus = changeOrder['state']
    changeDescription = changeOrder['shortDescription']

    if changeStatus == "Closed":
        log_msg('A change '+ changeOrderId +' encontra-se no estado fechado. Prosseguindo...', 'SUCCESS')
    else:
        log_msg('Impossível prosseguir! ' + changeOrderId + ' com status diferente de Closed.','FAILED')
        exit(1)

    if eksDeploymentName not in changeDescription:
        log_msg('Impossível prosseguir! ' + changeOrderId + ' não condiz com a aplicação que esta sendo aplicado o canary deploy!','FAILED')
        exit(1)
    else:
        log_msg('A change ' + changeOrderId + ' pertence ao deployment ' + eksDeploymentName + '. Prosseguindo...', 'SUCCESS')
