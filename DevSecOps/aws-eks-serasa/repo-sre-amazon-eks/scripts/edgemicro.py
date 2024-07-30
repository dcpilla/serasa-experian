import hashlib
import json
import secrets
import sys
import time
import os.path
import base64
import subprocess
import requests

token_uri = 'https://experian.login.apigee.com/oauth/token'
edge_micro_uri = 'https://edgemicroservices.apigee.net/edgemicro/credential/organization/{}/environment/{}'

def decode_base64(enconded_value):
    return base64.b64decode(enconded_value).decode('utf-8')

def get_credentials_from_file(current_path):
    with open(current_path) as f:
        data = json.load(f)

    result = {
        'key': decode_base64(data.get('EDGEMICRO_KEY')),
        'secret': decode_base64(data.get('EDGEMICRO_SECRET'))
    }

    return result

def generate_secret():
    h = hashlib.new('sha256')
    h.update(str(time.time()).encode('utf-8'))
    h.update(secrets.token_bytes(256))
    h.update(str(time.time()).encode('utf-8'))
    return h.hexdigest()

def sha256_hash(value):
    h = hashlib.new('sha256')
    h.update(value.encode('utf-8'))
    return h.hexdigest()

def get_token(edge_usr, edge_pwd, apigee_usr, apigee_pwd):
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded'
    }
    request = {
        'username': apigee_usr,
        'password': apigee_pwd,
        'grant_type': 'password'
    }
    response = requests.post(token_uri, auth=(edge_usr, edge_pwd), data=request, headers=headers)
    assert (response.status_code == 200), '{} - {}'.format(response.status_code, response.text)
    return response.json().get('access_token')

def save_credentials(token, credentials, org, env):
    headers = {
        'Authorization': 'Bearer ' + token,
        'Content-Type': 'application/json'
    }
    uri = edge_micro_uri.format(org, env)
    response = requests.post(uri, json=credentials, headers=headers)
    assert (response.status_code == 202), '{} - {}'.format(response.status_code, response.text)
    return credentials

def create_credentials():
    # Input Query
    query = json.loads(sys.stdin.read())
    
    # Edge Micro KVM Key
    raw_key = query.get('cluster_name') + '.' + query.get('aws_account') + '.' + query.get('aws_region')

    # Look for current Microgateway credentials
    try:
        result = subprocess.call("scripts/get_current.sh {} >log 2>&1".format(query.get('cluster_name')), shell=True)
    except subprocess.CalledProcessError as cpe:
        print(cpe)
        exit(1)

    # Avoid creating credentials if already exists
    if os.path.isfile("scripts/creds.json"):
        result = get_credentials_from_file("scripts/creds.json")
        sys.stdout.write(json.dumps(result))
        exit(0)

    ## Generates Edge Micro KVM Credentials
    request_credentials = {
        'key': sha256_hash(raw_key),
        'secret': generate_secret()
    }

    # Authenticate on Apigee Edge
    token = get_token(
        query.get('edgecli_username'),
        query.get('edgecli_password'),
        query.get('apigee_username'),
        query.get('apigee_password')
    )
    
    # POST Edge Micro KVM Credentials
    credentials = save_credentials(
        token,
        request_credentials,
        query.get('apigee_org'),
        query.get('apigee_env')
    )

    # Output Result
    sys.stdout.write(json.dumps(credentials))

if __name__ == '__main__':
    create_credentials()
