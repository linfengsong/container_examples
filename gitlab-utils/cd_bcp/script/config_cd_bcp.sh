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

cdbcpPath=$SCRIPT_LOCATION/..
rootPath=$SCRIPT_LOCATION/../..
projectConfigFile=$srcPath/conf/project_${envName}.yml

mkdir -p $outputPath/conf
mkdir -p $outputPath/infra
cp -R $cdbcpPath/conf/* "$outputPath/conf"
cp -R $cdbcpPath/infra/* "$outputPath/infra"

configYmlFile="$outputPath/conf/config.yml"
configInstFile=$outputPath/conf/project_cd.yml
echo "inst: $appName."> $configYmlFile
echo "applicationName: $appName">> $configYmlFile
echo "gitlibAppPath: $outputPath">> $configYmlFile
configInput=cd.$appName:$configYmlFile
projectInput=$projectConfigFile

cat $configInstFile >> $configYmlFile
echo $configYmlFile:
cat $configYmlFile
echo $rootPath/script/template_replace.sh -c $projectInput -c $configInput -t $outputPath
$rootPath/script/template_replace.sh -c $projectInput -c $configInput -t $outputPath
rc=$?
if [[ $rc -ne 0 ]]; then
  exit $rc
fi

ls -l $outputPath/conf/cd_bcp.env
cat $outputPath/conf/cd_bcp.env
