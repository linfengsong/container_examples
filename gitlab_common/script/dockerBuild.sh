#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

env_name=$1

iniFilePath="$1"
buildPath="$2"

echo . $SCRIPT_LOCATION/utilToken.sh
. $SCRIPT_LOCATION/utilToken.sh

buildConfigTemplate=$buildPath/docker_build_options.template

echo buildConfigTemplate=$buildConfigTemplate
cat $buildConfigTemplate
readIniFile args $iniFilePath
replaceTemplateTokens $buildConfigTemplate false
readIniFile image $iniFilePath
replaceTemplateTokens $buildConfigTemplate true
buildConfigTemplate=${buildConfigTemplate::-9}
cat $buildConfigTemplate

echo build path:
ls -l $buildPath
echo image path:
ls -l $buildPath/image

docker_options="-f $buildPath/Dockerfile"
while read -r line; do
  if [[ -z $line ]]; then
    continue
  else
    docker_options="$docker_options $line"
  fi
done < <(grep "" "$buildConfigTemplate")

echo whoami
whoami
echo docker build $docker_options $buildPath/image
docker build $docker_options $buildPath/image
