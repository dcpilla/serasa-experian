# Helm Charts - MLOps Airflow

Helm Charts to install the MLOps Apache Airflow in EKS.

## Requirements before start

1. Kubernetes 1.20+ cluster
2. Helm 3.0+

## Generate a new version

> First time: use the command `make init` to prepare the workspace

After updating the code and testing it, you can generate a new version and push it to the repository by following the steps below:

1. Run the command `make set_airflow_version AIRFLOW_IMAGE=837714169011.dkr.ecr.sa-east-1.amazonaws.com/airflow:v2.6.3-p3.8-bookworm-9rFd_sZVRy2hUdXtpG6Mdw` to update the new Airflow version

2. Run the command `make publish` to publish the chart OR run the [Airflow - Helm Charts](https://app.harness.io/ng/account/04Iq9MDcT9WOBwwS6C4oKw/home/orgs/BRSREMLOPS/projects/coeodininfra/pipelines/Airflow_Helm_Charts/pipeline-studio/?storeType=INLINE) pipeline

3. Update the file [CHANGELOG.md](CHANGELOG.md)

4. Update the [CHANGELOG.md](../CHANGELOG.md) file for the repository

5. Commit the changes and create the `git tag` for the new version of the repository code

## Installation for tests

If you whant to test the charts before creating a new release you can install it by following the steps below:

1. Install the Airflow's helm charts repo:

   ```bash
   helm repo add apache-airflow https://airflow.apache.org
   ```

2. Install the dependency:

   ```bash
   helm dependency build helm-mlops-airflow
   ```

3. Create a value file for your environment.

4. Install the MLOps Airflow's helm charts:

   ```bash
   helm upgrade --install mlops-airflow helm-mlops-airflow/. --namespace airflow-dragon -f ./values-created-at-step-4.yaml
   ```

## Other commands

### Just create the package

If you just want to create a package to test localy you can use the command `make build`

### Check the repository

To check the MLOps Airflow repository for the versions and other configuration, use the command `make check`.

### Upgrading the Chart

To upgrade the chart with the release name ` mlops-airflow`:

    ```bash
    helm upgrade mlops-airflow apache-airflow/airflow --namespace airflow-dragon -f ./values-dragon-dev.yaml
    ```

### Uninstalling the Chart

To uninstall/delete the `airflow` deployment:

    ```bash
    helm delete mlops-airflow --namespace airflow-dragon
    ```

## Know Issues

### Absent of the CSI driver

The error message is: `error: unable to recognize "secret-provider.yaml": no matches for kind "SecretProviderClass" in version "secrets-store.csi.x-k8s.io/v1"`

The EKS cluster doesn't have the `secrets-store.csi.x-k8s.io` installed.

## References

- https://airflow.apache.org/docs/helm-chart/stable/index.html
