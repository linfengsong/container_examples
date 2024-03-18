#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

outputPath="$1"

buildConfigPath=$outputPath/buildconfig.yaml
cat $buildConfigPath

appline=$(cat $buildConfigPath|grep app)
applines=($appline)
buildConfigName=${applines[1]}

echo buildConfigName=$buildConfigName
echo buildConfigPath=$buildConfigPath
cat $buildConfigPath

echo dockerfile=$outputPath/Dockerfile
cat $outputPath/Dockerfile

if [[ -z "$buildConfigName" ]]; then
  echo buildConfigName is empty
  exit 1
fi

echo "outputPath dir $outputPath:"
ls -l $outputPath

echo "outputPath/publish dir $outputPath/publish:"
ls -l $outputPath/publish

imageExist=`$koc get is|grep $buildConfigName 2>/dev/null`
echo imageExist=$imageExist
if [[ -z "$imageExist" ]]; then
  $koc create is $buildConfigName
fi
echo "$koc delete buildconfig $buildConfigName"
$koc delete buildconfig $buildConfigName 2>/dev/null
echo "$koc create -f $buildConfigPath"
$koc create -f $buildConfigPath

echo "$koc start-build $buildConfigName --from-dir=$outputPath --wait loglevel=10"
$koc start-build $buildConfigName --from-dir=$outputPath --wait --loglevel=10
rc=$?
echo "exit code $rc"
exit $rc
