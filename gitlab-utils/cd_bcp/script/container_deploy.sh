#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

password=$CERTIFICATE_PWD

source $UTIL_SCRIPT_PATH/koc_init.sh
rc=$?
if [[ $rc -ne 0 ]]; then
  exit $rc
fi

pwdLen=${#password}
echo "CERTIFICATE_PWD length: $pwdLen"

containerPath=$BCP_INFRA_PATH/container
apiPath=$containerPath/api
helmPath=$containerPath/helm
valuesPath=$containerPath/helm/values.yaml

echo "${valuesPath}:"
cat $valuesPath

echo "create secret"
$SCRIPT_LOCATION/create_secret.sh keystore-password-secret password-key $password

echo "create tls"
echo $SCRIPT_LOCATION/create_tls.sh ${applicationName} ${applicationName}-service-cert $helmPath/cert $valuesPath
$SCRIPT_LOCATION/create_tls.sh ${applicationName} ${applicationName}-service-cert $helmPath/cert $valuesPath

echo "deploy ${applicationName}-lbl"
echo $SCRIPT_LOCATION/helm_deploy.sh ${applicationName}-lbl $helmPath/ingress $valuesPath true
$SCRIPT_LOCATION/helm_deploy.sh ${applicationName}-lbl $helmPath/ingress $valuesPath true

echo "deploy ${applicationName}-deployment"
ls -l $helmPath/deployment
ls -l $valuesPath
echo $SCRIPT_LOCATION/helm_deploy.sh ${applicationName}-deployment $helmPath/deployment $valuesPath false
$SCRIPT_LOCATION/helm_deploy.sh ${applicationName}-deployment $helmPath/deployment $valuesPath false
