#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

iniFilePath="$1"
buildPath="$2"

. $SCRIPT_LOCATION/util_token.sh

buildConfigTemplate=$buildPath/buildconfig.yaml.template

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

imageExist=`$koc get is|grep $buildConfigName 2>/dev/null`
echo imageExist=$imageExist
if [[ -z "$imageExist" ]]; then
  $koc create is $buildConfigName
fi
echo "$koc delete buildconfig $buildConfigName"
$koc delete buildconfig $buildConfigName 2>/dev/null
echo "$koc create -f $buildConfigPath"
$koc create -f $buildConfigPath

cp $buildPath/Dockerfile $buildPath/image
echo "$koc start-build $buildConfigName --from-dir=$buildPath/image --wait loglevel=10"
$koc start-build $buildConfigName --from-dir=$buildPath/image --wait --loglevel=10
rc=$?
echo "exit code $rc"
exit $rc
