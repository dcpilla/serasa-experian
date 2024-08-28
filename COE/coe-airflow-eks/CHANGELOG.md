# Changelog

All notable changes to this project will be documented in this file.

## [v3.0.1] (https://code.experian.local/projects/CDEAMLO/repos/coe-airflow-eks/browse?at=refs%2Ftags%2Fv3.0.1)  (2024-06-16)

### Features
- Update Charts to version `2.7.5`
- Fernet key deploy with a secrets manager
- Update git-sync image v1.0.1__linux_amd64
- Private repos to Pgbouncer and statsd images

## [v3.0.0](https://code.experian.local/projects/CDEAMLO/repos/coe-airflow-eks/browse?at=refs%2Ftags%2Fv3.0.0) (2024-04-29)

### Changes
- Start a major version of the repository code
- Remove unused code `monitoring-config`

### Features
- Update the versioning strategy for Helm Charts

## [v2.7.3-p3.11-bookworm-j6yDP0pyTui7_gypNYPyyw-temp] (https://code.experian.local/projects/CDEAMLO/repos/coe-airflow-eks/browse?at=refs%2Ftags%2Fv2.7.3-p3.11-bookworm-j6yDP0pyTui7_gypNYPyyw) (2024-04-19)

### Features
- Added Redis Cache Library to the Airflow image

## [v2.7.2-p3.11-bookworm-w4Guj6LVSb2VihC0ukeR-g](https://code.experian.local/projects/CDEAMLO/repos/coe-airflow-eks/browse?at=refs%2Ftags%2Fv2.7.2-p3.11-bookworm-w4Guj6LVSb2VihC0ukeR-g) (2024-02-07)

### Features

- Update Charts to version `0.5.9`
- Adding new version of helm with Mysql and Cassandra provider installed in the airflow image

## [v2.7.2-p3.11-bookworm](https://code.experian.local/projects/CDEAMLO/repos/coe-airflow-eks/browse?at=refs%2Ftags%2Fv2.7.2-p3.11-bookworm) (2024-01-09)

### Features

- Update Charts to version `0.5.8`
- New airflow version 2.7.2
- Harden the configuration to securely store LOGS in an S3 bucket
- Changed git tag naming convention

## [v2.7.2-p3.11-bookworm](https://code.experian.local/projects/CDEAMLO/repos/coe-airflow-eks/browse?at=refs%2Ftags%2Fv2.7.2-p3.11-bookworm) (2024-01-09)

### Features

- Update Charts to version `0.5.8`
- New airflow version 2.7.2
- Harden the configuration to securely store LOGS in an S3 bucket
- Changed git tag naming convention

## [v0.3.3](https://code.experian.local/projects/CDEAMLO/repos/coe-airflow-eks/browse?at=refs%2Ftags%2Fv0.3.3) (2023-11-10)

### Features

- Update Charts to version `2.6.3-p2`
- Add custom imagem with Cassandra Provider

## [v0.3.2](https://code.experian.local/projects/CDEAMLO/repos/coe-airflow-eks/browse?at=refs%2Ftags%2Fv0.3.2) (2023-10-20)

### Features

- Update Charts to version `0.3.2`
- Add rule at Istio ALB to redirects automatically the Airflow DNS that uses HTTP otherwise HTTPS

## [Unreleased]

### Next Features (suggestion)

- Add alerts in the alertmanager

## [v0.3.1](https://code.experian.local/projects/CDEAMLO/repos/coe-airflow-eks/browse?at=refs%2Ftags%2Fv0.3.0) (2023-07-19)

### Features

- Update Charts to version `0.3.1`
- Update Airflow to 2.6.3
- Update documentation

## [v0.3.0](https://code.experian.local/projects/CDEAMLO/repos/coe-airflow-eks/browse?at=refs%2Ftags%2Fv0.3.0) (2023-07-06)

### Features

- Update Charts to version `0.3.0`
- Update Airflow to 2.6.2
- Update documentation

## [v0.2.0](https://code.experian.local/projects/CDEAMLO/repos/coe-airflow-eks/browse?at=refs%2Ftags%2Fv0.2.0) (2023-05-03)

### Features

- Update Charts to version `0.2.1`
- Update Airflow to 2.5.3
- Update documentation

## [v0.1.0](https://code.experian.local/projects/CDEAMLO/repos/coe-airflow-eks/browse?at=refs%2Ftags%2Fv0.1.0) (2023-04-25)

### Features

- Update Charts to version `0.1.4`
- Change Docker Image version to the format `${airflow-version}-${buildn}`
- Update documentation

## [v0.0.5](https://code.experian.local/projects/CDEAMLO/repos/coe-airflow-eks/browse?at=refs%2Ftags%2Fv0.0.5) (2023-03-22)

### Features

- Update Charts to version `0.1.3`

## [v0.0.4](https://code.experian.local/projects/CDEAMLO/repos/coe-airflow-eks/browse?at=refs%2Ftags%2Fv0.0.4) (2023-03-10)

### Features

- Update Charts to version `0.1.2`
- Add changelog file for helm charts
- Update documentation

## [v0.0.3](https://code.experian.local/projects/CDEAMLO/repos/coe-airflow-eks/browse?at=refs%2Ftags%2Fv0.0.3) (2023-03-06)

### Features

- Update Charts to version `0.1.1`
- Update pattern of the secrets names
- Add ServiceMonitor to send metrics to Prometheus

## [v0.0.2](https://code.experian.local/projects/CDEAMLO/repos/coe-airflow-eks/browse?at=refs%2Ftags%2Fv0.0.2) (2023-01-16)

### Features

- Update Charts to version `0.1.0`
- Add changelog file for helm charts
- Update documentation

## [v0.0.1](https://code.experian.local/projects/CDEAMLO/repos/coe-airflow-eks/browse?at=refs%2Ftags%2Fv0.0.1) (2023-01-13)

### Features

- Initial BETA Release
