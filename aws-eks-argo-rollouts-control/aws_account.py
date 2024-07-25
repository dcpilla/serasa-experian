import json
import os
import sys
from cockpit_common.common import *
from piaas_itil_api_service import *
from itil import *

awsAccountId = "@@AWS_ACCOUNT_ID@@"

def validateAwsAccount():

    accountAws = getAwsAccount(awsAccountId)
    awsAccountEnv = accountAws['environment']


    if awsAccountEnv == "Production":
        log_msg('Conta Aws de  PRODUÇÃO IDENTIFICADA : '+ awsAccountId +' . Prosseguindo para processo de validação ITIL ...', 'INFO')
        validateItilChangeOrder()
    else:
        log_msg('Conta Aws NÃO PRODUTIVA: '+ awsAccountId +' . Prosseguindo sem validação ITIL ...', 'INFO')


validateAwsAccount()
