#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

containerName=$1
iniFilePath=$2

source $SCRIPT_LOCATION/microk8s_init.sh $iniFilePath

for i in $(oc get pods --no-headers -o custom-columns=":metadata.name"|grep "${containerName}-deployment-"|grep '^-build'); do
  oc delete pod $i
done
