from botocore.exceptions import ClientError
from datetime import datetime
import boto3
import json

print("Loading EKS Scale UP function")

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

def lambda_handler(event, context):

    eks            = boto3.client("eks")
    s3             = boto3.client("s3")

    bucket         = "${bucket_id}"
    obj_key        = "${obj_key}"
    cluster_name   = "${cluster_name}"

    if check_object_exists(s3, bucket, obj_key):
        data = load_s3_content(s3, bucket, obj_key)
        status = data.get("status", "")

        if status == "DOWN":
            # Loop through the node groups and update their desired capacity to 0
            if data.get("nodes", []):
                for nodegroup in data["nodes"]:
                    for nd_name in nodegroup.keys():
                        print(f"Scaling Up {nd_name} with desiredSize: {nodegroup.get(nd_name).get('desiredsize', 2)}, minSize: {nodegroup.get(nd_name).get('minsize', 1)}, maxSize: {nodegroup.get(nd_name).get('maxsize', 2)}")
                        response = eks.update_nodegroup_config(
                            clusterName=cluster_name,
                            nodegroupName=nd_name,
                            scalingConfig={
                                "desiredSize": nodegroup.get(nd_name).get("desiredsize", 2),
                                "minSize": nodegroup.get(nd_name).get("minsize", 1),
                                "maxSize": nodegroup.get(nd_name).get("maxsize", 2)
                            }
                        )

                        data["status"]    = "UP"
                        data["timestamp"] = datetime.utcnow().isoformat()
                        content           = (f"{json.dumps(data)}")

                        try:
                            s3.put_object(
                                    Bucket=bucket,
                                    Key=obj_key,
                                    Body=content)
                            print(f"EKS Nodegroup configs {bucket}/{obj_key} save successfully.")
                        except Exception as e:
                            print("Error saving EKS Nodegroup configs: {e}")
                            raise e

                        # Print the response
                        print(response)
