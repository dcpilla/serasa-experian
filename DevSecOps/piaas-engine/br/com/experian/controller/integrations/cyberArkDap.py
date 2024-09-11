#!/usr/bin/python3

import requests
import argparse
import os
import json
import urllib3
urllib3.disable_warnings()

piaasEnv = os.environ['piaasEnv']

if piaasEnv == "prod":
    devsecopsAuthURI = "https://devsecops-authentication-api-prod.devsecops-paas-prd.br.experian.eeca/devsecops-authentication/v1/orgs/login"
    cyberArkAPIURI = "https://devsecops-cyberark-api-prod.devsecops-paas-prd.br.experian.eeca/devsecops-cyberark/v1/secrets/spobrjenkins/"
else:
    devsecopsAuthURI = "https://devsecops-authentication-api-sand.sandbox-devsecops-paas.br.experian.eeca/devsecops-authentication/v1/orgs/login"
    cyberArkAPIURI = "https://devsecops-cyberark-api-sand.sandbox-devsecops-paas.br.experian.eeca/devsecops-cyberark/v1/secrets/spobrjenkins/"

def auth():

    clientId = os.environ['clientId']
    clientSecret = os.environ['clientSecret']

    payload = json.dumps({
        "clientId": clientId,
        "clientSecret": clientSecret,
    })

    headers = {
        "content-type": "application/json;charset=UTF-8"
    }

    response = requests.post(devsecopsAuthURI, headers=headers, data=payload, verify=False)

    if response.status_code != 200:
        print(response.text)
        raise Exception("[ERROR] cyberArkDap.py-> auth: Impossible to retrieve IAM JWT. See logs and try again.")

    jsonResponse = response.json()
    iamJwt = (jsonResponse["accessToken"])

    return iamJwt

def retrieve_secrets_static(iamJwt):

    safeName = set_parameters().safe
    accountName = set_parameters().cyberArkAccount

    payload = json.dumps({
        "safe": safeName,
        "accountName": accountName,
    })

    headers = {
        "content-type": "application/json;charset=UTF-8",
        "Authorization": "Bearer " + iamJwt
    }

    response = requests.post(cyberArkAPIURI + "static", headers=headers, data=payload, verify=False)

    if response.status_code != 200:
        print(response.text)
        raise Exception("[ERROR] cyberArkDap.py-> retrieve_secrets_static: Impossible to retrieve static secrets. See logs and try again.")

    print(response.text)

def retrieve_secrets_aws(iamJwt):
    safeName = set_parameters().safe
    accountName = set_parameters().cyberArkAccount
    awsAccountId = set_parameters().awsAccountId
    fqdnAccountName = accountName + "@" + awsAccountId

    payload = json.dumps({
        "safe": safeName,
        "accountName": fqdnAccountName,
    })

    headers = {
        "content-type": "application/json;charset=UTF-8",
        "Authorization": "Bearer " + iamJwt
    }

    response = requests.post(cyberArkAPIURI + "aws", headers=headers, data=payload, verify=False)

    if response.status_code != 200:
        print(response.text)
        raise Exception("[ERROR] cyberArkDap.py-> retrieve_secrets_aws: Impossible to retrieve aws secrets. See logs and try again.")

    print(response.text)

def validate_parameters(parameters):

    if parameters.safe == None:
        raise Exception("Please, inform the safe name to retrieve the secrets.")
    elif parameters.cyberArkAccount == None:
        raise Exception("Please, inform the account name to retrieve the secrets.")

def set_parameters():

    data = "Get credentials from CyberArk"

    parser = argparse.ArgumentParser(description=data)

    parser.add_argument('-s', '--safe', help='CyberArk safe name')
    parser.add_argument('-c', '--cyberArkAccount', help='CyberArk Account Name')
    parser.add_argument('-a', '--awsAccountId', help='AWS Account ID')

    validate_parameters(parser.parse_args())
    return parser.parse_args()

def checkout():

    awsParam = set_parameters().awsAccountId

    if awsParam == None:
        retrieve_secrets_static(auth())
    else:
        retrieve_secrets_aws(auth())

checkout()
