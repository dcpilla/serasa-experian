#!/bin/bash
#
# Process the template files
# 
#
#

APP=$1
APP_NAME=$( cat $APP/.jenkins.yml | grep application | cut -d' ' -f4 )
VERSION=$( cat $APP/.jenkins.yml | grep version: | cut -d' ' -f2 )
GEARR_ID=$( cat $APP/.jenkins.yml | grep gearr: | cut -d' ' -f4 )

export app_name="$APP_NAME"
export version="$VERSION"
export gearr_id="$GEARR_ID"

( echo "cat <<EOF >build/Chart2.yml";
  cat build/$APP/Chart.yaml;
  echo "EOF";
) >temp.yml
. temp.yml

rm temp.yml

## processing values.yaml
export version="$VERSION"


( echo "cat <<EOF >build/values2.yml";
  cat build/$APP/values.yaml;
  echo "EOF";
) >temp.yml
. temp.yml

rm temp.yml

