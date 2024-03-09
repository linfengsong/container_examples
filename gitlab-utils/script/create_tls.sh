#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

applicationName=$1
chartName=$2
chartPath=$3
valuesPath=$4

echo "start check TLS certificate"

cert_name=${applicationName}-service-cert
tls_secret_name=${applicationName}-service-secret
echo cert_name=$cert_name
echo tls_secret_name=$tls_secret_name

#echo $SCRIPT_LOCATION/helm_deploy.sh $chartName $chartPath $valuesPath true
#$SCRIPT_LOCATION/helm_deploy.sh $chartName $chartPath $valuesPath true
#certs=`oc get cert|grep $cert_name 2> /dev/null`

$SCRIPT_LOCATION/create_keystore.sh $applicationName
echo $SCRIPT_LOCATION/create_keystore.sh $applicationName
certs=$cert_name

if [[ -z "$certs" ]]; then
  echo "certificate: $certName does not exist"
  exit 1
else
  echo "certificate: $certName exist"
  
  x=1
  while [[ $x -le 20 ]]
  do
    echo $x oc get secret $tls_secret_name
    tls=`oc get secret $tls_secret_name 2> /dev/null`
    if [[ -z "$tls" ]]; then
      x=$((x+1))
    else
      x=21
      echo $tls
    fi
    sleep 3
  done
  if [[ -z "$tls" ]]; then
    echo "$tls_secret_name is empty, not load secrets"
    exit 1
  else
    echo "$tls_secret_name created"
  fi
fi
