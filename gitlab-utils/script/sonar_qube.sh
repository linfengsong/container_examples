#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

srcPath=$1
envName=$2
ciJobName=$3
ciProjectUrl=$4

export SONAR_HOST_URL="http://lenovo:9000/"

echo srcPath=$srcPath
echo envName=$envName
echo ciJobName=$ciJobName
echo ciProjectUrl=$ciProjectUrl

. $SCRIPT_LOCATION/util_token.sh

iniFilePath=$srcPath/conf/project_${envName}.ini
readIniFile image $iniFilePath

if [[ -z $sonar_project_key ]]; then
  echo Error: sonar_project_key does not define
  exit 1
fi

if [[ -z $IMAGE_TYPE ]]; then
  IMAGE_TYPE=$($SCRIPT_LOCATION/build_image_type.sh $srcPath)
fi

if [[ "$IMAGE_TYPE" == "maven" ]]; then
  $SCRIPT_LOCATION/sonar_qube_maven.sh $srcPath $ciJobName $ciProjectUrl
elif [[ "$IMAGE_TYPE" == "dotnet" ]]; then
  $SCRIPT_LOCATION/sonar_qube_dotnet.sh $srcPath $ciJobName $ciProjectUrl
elif [[ "$IMAGE_TYPE" == "httpd" ]]; then
  $SCRIPT_LOCATION/sonar_qube_other.sh $srcPath $ciJobName $ciProjectUrl src
elif [[ -z $IMAGE_TYPE ]]; then
  echo project structure does not support by maven, .NET or httpd
  exit 1
else
  echo Error: image_type: $IMAGE_TYPE does not support
  exit 1
fi