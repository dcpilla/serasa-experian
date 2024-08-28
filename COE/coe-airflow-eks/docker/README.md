# Airflow for EKS - Docker base

Here are the code to create the images used by our installation. The idea is to have the images in our ECRs, not downloading public images.

The ECR repositories are created by the IaC for the MLOps Operations accounts (<https://code.experian.local/projects/CDEAMLO/repos/coe-operations-infra/browse>)

## New Releases

The folder `airflow-base` has the code to generate the image base used to create our `airflow` image. We chose to create a [customized image](https://airflow.apache.org/docs/docker-stack/build.html#customizing-the-image) to solve container issues.

The folders `airflow`, `airflow-git-sync` and `airflow-mount-secrets` are the default images used by the MLOps Airflow Helm Charts.

You can update and create new versions by following the procedures below:

1. Enter in the respective folder
2. Change the `Dockerfile`
3. Update the file `.version`
4. Execute the command `make publish`

### Using the Harness CI

After change the files in the steps above and push the code, run the [Airflow - Docker Image](https://app.harness.io/ng/account/04Iq9MDcT9WOBwwS6C4oKw/home/orgs/BRSREMLOPS/projects/Operations/pipelines/Airflow_Docker_Image/pipeline-studio/?storeType=INLINE) pipeline

## Custom Airflow images

If you face a case that will need to create a custom Airflow image, I suggest to follow the steps below:

1. Copy the folder `airflow`, creating a new folder `airflow-${PROJECT_NAME}`
2. Create a new repository for the project in the MLOps Operations environment: <https://code.experian.local/projects/CDEAMLO/repos/coe-operations-infra/browse/tf/airflow-infra?at=refs%2Fheads%2Fdevelop>
3. Update the `Dockerfile`
4. Update the `Makefile`, configuring the ECR repository for the custom version

After releasing the new image, you will need to customize the values/values-${ENV}.yaml of the terraform installation adding the following block:

```yaml
airflow:
  images:
    airflow:
      repository: 837714169011.dkr.ecr.sa-east-1.amazonaws.com/airflow-${PROJECT_NAME}
      tag: ${VERSION}
```

