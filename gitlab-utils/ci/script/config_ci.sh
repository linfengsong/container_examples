#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

srcPath=$1
envName=$2
instName=$3

echo srcPath=$srcPath
echo envName=$envName
echo instName=$instName

configFile=$SCRIPT_LOCATION/../conf/project.yml
projectConfigFile=$srcPath/conf/project_${envName}.yml

templatePath=$SCRIPT_LOCATION/../build
configInstFile=$SCRIPT_LOCATION/../conf/project_ci.yml
if [[ -z "$IMAGE_TYPE" ]]; then
  export IMAGE_TYPE=$($SCRIPT_LOCATION/build_image_type.sh $srcPath)
fi
echo "IMAGE_TYPE: $IMAGE_TYPE" > config.yml
echo "inst: ''">> config.yml
configInput=ci:config.yml
projectInput=ci:$projectConfigFile

cat $configInstFile >> config.yml
echo config.yml:
cat config.yml
$SCRIPT_LOCATION/../../script/template_replace.sh -c $configFile -c $projectInput -c $configInput -t $SCRIPT_LOCATION -t $templatePath
rc=$?
if [[ $rc -ne 0 ]]; then
  exit $rc
fi

ls -l $SCRIPT_LOCATION/init_ci.sh
cat $SCRIPT_LOCATION/init_ci.sh
