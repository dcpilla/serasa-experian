# MLOps Airflow EKS

## Code Structure

* [docker-base](docker-base/README.md): code to create the images used by our installation
* [hcharts](hcharts/README.md): Helm Charts to create the package used to install the MLOps Airflow using the terraform module

> NOTE: the terraform module was moved to <https://code.experian.local/projects/CDEAMLO/repos/coe-airflow-eks-tf-module/browse>

## Installation

To install the CoE Airflow, follow the instructions on the [terraform module](https://code.experian.local/projects/CDEAMLO/repos/coe-airflow-eks-tf-module/browse)

## Releasing a new version

* Docker images: the docker images are avaiable in the folder [docker-base](docker-base). Check the [README.md](docker-base/README.md) file in there for instructions.
* Helm Charts: follow the instructions in the [hcharts/README.md](hcharts/README.md)

## Versions - Branches and Tags

The Airflow version `2.7.x` is now in the default flow: `develop` and `main` branches. The initial Helm Charts tag is `2.7.0`.

To keep the maintenance of the Airflow version in `2.6.x` we created the branch `release/airflow-2.6` as the trunch branch for this version. The Helm Charts tag for Airflow `2.6.x` is `2.6.x`.

