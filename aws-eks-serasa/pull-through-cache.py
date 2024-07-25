#!/bin/env python3

import sys
import os
import boto3

def parse_docker_images(image_list):
    parsed_data = {}
    for image in image_list:
        repo_name, tag = image.split(":")
        if repo_name not in parsed_data:
            parsed_data[repo_name] = {"tags": []}
        parsed_data[repo_name]["tags"].append(tag)
    
    return parsed_data

def create_ecr_repository(repo_name):
    try:
        ecr_client.create_repository(
            repositoryName=repo_name,
            imageTagMutability='MUTABLE',
            imageScanningConfiguration={
                'scanOnPush': True
            },
            encryptionConfiguration={
                'encryptionType': 'AES256'
            }
        )
        print(f"Created ECR repository: {repo_name}")
    except ecr_client.exceptions.RepositoryAlreadyExistsException:
        print(f"ECR repository already exists: {repo_name}")

def check_ecr_image_tag(repo_name, tag):
    try:
        ecr_client.describe_images(repositoryName=repo_name, imageIds=[{'imageTag': tag}])
        print(f"Image tag exists in ECR: {repo_name}:{tag}")
        return True
    except ecr_client.exceptions.ImageNotFoundException:
        print(f"Image tag does not exist in ECR: {repo_name}:{tag}")
        return False

# Read the list of Docker images from STDIN pipe
docker_images = sys.stdin.read().splitlines()

parsed_result = parse_docker_images(docker_images)

# Print the parsed data
for repo, data in parsed_result.items():
    print(f"Repository: {repo}")
    print(f"Tags: {data['tags']}")
    print()

# Initialize AWS ECR client
region = os.environ.get('REGION', 'sa-east-1')
ecr_client = boto3.client('ecr', region_name=region)  # Replace with your desired region

# Iterate over parsed data and reflect to AWS ECR
final_list = []
for repo, data in parsed_result.items():
    docker_repo = 'docker-hub/' + repo
    
    create_ecr_repository(docker_repo)
    for tag in data["tags"]:
        if check_ecr_image_tag(docker_repo, tag) == False or tag == 'latest':
            final_list.append("{}:{}".format(repo, tag))

with open('docker-images-to-pull.list', 'w') as file:
    for item in final_list:
        file.write(item + '\n')