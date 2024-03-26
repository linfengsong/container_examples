#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

srcPath=$1
envName=$2
appName=$3
outputPath="$4"

echo srcPath=$srcPath
echo envName=$envName
echo appName=$appName
echo outputPath=$outputPath

ciPath=$SCRIPT_LOCATION/..
rootPath=$SCRIPT_LOCATION/../..
projectConfigFile=$srcPath/conf/project_${envName}.yml

cp $ciPath/conf/* "$outputPath/"

configFile=$outputPath/project.yml
configYmlFile="$outputPath/config.yml"
configInstFile=$outputPath/project_ci.yml
if [[ -z "$IMAGE_TYPE" ]]; then
  export IMAGE_TYPE=$($SCRIPT_LOCATION/build_image_type.sh $srcPath)
fi
echo "IMAGE_TYPE: $IMAGE_TYPE" > "$configYmlFile"
echo "inst: $appName.">> "$configYmlFile"
configInput=ci.$appName:"$configYmlFile"
echo "gitlibAppConfPath: $outputPath">> $configYmlFile

cat $configInstFile >> "$configYmlFile"
echo "$configYmlFile":
cat "$configYmlFile"
echo $rootPath/script/template_replace.sh -c $configFile -c $projectConfigFile -c $configInput -t $outputPath
$rootPath/script/template_replace.sh -c $configFile -c $projectConfigFile -c $configInput -t $outputPath
rc=$?
if [[ $rc -ne 0 ]]; then
  exit $rc
fi

ls -l $outputPath/ci.env
cat $outputPath/ci.env
