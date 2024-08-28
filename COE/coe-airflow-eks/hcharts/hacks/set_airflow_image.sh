#!/bin/bash
# Description: Set the Airflow repository and tag in values.yaml
# Author: Diego Rodrigues <mlops.sre@br.experian.com>
#               2023-11-29
# version: 0.1 : first version

# Airflow repository url with tag version
#837714169011.dkr.ecr.sa-east-1.amazonaws.com/airflow:v2.6.3-p3.8-bookworm-9rFd_sZVRy2hUdXtpG6Mdw

if [ ! -e "$(which yq)" ];then
    echo "Please install yq command"
    exit 1
fi

if [ -z "${1}" ]; then
    echo "plese send the Airflow repository:tag url as first argument"
    exit 1
fi

AIRFLOW_IMAGE=${1}

AIRFLOW_URL=$(awk -F":" '{print$1}' <<< ${AIRFLOW_IMAGE})
AIRFLOW_TAG=$(awk -F":" '{print$2}' <<< ${AIRFLOW_IMAGE})
AIRFLOW_VERSION=$(sed -E 's/(^v[0-9]+.*)-p.*/\1/' <<< ${AIRFLOW_TAG})

yq e '.airflow.airflowVersion = "'${AIRFLOW_VERSION}'"' -i helm-mlops-airflow/values.yaml
yq e '.airflow.defaultAirflowTag = "'${AIRFLOW_TAG}'"' -i helm-mlops-airflow/values.yaml
yq e '.airflow.images.airflow.repository = "'${AIRFLOW_URL}'"' -i helm-mlops-airflow/values.yaml
yq e '.airflow.images.airflow.tag = "'${AIRFLOW_TAG}'"' -i helm-mlops-airflow/values.yaml

yq e '.appVersion = "'${AIRFLOW_VERSION}'"' -i helm-mlops-airflow/Chart.yaml

CHART_VERSION=$(sed -nE 's/^version:(.*).*/\1/p' helm-mlops-airflow/Chart.yaml)
NEW_CHART_VERSION=$(awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}' <<< ${CHART_VERSION})
yq e '.version = "'${NEW_CHART_VERSION}'"' -i helm-mlops-airflow/Chart.yaml
