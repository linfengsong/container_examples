#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

srcPath=$1
envName=$2
infraName=$3

source $SCRIPT_LOCATION/koc_init.sh $srcPath $envName $infraName

echo "delete pod ${application_name}-deployment-"'*'
for i in $($koc get pods --no-headers -o custom-columns=":metadata.name"|grep "${application_name}-deployment-"); do
  echo $koc delete pod $i
  $koc delete pod $i
done
