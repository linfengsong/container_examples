#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

iniFilePath="$1"
outputPath="$2"

. $SCRIPT_LOCATION/util_token.sh

buildConfigTemplate=$outputPath/docker_build_options.template

echo buildConfigTemplate=$buildConfigTemplate
cat $buildConfigTemplate
readIniFile args $iniFilePath
replaceTemplateTokens $buildConfigTemplate false
readIniFile image $iniFilePath
replaceTemplateTokens $buildConfigTemplate true
buildConfigTemplate=${buildConfigTemplate::-9}
cat $buildConfigTemplate

docker_options="-f $outputPath/Dockerfile"
while read -r line; do
  if [[ -z $line ]]; then
    continue
  else
    docker_options="$docker_options $line"
  fi
done < <(grep "" "$buildConfigTemplate")
echo docker build $docker_options $outputPath
docker build $docker_options $outputPath
echo docker push $image_name
docker push $image_name
