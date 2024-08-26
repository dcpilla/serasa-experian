from botocore.exceptions import ClientError
from datetime import datetime
import boto3
import json

print("Loading EKS Scale Down function")

def check_object_exists(s3, bucket, obj_key):
    """ Check Object exists """
    print(f"checking if the object {obj_key} exists in the bucket {bucket}")

    try:
        s3.head_object(Bucket=bucket, Key=obj_key)
        return True
    except ClientError as e:
        if e.response["Error"]["Code"] == "404":
            print(f"Object {obj_key} not found in bucket {bucket}")
            return False
        raise

def load_s3_content(s3, bucket, obj_key):
    """ Load json content """
    # Download obj
    resp_s3 = s3.get_object(Bucket=bucket, Key=obj_key)

    # Read file
    content = resp_s3["Body"].read().decode("utf-8")

    # Convert to JSON
    data = json.loads(content)

    return data

def get_nodegroup_info(eks, cluster_name, node_name):
    """
    Load nodegroup info
    """
    node = eks.describe_nodegroup(
        clusterName = cluster_name,
        nodegroupName = node_name
    )['nodegroup']

    return node


def lambda_handler(event, context):

    eks            = boto3.client("eks")
    s3             = boto3.client("s3")
    ec2            = boto3.client("ec2")

    bucket         = "${bucket_id}"
    obj_key        = "${obj_key}"
    cluster_name   = "${cluster_name}"
    nodegroup_info = {"timestamp": f"{datetime.utcnow().isoformat()}", "status": "DOWN", "nodes": []}

    cluster        = eks.describe_cluster(
                       name = cluster_name
                   )["cluster"]
    cluster_status = cluster["status"].upper()

    if cluster_status == "ACTIVE":
        for nodegroup in eks.list_nodegroups(clusterName = cluster_name)["nodegroups"]:
          ng = get_nodegroup_info(eks, cluster_name, nodegroup)
          current_tags = ng["tags"]
          current_tags["node_autoscaling"] = "true"

          if ng["status"].upper() == "ACTIVE":
              scaling_cfg = ng["scalingConfig"]

              nodegroup_info["nodes"].append({nodegroup: {
                                     "minsize": scaling_cfg["minSize"],
                                     "maxsize": scaling_cfg["maxSize"],
                                     "desiredsize": scaling_cfg["desiredSize"]
                                     }})

              print(f"Updating tags in the node {nodegroup_info}")
              eks.tag_resource(
                  resourceArn=ng["nodegroupArn"],
                  tags = current_tags
              )

    content    = (f"{json.dumps(nodegroup_info)}")

    # Loop through the node groups and update their desired capacity to 0
    if nodegroup_info.get("nodes", []):
        for nd in nodegroup_info["nodes"]:
            for nd_name in nd.keys():
                response = eks.update_nodegroup_config(
                    clusterName=cluster_name,
                    nodegroupName=nd_name,
                    scalingConfig={
                        "desiredSize": 0,
                        "minSize": 0,
                        "maxSize": 1
                    }
                )

        if check_object_exists(s3, bucket, obj_key):
            data = load_s3_content(s3, bucket, obj_key)
            status = data.get("status", "")

            if status != "DOWN":
                try:
                    s3.put_object(
                            Bucket=bucket,
                            Key=obj_key,
                            Body=content)
                    print(f"EKS Nodegroup configs {bucket}/{obj_key} save successfully.")
                except Exception as e:
                    print("Error saving EKS Nodegroup configs: {e}")
                    raise e
        else:
                try:
                    s3.put_object(
                            Bucket=bucket,
                            Key=obj_key,
                            Body=content)
                    print(f"EKS Nodegroup configs {bucket}/{obj_key} save successfully.")
                except Exception as e:
                    print("Error saving EKS Nodegroup configs: {e}")
                    raise e
