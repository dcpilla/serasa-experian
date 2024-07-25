import boto3, sys
from cockpit_common.common import *
from helpers.common import verify_boto3, auth

# REGION = "sa-east-1"
# ACCOUNTID = "664573052825"
# BU = "EITS"
REGION = "@@AWS_REGION@@"
ACCOUNTID = "@@AWS_ACCOUNT_ID@@"
BU = "@@BU@@"

def check_if_cluster_exists(eks_client):
    api_clusters = eks_client.list_clusters()
    if api_clusters['ResponseMetadata']['HTTPStatusCode'] != 200:
        raise Exception("EKS_ListClusters != 200")
    
    clusters = api_clusters['clusters']
    return "@@EKS_CLUSTER_NAME@@-@@ENV@@" in clusters

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

    base_session = auth(ACCOUNTID, BU, REGION)
    eks_client = base_session.client("eks")

    # TODO verificar se no_proxy está auto e fazer chamada de teste para validar conectividade

    if check_if_cluster_exists(eks_client) == False:
        if "@@EKS_CLUSTER_VERSION@@" == "1.24" or "@@EKS_CLUSTER_VERSION@@" == "1.25":
            fatal_error_exit("FATAL: cannot provision EKS cluster under version 1.26 !!!")
        print("Cluster will be created")
    else:
        # TODO verificar se existe OIDC provider que não está inserido no tfstate e importar
        print("Cluster exists, will be updated")

    print("Proceeding with Terraform plan+apply")

    