from cockpit_common.common import *
import base64
import boto3
import json
import os
import re
import subprocess
import sys
from helpers.common import ( 
    auth,
    check_update_is_necessary,
    get_latest_ami,
    get_nodegroup_info,
    get_update_status,
    get_vpc_cni_version,
    verify_boto3
)

# Variaveis de parametros
REGION = "{{aws_region}}"
ACCOUNTID = "{{account_id}}"
BU = "{{bu}}"
ENV = "{{account_environment}}"
TAG_ENV = {
    "dev": "dev",
    "test": "tst",
    "staging": "stg",
    "uat": "uat",
    "sandbox": "sbx",
    "prod": "prd"
}
TAGS = {
    "CostString": "{{account_ccosting}}",
    "AppID": "{{account_apid}}",
    "Environment": "{{account_environment}}",
    "adDomain":"br.experian.local"
}
AMIID = "{{ami_id}}"
EKS_CLUSTER_NAME = "{{eks_cluster_name}}"
EKS_NODE_NAME = "{{eks_nodegroup_name}}"


def check_ami_update_is_necessary(ec2_client, ami_id, eks_client):
    """ Validation if AMI update is necessary """

    nodegroup   = get_nodegroup_info(eks_client, EKS_CLUSTER_NAME, node_name=EKS_NODE_NAME)
    cni_version = get_vpc_cni_version(eks_client, eks_version=nodegroup.get("eks_version"), instance_type=(nodegroup.get("instance_types") or ["m5.xlarge"])[0])
    latest_ami  = get_latest_ami(ec2_client, ami = ami_id, eks_version = nodegroup.get("eks_version"))

    check_update_is_necessary(nodegroup, latest_ami)

    nodegroup["latest_ami"] = latest_ami.get("ImageId")
    nodegroup["max_pods"] = cni_version.get("max_pods", "44")

    if  nodegroup.get("latest_ami") ==  nodegroup.get("ami"):
        print("")
        log_msg("Your AMI is already the latest.", "WARN")
    else:
        log_msg("Starting update", "INFO")
    return nodegroup

def create_ami_template(ec2_client, ami_info, nodegroup_template_id):
    template = ec2_client.describe_launch_template_versions(LaunchTemplateId=nodegroup_template_id)
    new_template_version = {}

    template_default_version = ami_info.get("template_version") 
    template_tags = [tpl_default.get("LaunchTemplateData").get("TagSpecifications") for tpl_default in template.get('LaunchTemplateVersions') if tpl_default.get("DefaultVersion") is True][0]

    user_data = [tpl_default.get("LaunchTemplateData").get("UserData") for tpl_default in template.get('LaunchTemplateVersions') if tpl_default.get("DefaultVersion") is True][0]

    # Adjusting TAGS
    for tpl_tags in template_tags:
        if tpl_tags.get("ResourceType") in ["instance", "volume", "network-interface"]:
            for tg in TAGS:
                if not tg in [tpl_keys.get("Key") for tpl_keys in tpl_tags.get("Tags")]:
                    tpl_tags.get("Tags").append({'Key': tg, 'Value': TAGS[tg]})
                elif tg in [tpl_keys.get("Key") for tpl_keys in tpl_tags.get("Tags")]:
                    for tgs in tpl_tags.get("Tags"):
                        if tgs.get("Key") == tg:
                            tgs.update({'Key': tg, 'Value': TAGS[tg]})

    user_data_changes = [
        {'pattern': r'--max-pods=(\d+)', 'to': f'--max-pods={ami_info.get("max_pods")}'},
        #{'pattern': r'--use-max-pods false', 'to': '--use-max-pods true'}
    ]

    if ami_info["status"] == "DEGRADED":
        if ami_info["health_code"] != "":
            log_msg("Have a problem with this NODE!", "FAILED")
            log_msg(f"Code: {ami_info['health_code']}", "FAILED")
            log_msg(f"Message: {ami_info['health_message']}", "FAILED")
        sys.exit(1)
    else:
        # create a new template
        new_template = ec2_client.create_launch_template_version(
            LaunchTemplateId = nodegroup_template_id,
            SourceVersion = template_default_version,
            VersionDescription = f"AWS UPDATE EKS AMI FROM {ami_info.get('ami')} TO  {ami_info.get('latest_ami')}",
            LaunchTemplateData = {
                "UserData": str(fix_userdata(user_data, changes=user_data_changes).decode("utf-8")),
                "ImageId": ami_info.get("latest_ami"),
                "TagSpecifications": template_tags
            }
        )
       
    if new_template.get("LaunchTemplateVersion"):
        new_template_version["new_version"] = new_template.get("LaunchTemplateVersion").get("VersionNumber")
        new_template_version["old_version"] = template_default_version

        # Set a new template version on node
        new_template_default = ec2_client.modify_launch_template(
            LaunchTemplateId = f"{nodegroup_template_id}",
            DefaultVersion = f"{new_template_version['new_version']}"
        )
        log_msg(f"New Launch template (version: {new_template_version['new_version']}) has been created!", "SUCCESS")
        log_msg(f"Template {nodegroup_template_id} using default version {new_template_version['new_version']}", "SUCCESS")
    
        return new_template_version

