print(">>>> Started pre-flight.p <<<<y")
print('>>>> import libs <<<<')
import boto3, sys
from cockpit_common.common import *
from helpers.common import verify_boto3, auth

print('>>>> Set Variables  <<<<')
# REGION = "sa-east-1"
# ACCOUNTID = "664573052825"
# BU = "EITS"
REGION = "{{account_region}}"
ACCOUNTID = "{{account_id}}"
BU = '{{account_bu}}'

print('>>>> check_if_cluster_exists  <<<<')
def check_if_cluster_exists(eks_client):
    api_clusters = eks_client.list_clusters()
    if api_clusters['ResponseMetadata']['HTTPStatusCode'] != 200:
        raise Exception("EKS_ListClusters != 200")
    
    clusters = api_clusters['clusters']
    return "{{eks_name}}" in clusters

def fatal_error_exit(message):
    print("***************************************************************************************************************")
    print("***************************************************************************************************************")
    print("*** {}".format(message))
    print("***************************************************************************************************************")
    print("***************************************************************************************************************")
    sys.exit(1)

if __name__=="__main__":
    if sys.version_info[0] < 3:
        log_msg("python2 detected, please use python3. Will try to run anyway", "FAILED")
    if not verify_boto3(boto3.__version__):
        log_msg("boto3 version {}, is not valid for this script. Need 1.16.25 or higher".format(boto3.__version__), "FAILED")
        log_msg("please run pip install boto3 --upgrade --user", "FAILED")
        sys.exit(1)

    print("This is a pre-flight script for aws-eks-serasa")

    base_session = auth(ACCOUNTID, BU, REGION, profile="{{account}}")
    eks_client = base_session.client("eks")

    print('>>>><<<<')
    print('Current Version Selected : >>>>>> {{eks_version}} <<<<<<')
    print('>>>><<<<')
    print('aqui variavel base_session ', base_session)
    print('>>>><<<<')
    print('aqui variavel eks_client ', eks_client)

    if check_if_cluster_exists(eks_client) == False and "{{eks_version}}" == "1.24":
        fatal_error_exit("ERRO FATAL: Nao eh possivel provisionar novos clusters na versao 1.24!!!")
    print('##################')
    print('##################')
    print(">>>> Finished pre-flight.py and Proceeding to Terraform plan+apply <<<<")
    print('##################')
    print('##################')


    
