#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

srcPath="$1"
envName=$2
buildPath="$3"

source $SCRIPT_LOCATION/koc_init.sh "$srcPath" $envName 

iniFilePath=$srcPath/conf/project_${envName}.ini

isDocker=$(command -v docker)
if [[ -z "$isDocker" ]]; then
  echo "start push image by bcp"
  $SCRIPT_LOCATION/push_bcp.sh "$iniFilePath" "$buildPath"
else
  echo "start push image by docker"
  $SCRIPT_LOCATION/push_docker.sh "$iniFilePath" "$buildPath"
fi
