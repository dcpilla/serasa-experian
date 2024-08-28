# MLOps Airflow EKS - Development Notes

## Manage DAGs files

The recommended way to update the DAGs when there are frequent changes is using the git-sync to update the DAGs.

We will use the git-sync approach without persistence, to easily scale the service.

> ref: <https://airflow.apache.org/docs/helm-chart/stable/manage-dags-files.html>

### CI/CD pipeline for the DAGs

Below is the process step-by-step of the DAG deployment for the `develop` environment. It is similar to others environments.

1. The BU's DAG repository is configured during the Airflow instalation in their AWS account;

2. Any changes at the Model or DAG, the CI pipeline for the Model/DAG will start checking the codes;

3. The CI pipeline will update the DAG with the new version of the model image;

4. Once the PR to the `develop` is merged, the  pipeline follows the normal procedures, but once it finalizes, the Airflow at the `develop` environment will get the DAG version in the `develop` branch and update it.


## Monitoring

Since we are using the Prometheus Operator, the monitoring configuration is now in the Helm Charts.
