#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

applicationName=$1
iniFilePath=$2
infraPath=$3
password=$4

echo applicationName=$applicationName
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

source $SCRIPT_LOCATION/microk8s_init.sh $iniFilePath

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
$SCRIPT_LOCATION/create_tls.sh "$iniFilePath" $apiPath/cert.yaml.template $password
echo "deploy $applicationName-lbl"
echo $SCRIPT_LOCATION/helm_deploy.sh $applicationName-lbl $helmPath/ingress $valuesPath true
$SCRIPT_LOCATION/helm_deploy.sh $applicationName-lbl $helmPath/ingress $valuesPath true
echo "deploy $CONTAINER_NAME"
echo $SCRIPT_LOCATION/helm_deploy.sh $applicationName $helmPath/deployment $valuesPath false
$SCRIPT_LOCATION/helm_deploy.sh $applicationName $helmPath/deployment $valuesPath false