def fix_userdata(data, changes=[]):
    """ Fix user data """
    user_data = base64.b64decode(bytes(data, "utf-8"))
    new_user_data = ""
    out_user_data = ""

    if changes:
        new_user_data = user_data

        for chg in changes:
            pattern = chg['pattern']
            subs = chg['to']

            new_user_data = bytes(re.sub(pattern, subs, new_user_data.decode("utf-8")), "utf-8")

    if new_user_data:
        out_user_data = base64.b64encode(new_user_data)
    else:
        out_user_data = base64.b64encode(user_data)

    return out_user_data 

def fix_eks_role(ec2_client, sg_id):
    """ Fix eks role """

    hasRule = ec2_client.describe_security_groups(
        Filters = [
            {"Name": "group-id", "Values": [sg_id]},
            {"Name": "ip-permission.protocol", "Values": ["-1"]}
        ],
        GroupIds = [sg_id],
    )["SecurityGroups"]

    if not hasRule:
        sg_rule = ec2_client.authorize_security_group_ingress(
            GroupId = sg_id,
            IpPermissions = [
                {
                    "IpProtocol": "-1",
                    "IpRanges" : [],
                    "Ipv6Ranges": [],
                    "PrefixListIds": [],
                    "UserIdGroupPairs": [
                        {
                            "GroupId": sg_id,
                            "Description": "EKS SG"
                        }
                    ]
                }
            ]
        )

        log_msg(f"Add rules to security group of EKS node", "SUCCESS")

def upt_nodegroup_version(eks_client, eks_cluster_name, eks_node_name, ami_template_version, template_id):
    """ """ 
    log_msg(f"Updating node group [{eks_node_name}] on EKS [{eks_cluster_name}]", "INFO") 
    upt = eks_client.update_nodegroup_version(
        clusterName = f"{eks_cluster_name}",
        nodegroupName = f"{eks_node_name}",
        launchTemplate = {
            "version": f"{ami_template_version['new_version']}",
            "id": f"{template_id}"
        },
        force=True
    )

def clean_old_tpls(eks_client, ec2_client, autoscaling_client, EKS_CLUSTER_NAME, EKS_NODE_NAME, nodegroup_template_id, ami_template_version):
    template = ec2_client.describe_launch_template_versions(LaunchTemplateId=nodegroup_template_id)

    if len(template.get('LaunchTemplateVersions')) >2:
        for tpl in template.get('LaunchTemplateVersions'):
            if not tpl.get("DefaultVersion") is True:
                if not str(tpl.get("VersionNumber")) in [str(ami_template_version['new_version']), str(ami_template_version['old_version'])]:
                    print(f"Removing old launch template version {tpl.get('VersionNumber')}", "WARN")
                    tpl_rm_version = ec2_client.delete_launch_template_versions(
                        LaunchTemplateId = nodegroup_template_id,
                        Versions = [f"{tpl.get('VersionNumber')}"]
                    )["SuccessfullyDeletedLaunchTemplateVersions"]

                    if len(tpl_rm_version) >0:
                        print(f"Version {tpl.get('VersionNumber')} of launch template, has been removed!", "SUCCESS")

if __name__=="__main__":
    if sys.version_info[0] < 3:
        log_msg("python2 detected, please use python3. Will try to run anyway", "FAILED")
    if not verify_boto3(boto3.__version__):
        log_msg(f"boto3 version {boto3.__version__}, is not valid for this script. Need 1.16.25 or higher", "FAILED")
        log_msg("please run pip install boto3 --upgrade --user", "FAILED")
        sys.exit(1)

    base_session = auth(ACCOUNTID, BU, REGION, profile="sts_cli")
    ec2_client          = base_session.client("ec2")
    eks_client          = base_session.client("eks")
    autoscaling_client  = base_session.client("autoscaling")

    if not AMIID:
        AMIID = "latest"

    is_necessary = check_ami_update_is_necessary(ec2_client, AMIID, eks_client)
    ami_template_version = create_ami_template(ec2_client, is_necessary, is_necessary.get("template_id"))
    fix_eks_role(ec2_client, is_necessary.get('eks_sg'))

    # Update node
    upt_nodegroup = upt_nodegroup_version(eks_client, EKS_CLUSTER_NAME, EKS_NODE_NAME, ami_template_version, is_necessary.get("template_id")) 
    is_updated = get_update_status(eks_client, EKS_CLUSTER_NAME, EKS_NODE_NAME)

    if is_updated == "ACTIVE":
        # Remove old templates
        clean_old_tpls(eks_client, ec2_client, autoscaling_client, EKS_CLUSTER_NAME, EKS_NODE_NAME, is_necessary.get("template_id"), ami_template_version)

###SDG###        
