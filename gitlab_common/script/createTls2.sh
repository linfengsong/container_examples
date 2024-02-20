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

certs=`$ktool get cert|grep $certName 2> /dev/null`
if [[ -z "$certs" ]]; then
  echo "certificate: $certName does not exist, create it"
  cat $certFileTemplatePath
  replaceTemplateTokens $certFileTemplatePath true
  certFilePath=${certFileTemplatePath::-9}
  echo $certFilePath
  cat $certFilePath
  
  $ktool create -f $certFilePath
  rc=$?
  if [[ $rc -eq 0 ]]; then
    echo "Successfully create certificate"
    x=1
    while [[ $x -le 20 ]]
    do
      echo $x $ktool get secret $tls_secret_name
      tls=`$ktool get secret $tls_secret_name 2> /dev/null`
      if [[ -z "$tls" ]]; then
        x=$((x+1))
      else
        x=21
        echo $tls
      fi
      sleep 3
    done
  else
    echo "Fail to create certificate: rc=$rc"
    exit $rc
  fi
else
  echo "certificate: $certName exists"
fi

tls=`$ktool get secret $tls_secret_name 2> /dev/null`
if [[ -z "$tls" ]]; then
  echo "$tls_secret_name is empty, not load secrets"
else
  echo "$tls_secret_name created"
fi

