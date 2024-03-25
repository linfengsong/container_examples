#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

buildPath="$1"

source $SCRIPT_LOCATION/../../script/koc_init.sh
rc=$?
if [[ $rc -ne 0 ]]; then
  exit $rc
fi

if [[ "$koc" == "oc" ]]; then
  echo "start push image by bcp"
  $SCRIPT_LOCATION/push_bcp.sh "$buildPath"
else
  echo "start push image by docker"
  $SCRIPT_LOCATION/push_docker.sh "$buildPath"
fi
