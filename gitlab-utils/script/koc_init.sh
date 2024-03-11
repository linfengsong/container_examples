#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

srcPath=$1
envName=$2
infraName=$3
oc_access_id="$4"
oc_access_key="$5"

. $SCRIPT_LOCATION/util_token.sh

iniFilePath=$srcPath/conf/project_${envName}.ini
readIniFile infra $iniFilePath

if [[ -f $srcPath/conf/cluster_${envName}.ini ]]; then
  readIniFile infra $iniFilePath
fi

if [[ ! -z $infraName ]] && [[ -f $srcPath/$infrName/infra_${infraName}.ini ]]; then
  readIniFile infra $srcPath/$infrName/infra_${infraName}.ini
fi

parentDir="$(dirname $SCRIPT_LOCATION)"
export PATH="${parentDir}/tool:$PATH"

oc_path=
if [[ ! -z "$oc_path" ]]; then
  echo openshift_api_url=$openshift_api_url
  echo namespace=$namespace
  oc_pwd=`echo $oc_access_key|base64 -d`
  echo oc login "--server=${openshift_api_url}" -u "$oc_access_id" -p "$oc_pwd"
  oc login "--server=${openshift_api_url}" -u "$oc_access_id" -p "$oc_pwd"
  oc project ${namespace}
  export koc='oc'
else
  export koc='microk8s.kubectl'
fi
