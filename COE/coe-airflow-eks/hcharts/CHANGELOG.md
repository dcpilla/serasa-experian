# Changelog

All notable changes to the MLOps Airflow Helm Charts package will be documented in this file.

We agreed to keep a tag version related to each Airflow version.

Remember, when creating a new version you also need to create the relative tag for it in the format `helm-mlops-airflow-vSEMVER`.

## Changelog for Helm Charts Airflow 2.6.x

Here is the list of changes made for the Helm Charts with support for Airflow 2.6.x

### [2.6.0]

#### Added
- Starting new versioning strategy for Helm Charts
- New tag format in the repo: `helm-mlops-airflow-v2.6.0`

## Changelog for Helm Charts Airflow 2.7.x

Here is the list of changes made for the Helm Charts with support for Airflow 2.7.x

### [2.7.5]

#### Added
- Update the gitsync image tag.
- Add a custom fernetkey installation with a secrets manager to avoid argoCD pre-install hook change the secret value on each update
- Update git-sync image v1.0.1__linux_amd64
- Private repos to Pgbouncer and statsd images

### [2.7.4]

#### Added
- Fix worker pods evicting adding the `safe-to-evict` annotation.

### [2.7.3]

#### Added
- Fix error `err="secret type is empty"` for secret `mlops-airflow-webconfig-spc`

### [2.7.1]

#### Added
- Add `resources` and `tolerations` configs for `triggerer`, `webserver`, `scheduler`, `worker`
- Add `podDisruptionBudget` for `webserver` and `scheduler`
- Disable `safeToEvict` for the `workers` 
- Default `defaultAirflowTag` for this version is `v2.7.3-p3.11-bookworm-j6yDP0pyTui7_gypNYPyyw-temp`
- New tag format in the repo: `helm-mlops-airflow-v2.7.1`
- Fix secrets names by removing the `dragon` string

### [2.7.0]

#### Added
- Starting new versioning strategy for Helm Charts
- New tag format in the repo: `helm-mlops-airflow-v2.7.0`

## Older Changelogs

### [0.6.2]

#### Added
- Adding new version of helm with Redis Cache Library installed in the airflow image 2.7.3

### [0.6.1]

#### Added
- Adding new version of helm with astronomer-cosmos installed in the airflow image 2.7.3

### [0.6.0]

#### Added
- Adding new version of helm with astronomer-cosmos installed in the airflow image 2.7.2

### [0.5.9]

#### Added
- Adding new version of helm with Mysql and Cassandra provider installed in the airflow image

### [0.5.8]

#### Added
- Added option "grantAdminsRights" to grant of not admin rights to Airflow service account when the create is set to true

### [0.5.5]

#### Added
- New airflow version 2.7.2
- Update helm chart 0.5.5
- Harden the configuration to securely store LOGS in an S3 bucket

### [0.3.5]

#### Added
- Adding fix to airflow regarding the mysql provider.
- Adding tag following new model (airflow version + image tag)

### [0.3.4]

#### Added
- Adding new version of helm with Mysql provider installed in the airflow image

### [0.3.3]

#### Added
- New airflow version 2.7.2
- Update helm chart 0.5.5
- Harden the configuration to securely store LOGS in an S3 bucket

### [0.3.3]

#### Added
- Adding new version of helm with Cassandra provider installed in the airflow image

### [2.6.3-p2]

#### Added
- Change release tag to help in identify the Airflow version being used
- Fix Airflow version to v2.6.3

### [0.3.2]

#### Added
- Upgrade Airflow module istio add rule at Istio ALB to redirects automatically the Airflow DNS that uses HTTP otherwise HTTPS

### [0.3.1]

#### Added
- Upgrade Airflow Image without vulnerabilities v2.6.3 with python3.8

### [0.3.0]
#### Added
- ...

### [0.3.1]

#### Added
- Upgrade Airflow Image without vulnerabilities v2.6.3 with python3.8

### [0.3.0]

#### Added
- Upgrade Airflow Image without vulnerabilities `v2.6.2-01` with python3.8
- Upgrade git-sync and mount-secrets images fixing vulnerabilities

### [0.2.1]

#### Added
- Updated Airflow image to version `v2.5.3-02`
- Updated Airflor Charts to version `1.9.0`

### [0.2.0]

#### Added
- Updated Airflow image to version `v2.5.3-01`

### [0.1.4]

#### Added
- Added `apache-airflow-providers-apache-spark` to the Airflow container image
- Added `apache-airflow-providers-common-sql` to the Airflow container image
- Added `apache-airflow-providers-apache-hive` to the Airflow container image
- Updated Airflow image to version `v2.3.3-02`

### [0.1.3]

#### Added
- Added StatsD mappings
- Added Grafana Dashboard for Cluster and DAGs

### [0.1.2]

#### Added
- Added new variable to get AWS secret manager names
  secretmanager:
  datasource: ""
  websecretkey: ""
  gitsshprivkey: ""
  webserverconfig: ""
- Create new secrect provider for webserver_config.py
- Mount new secrect provider webserver_config.py using direct Airflow values

### [0.1.1]

#### Added
- Update pattern of the secrets names
- Add ServiceMonitor to send metrics to Prometheus

### [0.1.0]

#### Added
- Initial Release
- Log level configuration

### [0.0.18]

#### Features
- Initial BETA Release
