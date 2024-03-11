#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

srcPath=$1
envName=$2
infraName=$3
oc_access_id="$4"
oc_access_key="$5"

echo srcPath=$srcPath
echo envName=$envName
echo infraName=$infraName

. $SCRIPT_LOCATION/util_token.sh

echo readIniFile infra $srcPath/conf/project_${envName}.ini
readIniFile infra $srcPath/conf/project_${envName}.ini

if [[ ! -z $infraName ]]; then
  if [[ -f $srcPath/infra/${infraName}/infra_${envName}.ini ]]; then
    echo readIniFile infra $srcPath/infra/${infraName}/infra_${envName}.ini true
    readIniFile infra $srcPath/infra/${infraName}/infra_${envName}.ini true
  else
    echo "Error: file does not exist: $srcPath/infra/${infraName}/infra_${envName}.ini"
  fi
fi

echo cluster=$cluster
if [[ ! -z $cluster ]]; then
  if [[ -f $srcPath/conf/cluster_${cluster}.ini ]]; then
    echo readIniFile infra $srcPath/conf/cluster_${cluster}.ini true
    readIniFile infra $srcPath/conf/cluster_${cluster}.ini true
  else
    echo "Error: file does not exist: $srcPath/conf/cluster_${cluster}.ini"
  fi
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
