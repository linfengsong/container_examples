#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

containerName=$1

for i in $(oc get pods --no-headers -o custom-columns=":metadata.name"|grep "${containerName}-"|grep '^-build'); do
  oc delete pod $i
done
