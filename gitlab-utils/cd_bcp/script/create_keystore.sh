#!/bin/bash

echo "start create keystore"
applicationName=$1
#password=$2
#passwd=$(echo $password|base64 -d)
passwd=changeit

hasOpenssl=$(command -v openssl)
if [[ -z $hasOpenssl ]]; then
  yum -y install openssl
fi

tls_secret_name=${applicationName}-service-secret
common_name="${applicationName}-28391.example.com"
echo tls_secret_name=$tls_secret_name
echo common_name=$common_name

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
$koc create secret generic $tls_secret_name --from-file=tls.key=/tmp/tls.key --from-file=tls.crt=/tmp/tls.crt --from-file=keystore.p12=/tmp/keystore.p12
rc=$?
if [[ $rc -eq 0 ]]; then
  echo "Successfully create secret $tls_secret_name"
else
  echo "Fail to create certificate: rc=$rc"
  exit $rc
fi

echo "end create keystore"
