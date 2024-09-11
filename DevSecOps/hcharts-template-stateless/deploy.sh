#!/bin/bash
#
# Script run the "pipeline" to deploy the app on the localhost environment
#

#~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
# Preparing parameters
#~=~=~=~=

if [[ "$1" == "-h" ]]; then
    echo -e "Usage: $0 <APP_NAME> <APP_VERSION> <ENVIRONMENT>\n"
    exit 1
fi

if [[ $# -ne 3 ]]; then
    echo -e "[ERROR] Illegal number of parameter.\nUsage: $0 <APP_NAME> <APP_VERSION> <ENVIRONMENT>\n"
    exit 1             
fi

# app name
APP=$1
# app version
VERSION=$2
# Environment where the chart will be used
ENVIRONMENT=$3
# Application namespace.
NAMESPACE="demo"

#~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
# Main
#~=~=~=~=

echo -e "\n[INFO] $0: Checking namespace '$NAMESPACE' ..."
kubectl describe ns $NAMESPACE || kubectl create namespace $NAMESPACE && kubectl label namespace $NAMESPACE istio-injection=enabled

echo -e "\n[INFO] $0: Updating charts $APP:$VERSION ..."
helm upgrade --install --namespace $NAMESPACE --version $VERSION --wait $APP oci://localhost:5000/$APP-charts/$ENVIRONMENT/$APP
