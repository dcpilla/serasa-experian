#!/bin/bash
#
# Script to run the "pipeline" end-to-end for the app in the local environment
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
# Application namespace.
NAMESPACE="demo"
# Environment where the chart will be used
ENVIRONMENT=$5

#~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
# Functions
#~=~=~=~=

error_exit()
{
    echo "Error: $1"
    exit 1
}

#~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
# Main
#~=~=~=~=

echo -e "=~=~= [STAGE] Building app $APP =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=\n"
bash build.sh $APP $VERSION || error_exit "[ERROR] We have an error during build process"

echo -e "\n=~=~= [STAGE] Building chart for $APP =~=~=~=~=~=~=~=~=~=~=~=~=\n"
bash build-charts.sh $APP $VERSION $HCHART_TEMPLATE $HCHART_TEMPLATE_VERSION $ENVIRONMENT || error_exit "[ERROR] We have an error during charts build process"

echo -e "\n=~=~= [STAGE] Deploying chart $APP:$VERSION =~=~=~=~=~=~=~=~=~=\n"
bash deploy.sh $APP $VERSION $ENVIRONMENT || error_exit "[ERROR] We have an error deploying the charts"
