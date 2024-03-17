#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

password=$CERTIFICATE_PWD

source $SCRIPT_LOCATION/koc_init.sh
rc=$?
if [[ $rc -ne 0 ]]; then
  exit $rc
fi

pwdLen=${#password}
echo "CERTIFICATE_PWD length: $pwdLen"

if [[ -z $image_type ]]; then
  export image_type="none"
  addToken image_type
fi

containerPath=${SCRIPT_LOCATION}/../infra/container
apiPath=$containerPath/api
helmPath=$containerPath/helm
valuesPath=$containerPath/helm/values.yaml

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
