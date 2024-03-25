#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $SCRIPT_LOCATION/../../script/koc_init.sh
rc=$?
if [[ $rc -ne 0 ]]; then
  exit $rc
fi

echo "delete pod ${applicationName}-deployment-"'*'
for i in $($koc get pods --no-headers -o custom-columns=":metadata.name"|grep "${applicationName}-deployment-"); do
  echo $koc delete pod $i
  $koc delete pod $i
done
