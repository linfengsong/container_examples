#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

outputPath="$1"

buildConfigPath=$outputPath/docker_build
cat $buildConfigPath

echo dockerfile=$outputPath/Dockerfile
cat $outputPath/Dockerfile

docker_options="-f $outputPath/Dockerfile"
while read -r line; do
  if [[ -z $line ]]; then
    continue
  else
    docker_options="$docker_options $line"
  fi
done < <(grep "" "$buildConfigPath")
echo ls -l $outputPath
ls -l $outputPath
echo docker build $docker_options $outputPath
docker build $docker_options $outputPath
rc=$?
if [[ $rc -ne 0 ]]; then
  exit $rc
fi
echo docker push $image_name
docker push $image_name
