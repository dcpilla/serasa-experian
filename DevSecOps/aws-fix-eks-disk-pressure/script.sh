#!/bin/bash

aws_region=@@AWS_REGION@@
aws_account_id=@@AWS_ACCOUNT_ID@@
nodegroup=@@EKS_NODEGROUP_NAME@@
cluster_name=@@EKS_CLUSTER_NAME@@
template_id=@@EKS_NODEGROUP_TEMPLATE_ID@@
new_disk_size=@@EKS_NODEGROUP_INSTANCE_DISK_SIZE@@


export AWS_REGION=$aws_region


echo "Assuming role BURoleForDevSecOpsServiceCatalog..."

assumed_role=$(aws sts assume-role --role-arn arn:aws:iam::$aws_account_id:role/BURoleForDevSecOpsServiceCatalog --role-session-name DevSecOpsServiceCatalog)

export AWS_ACCESS_KEY_ID=$(echo $assumed_role | jq -r '.Credentials''.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $assumed_role | jq -r '.Credentials''.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $assumed_role | jq -r '.Credentials''.SessionToken')



echo "Getting latest version of launch template $template_id ..."

template=$(aws ec2 describe-launch-template-versions --launch-template-id $template_id)
template_version=$(echo $template | jq -r '.LaunchTemplateVersions[0]''.VersionNumber')
storage=$(echo $template | jq -r '.LaunchTemplateVersions[0]''.LaunchTemplateData''.BlockDeviceMappings // empty')

if [[ ! -z "$storage" ]]; then
	
	echo "Changing already configured storage to $new_disk_size GB..."
	storage=$(echo $storage | jq -r ".[0].Ebs.VolumeSize = $new_disk_size")
		
else
	
	echo "Creating new storage configuration with $new_disk_size GB..."
	storage='[{"DeviceName":"/dev/xvdb","Ebs":{"Encrypted":true,"DeleteOnTermination":true,"VolumeSize":'${new_disk_size}',"VolumeType":"gp2"}}]'
	
fi



echo "Creating new version of launch template..."

new_template=$(aws ec2 create-launch-template-version --launch-template-id $template_id --source-version $template_version --version-description 'Disk Pressure Fix' --launch-template-data "{\"BlockDeviceMappings\": $storage}")
new_template_version=$(echo $new_template | jq -r '.LaunchTemplateVersion''.VersionNumber')
new_template_default=$(aws ec2 modify-launch-template --launch-template-id $template_id --default-version $new_template_version)



echo "Updating node group [$nodegroup] on EKS [$cluster_name]..."

aws eks update-nodegroup-version --force --cluster-name $cluster_name --nodegroup-name $nodegroup --launch-template version=$new_template_version,id=$template_id

echo "Done"