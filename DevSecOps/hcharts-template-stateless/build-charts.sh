#!/bin/bash
#
# Script run the "pipeline" stage to build the charts for a environment
#

#~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
# Preparing parameters
#~=~=~=~=

if [[ "$1" == "-h" ]]; then
    echo -e "Usage: $0 <APP_NAME> <APP_VERSION> <HCHART_TEMPLATE> <HCHART_TEMPLATE_VERSION> <ENVIRONMENT>\n"
    exit 1
fi

if [[ $# -ne 5 ]]; then
    echo -e "[ERROR] Illegal number of parameter.\nUsage: $0 <APP_NAME> <APP_VERSION> <HCHART_TEMPLATE> <HCHART_TEMPLATE_VERSION> <ENVIRONMENT>\n"
    exit 1             
fi

# app name
APP=$1
# app version
VERSION=$2
# Helm Charts Template name. Define the template to be used.
HCHART_TEMPLATE=$3
# Helm Charts Template Version. Define the template version to download
HCHART_TEMPLATE_VERSION=$4
# Environment where the chart will be used
ENVIRONMENT=$5

#~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
# Main
#~=~=~=~=

set -o pipefail -e

echo -e "\n[INFO] $0: Downloading charts template ..."
mkdir -p build/$APP
cp -r $HCHART_TEMPLATE/* build/$APP

echo -e "\n[INFO] $0: Building the chart ..."
cp $APP/values.yaml build/$APP/
cp $APP/env-files/env.$ENVIRONMENT build/$APP/.env
bash process.sh $APP stg
cp build/Chart2.yml build/$APP/Chart.yaml
cp build/values2.yml build/$APP/values.yaml

echo -e "*** [STAGE] Checking Kubernetes Config with Kubeval and Conftest ...\n"
bash conftest.sh $APP $ENVIRONMENT

echo -e "\n[INFO] $0 Creating Helm Package ..."
helm package build/$APP --version $VERSION --app-version $VERSION -d build

echo -e "\n[INFO] $0: Pushing the chart ..."
helm push build/$APP-$VERSION.tgz oci://localhost:5000/$APP-charts/$ENVIRONMENT

echo -e "\n[INFO] $0: Cleaning the workspace ..."
rm -rf build
