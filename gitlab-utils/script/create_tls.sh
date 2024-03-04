#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "start check TLS certificate"
iniFilePath=$1
certFileTemplatePath=$2
password=$3
passwd=$(echo $password|base64 -d)

. $SCRIPT_LOCATION/util_token.sh
cat $iniFilePath
readIniFile infra $iniFilePath

cert_name=${application_name}-service-cert
tls_secret_name=${application_name}-service-secret
common_name="${application_name}-${namespace}.${domain}"
echo cert_name=$cert_name
echo tls_secret_name=$tls_secret_name
echo common_name=$common_name

if [[ -z $cert_name ]]; then
  echo "cert name does not set, ignore this step"
  exit
fi

tls=`oc get secret $tls_secret_name 2> /dev/null`
if [[ -z "$tls" ]]; then
  echo "certificate: $certName does not exist, create it"
  replaceTemplateTokens $certFileTemplatePath true
  certFilePath=${certFileTemplatePath::-9}
 
  echo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=${common_name}"
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=${common_name}"
  
  echo openssl pkcs12 -export -inkey tls.key -in tls.crt -out keystore.p12
  openssl pkcs12 -export -inkey tls.key -in tls.crt -out keystore.p12 -passin pass:$passwd -passout pass:$passwd

  echo "list tls:"
  ls -l tls.*
  ls -l keystore.p12
  cp tls.* /tmp
  cp keystore.p12 /tmp
  chmod 644 /tmp/tls.*
  chmod 644 /tmp/keystore.p12
  #oc create secret tls $tls_secret_name --key="/tmp/tls.key" --cert="/tmp/tls.crt"
  oc create secret generic $tls_secret_name --from-file=tls.key=/tmp/tls.key --from-file=tls.crt=/tmp/tls.crt --from-file=keystore.p12=/tmp/keystore.p12
  rc=$?
  if [[ $rc -eq 0 ]]; then
    echo "Successfully create secret $tls_secret_name"
  else
    echo "Fail to create certificate: rc=$rc"
    exit $rc
  fi
else
  echo "certificate secret: $tls_secret_name exists"
fi

tls=`oc get secret $tls_secret_name 2> /dev/null`
if [[ -z "$tls" ]]; then
  echo "$tls_secret_name is empty, not load secrets"
else
  echo "$tls_secret_name created"
fi

