#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

oc_access_id="$OC_ACCESS_ID"
oc_access_key="$OC_ACCESS_KEY"

parentDir="$(dirname $SCRIPT_LOCATION)"
export PATH="${parentDir}/tool:$PATH"

oc_path=$(command -v oc)
if [[ -z "$oc_path" ]]; then
  echo "oc command does not find"
  if [[ -f "${parentDir}/tool/oc" ]]; then
    oc_path="${parentDir}/tool/oc"
  fi
fi
if [[ ! -z "$oc_path" ]]; then
  echo "oc_path: $oc_path"
  echo openshift_api_url=$openshift_api_url
  echo namespace=$namespace
  oc_pwd=`echo $oc_access_key|base64 -d`
  echo oc login "--server=${openshift_api_url}" -u "$oc_access_id" -p "xxxxx"
  oc login "--server=${openshift_api_url}" -u "$oc_access_id" -p "$oc_pwd"
  rc=$?
  if [[ $rc -ne 0 ]]; then
    echo "fail to login: $oc_access_id"
    exit $rc
  fi
  oc project ${namespace}
  rc=$?
  if [[ $rc -ne 0 ]]; then
    echo "fail to set project: $namespace"
    exit $rc
  fi
  export koc='oc'
else
  kubectl config set-context --current --namespace=$namespace
  rc=$?
  if [[ $rc -ne 0 ]]; then
    echo "fail to set namespace: $namespace"
    exit $rc
  fi
  export koc='microk8s.kubectl'
fi
