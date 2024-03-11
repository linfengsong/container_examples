#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

srcPath=$1
envName=$2
infraName=$3
password=$4

source $SCRIPT_LOCATION/koc_init.sh $srcPath $envName $infraName

echo password=$password

containerPath=${SCRIPT_LOCATION}/../infra/container

valuesTemplateFilePath=$containerPath/helm/values.yaml.template
apiPath=$containerPath/api
helmPath=$containerPath/helm

echo valuesTemplateFilePath=$valuesTemplateFilePath
cat $valuesTemplateFilePath

showTokens
echo "replaceTemplateTokens $containerPath true"
replaceTemplateTokens $containerPath true

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
echo "deploy ${application_name}-deployment"
ls -l $helmPath/deployment
ls -l $valuesPath
echo $SCRIPT_LOCATION/helm_deploy.sh ${application_name}-deployment $helmPath/deployment $valuesPath false
$SCRIPT_LOCATION/helm_deploy.sh ${application_name}-deployment $helmPath/deployment $valuesPath false
