#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

iniFilePath=$1
oc_access_id="$2"
oc_access_key="$3"

. $SCRIPT_LOCATION/util_token.sh
readIniFile account $iniFilePath
echo openshift_api_url=$openshift_api_url
echo openshift_project=$openshift_project

parentDir="$(dirname $SCRIPT_LOCATION)"
export PATH="${parentDir}/tool:$PATH"

oc_pwd=`echo $oc_access_key|base64 -d`
echo oc login "--server=${openshift_api_url}" -u "$oc_access_id" -p "$oc_pwd"
oc login "--server=${openshift_api_url}" -u "$oc_access_id" -p "$oc_pwd"
oc project ${openshift_project}
