from cockpit_common.common import *
from helpers.common import auth, verify_boto3
import boto3
import json
import sys

# Descomentar para puclicar no cockpit
# Variaveis de parametros
REGION = "@@AWS_REGION@@"
BU = "@@BU@@"
ACCOUNTID = "@@AWS_ACCOUNT_ID@@"
REPO_NAME = "@@REPOSITORIO@@"
IMAGES_TO_MAINTAN_IN_THE_REPO = "@@IMAGES_TO_MAINTAN@@"

# Testar Local
#REGION = "sa-east-1"
#BU = "Credit_Services"
## Modifique o campo abairo pelo ID da sua conta AWS
#ACCOUNTID = "000000000000"
## Se o campo abaixo ficar vazio, a regra eh aplicada em todos os repositorios
#REPO_NAME = ""
#IMAGES_TO_MAINTAN_IN_THE_REPO = "2"


def get_repositories(ecr_client):
    """ Return repositories """
    rs = []

    try:
        repositories = ecr_client.describe_repositories()['repositories']

        if REPO_NAME != "":
            rs = [repo for repo in ecr_client.describe_repositories()['repositories'] if repo["repositoryName"] == REPO_NAME]
        else:
            rs = repositories
    except Exception as ex:
        log_msg(f"Deu ruim {ex}", "FAILED")

    return rs


def clear_untagged(aws_account_id , ecr_client, repositories):
    """ """

    for repo in repositories:
        repoName = repo['repositoryName']

        TAGS = [imgs["imageDigest"] for imgs in ecr_client.list_images(
                   registryId=aws_account_id,
                   repositoryName=repoName,
                   filter={"tagStatus": "UNTAGGED"})["imageIds"] if imgs.get("imageDigest", "") != ""
               ]

        if len(TAGS) > 0:
            for img_dig in TAGS:
                log_msg(f"Deleting image: {img_dig} from repositorie: {repoName}", "INFO")

                rs = ecr_client.batch_delete_image(
                         registryId=aws_account_id,
                         repositoryName=repoName,
                         imageIds = [{"imageDigest": img_dig}]
                     )

                if len(rs['imageIds']) > 0:
                    for img_del in rs['imageIds']:
                        log_msg(f"Image {img_del['imageDigest']} has been deleted", "INFO")

                if len(rs['failures']) > 0:
                    for img_fail in rs['failures']:
                        log_msg(f"Error with {img_dig}, codeError: {img_fail['failureCode']}", "ERROR")


def create_lifecycle_policy(aws_account_id , ecr_client, images_to_retain, repositories):
    """ Create a LifeCycle Policy """
    rs = []
    images = int(images_to_retain)

    lifecyclePolicyText = {
        "rules": [
            {
                "rulePriority": 1,
                "description": "Expire images considering the quantity inserted",
                "selection": {
                    "tagStatus": "any",
                    "countType": "imageCountMoreThan",
                    "countNumber": images
                },
                "action": {
                    "type": "expire"
                }
            }
        ]
    }

    for repo in repositories:
        repoName = repo["repositoryName"]
        log_msg(repoName, "INFO")

        try:
            rs = ecr_client.put_lifecycle_policy(registryId=aws_account_id, repositoryName=repoName, lifecyclePolicyText=json.dumps(lifecyclePolicyText))
            log_msg(f"Policy has been included in the repositorie {repoName}", "INFO")
        except Exception as ex:
            log_msg(f"Failed in the AWS caller {ex} ", "FAILED")


if __name__=="__main__":
    if sys.version_info[0] < 3:
        log_msg("python2 detected, please use python3. Will try to run anyway", "FAILED")
    if not verify_boto3(boto3.__version__):
        log_msg(f"boto3 version {boto3.__version__}, is not valid for this script. Need 1.16.25 or higher", "FAILED")
        log_msg("please run pip install boto3 --upgrade --user", "FAILED")
        sys.exit(1)

    # Descomentar para puclicar no cockpit
    base_session = auth(ACCOUNTID, BU, REGION)

    # Testar Local
    #base_session = auth(ACCOUNTID, BU, REGION, profile="default")
    ecr_client  = base_session.client("ecr")
    repos = get_repositories(ecr_client)

    if len(repos) > 0:
        # Cleanning no taaged images
        clear_untagged = clear_untagged(ACCOUNTID, ecr_client, repos)

        ## Create Lifecycle Policy to All Repo Start with experian in the name
        create_lifecicly = create_lifecycle_policy(ACCOUNTID, ecr_client, IMAGES_TO_MAINTAN_IN_THE_REPO, repos)
    else:
        log_msg(f"REPOSITORY NOT FOUND IN AWS ECR", "WARN")
