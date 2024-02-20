#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "start check TLS certificate"
iniFilePath=$1
certFileTemplatePath=$2

. $SCRIPT_LOCATION/utilToken.sh
cat $iniFilePath
readIniFile cert $iniFilePath

echo cert_name=$cert_name
echo tls_secret_name=$tls_secret_name

if [[ -z $cert_name ]]; then
  echo "cert name does not set, ignore this step"
  exit
fi

. $SCRIPT_LOCATION/init_kubectl.sh

tls=`$ktool get secret $tls_secret_name 2> /dev/null`
if [[ -z "$tls" ]]; then
  echo "certificate: $certName does not exist, create it"
  replaceTemplateTokens $certFileTemplatePath true
  certFilePath=${certFileTemplatePath::-9}
 
  echo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=${common_name}"
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=${common_name}"
  echo "list tls:"
  ls -l tls.*
  cp tls.* /tmp
  chmod 644 /tmp/tls.*
  $ktool create secret tls $tls_secret_name --key="/tmp/tls.key" --cert="/tmp/tls.crt"
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

tls=`$ktool get secret $tls_secret_name 2> /dev/null`
if [[ -z "$tls" ]]; then
  echo "$tls_secret_name is empty, not load secrets"
else
  echo "$tls_secret_name created"
fi

