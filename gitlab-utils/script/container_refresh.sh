#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

iniFilePath=$1

. $SCRIPT_LOCATION/util_token.sh

echo "readIniFile account $iniFilePath"
readIniFile account $iniFilePath
showTokens

for i in $(oc get pods --no-headers -o custom-columns=":metadata.name"|grep "${containerName}-deployment-"|grep '^-build'); do
  oc delete pod $i
done
