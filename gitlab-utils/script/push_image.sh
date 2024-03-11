#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

iniFilePath="$1"
buildPath="$2"

isDocker=$(command -v docker)
if [[ -z "$isDocker" ]]; then
  echo "start push image by bcp"
  $SCRIPT_LOCATION/push_bcp.sh "$iniFilePath" "$buildPath"
else
  echo "start push image by docker"
  $SCRIPT_LOCATION/push_docker.sh "$iniFilePath" "$buildPath"
fi
