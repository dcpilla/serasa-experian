#!/bin/bash
#
# Run the build "pipeline" to test locally
#
# The charts version is the same as the app version.
# if you need to change something on the charts side, the app version needs to change as well.
#

#~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
# Preparing parameters
#~=~=~=~=

if [[ "$1" == "-h" ]]; then
    echo -e "Usage: $0 <APP_NAME> <APP_VERSION>\n"
    exit 1
fi

if [[ $# -ne 2 ]]; then
    echo -e "[ERROR] Illegal number of parameter.\nUsage: $0 <APP_NAME> <APP_VERSION>\n"
    exit 1             
fi

# app name
APP=$1
# app version
VERSION=$2

#~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
# Main
#~=~=~=~=
set -o pipefail -e

echo -e "\n[INFO] $0: Creating docker image $APP:$VERSION ..."
docker build -t $APP:$VERSION $APP

echo -e "\n[INFO] $0: Pushing the image $APP:$VERSION to the registry localhost:5000 ..."
docker build -t localhost:5000/$APP:$VERSION $APP
docker push localhost:5000/$APP:$VERSION

echo -e "\n[INFO] $0: List tags on the repo  $APP"
curl http://localhost:5000/v2/$APP/tags/list

