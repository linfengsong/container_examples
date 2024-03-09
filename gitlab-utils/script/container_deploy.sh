#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

iniFilePath=$1
infraPath=$2
password=$3

echo iniFilePath=$iniFilePath
echo infraPath=$infraPath
echo password=$password

valuesTemplateFilePath=$infraPath/helm/values.yaml.template
apiPath=$infraPath/api
helmPath=$infraPath/helm

echo iniFilePath=$iniFilePath
cat $iniFilePath
echo valuesTemplateFilePath=$valuesTemplateFilePath
cat $valuesTemplateFilePath

. $SCRIPT_LOCATION/util_token.sh

echo "readIniFile account $iniFilePath"
readIniFile account $iniFilePath
showTokens

echo "readIniFile infra $iniFilePath"
readIniFile infra $iniFilePath
showTokens
echo "replaceTemplateTokens $infraPath true"
replaceTemplateTokens $infraPath true

valuesPath=${valuesTemplateFilePath::-9}

echo "${valuesPath}:"
cat $valuesPath

echo "create secret"
$SCRIPT_LOCATION/create_secret.sh keystore-password-secret password-key $password
echo "create tls"
echo $SCRIPT_LOCATION/create_tls.sh ${application_name} ${application_name}-service-cert $helmPath/cert $valuesPath
$SCRIPT_LOCATION/create_tls.sh ${application_name} ${application_name}-service-cert $helmPath/cert $valuesPath
echo "deploy ${application_name}-lbl"
echo $SCRIPT_LOCATION/helm_deploy.sh ${application_name}-lbl $helmPath/ingress $valuesPath true
$SCRIPT_LOCATION/helm_deploy.sh ${application_name}-lbl $helmPath/ingress $valuesPath true
echo "deploy $CONTAINER_NAME"
echo $SCRIPT_LOCATION/helm_deploy.sh ${application_name} $helmPath/deployment $valuesPath false
$SCRIPT_LOCATION/helm_deploy.sh ${application_name} $helmPath/deployment $valuesPath false
