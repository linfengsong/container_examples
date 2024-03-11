#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

iniFilePath=$1

. $SCRIPT_LOCATION/util_token.sh

echo "readIniFile infra $iniFilePath"
readIniFile infra $iniFilePath
showTokens

echo "delete pod ${application_name}-deployment-"'*'
for i in $($koc get pods --no-headers -o custom-columns=":metadata.name"|grep "${application_name}-deployment-"); do
  echo $koc delete pod $i
  $koc delete pod $i
done
