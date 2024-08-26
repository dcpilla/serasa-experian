from botocore.exceptions import ClientError
from datetime import datetime
import boto3
import json
import time

print("Loading EKS Scale Down karpenter function")

def get_nodegroup_info(eks, cluster_name, node_name):
    """
    Load nodegroup info
    """
    node = eks.describe_nodegroup(
        clusterName = cluster_name,
        nodegroupName = node_name
    )['nodegroup']

    return node

def get_update_status(eks, cluster_name, node_name):
    """ Check nodegroup status """

    while True:
        # Check nodegroup status
        status = get_nodegroup_info(eks, cluster_name, node_name=node_name).get("status")

        if status == "ACTIVE":
            print(f"Node Group [{node_name}] has been UPDATED!", "SUCCESS")
            return status
            break

        time.sleep(60)

def lambda_handler(event, context):

    eks            = boto3.client("eks")
    ec2            = boto3.client("ec2")
    cluster_name   = "${cluster_name}"

    cluster        = eks.describe_cluster(
                       name = cluster_name
                   )["cluster"]
    cluster_status = cluster["status"].upper()
    node_infra = {}

    if cluster_status == "ACTIVE":
        for nodegroup in eks.list_nodegroups(clusterName = cluster_name)["nodegroups"]:
          ng = get_nodegroup_info(eks, cluster_name, nodegroup)
          current_tags = ng["tags"]

          if ng["status"].upper() == "ACTIVE":

              if current_tags.get("Worker", "") == "infra":
                  node_infra = ng

    if node_infra:
        status = get_update_status(eks, cluster_name, node_infra["nodegroupName"])

        if status == "ACTIVE":
            # Karpenter nodes
            if cluster["tags"].get("KarpenterSetupOn", ""):
                print("Search and remove ec2 karpenter instance")
                ec2_karpenter = ec2.describe_instances(
                        Filters = [
                            {
                                "Name": "tag:karpenter.sh/nodepool",
                                "Values": ["*"]
                            },
                            {
                                "Name": "tag:aws:eks:cluster-name",
                                "Values": [cluster_name]
                            }
                        ]
                )

                # Processing and temrinate the instances
                instances_to_terminate = []
                for reservation in ec2_karpenter["Reservations"]:
                    for instance in reservation["Instances"]:
                        instances_to_terminate.append(instance["InstanceId"])

                if instances_to_terminate:
                    print(f"Terminating the karpenter following instances: {instances_to_terminate}")
                    ec2.terminate_instances(InstanceIds=instances_to_terminate)
                else:
                    print(f"No instances karpenter {instances_to_terminate} found")

