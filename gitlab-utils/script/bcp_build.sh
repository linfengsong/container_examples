#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

iniFilePath="$1"
buildPath="$2"

. $SCRIPT_LOCATION/utilToken.sh

buildConfigTemplate=$buildPath/docker_build_options.template

echo buildConfigTemplate=$buildConfigTemplate
cat $buildConfigTemplate
readIniFile args $iniFilePath
replaceTemplateTokens $buildConfigTemplate false
readIniFile image $iniFilePath
replaceTemplateTokens $buildConfigTemplate true
buildConfigPath=${buildConfigTemplate::-9}
cat $buildConfigPath

appline=$(cat $buildConfigPath|grep app)
applines=($appline)
buildConfigName=${applines[1]}

echo buildConfigName=$buildConfigName
echo buildConfigPath=$buildConfigPath
cat $buildConfigPath

if [[ -z "$buildConfigName" ]]; then
  echo buildConfigName is empty
  exit 1
fi

echo "buildPath dir $buildPath:"
ls -l $buildPath

imageExist=`oc get is|grep $buildConfigName 2>/dev/null
echo imageExist=$imageExist
if [[ -z "$imageExist" ]]; then
  oc create is $buildConfigName
fi
echo "oc delete buildconfig $buildConfigName"
oc delete buildconfig $buildConfigName 2>/dev/null
echo "oc create -f $buildConfigPath"
oc create -f $buildConfigPath

cp $buildPath/Dockerfile $buildPath/image
echo "oc start-build $buildConfigName --from-dir=$buildPath/image --wait loglevel=10"
oc start-build $buildConfigName --from-dir=$buildPath/image --wait loglevel=10
rc=$?
echo "exit code $rc"
exit $rc
