#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

chartName=$1
chartPath=$2
valuesTemplatePath=$3
serviceSection=$4
envSection=$5
iniFilePath=$6
existNotCreate=$7

. $SCRIPT_LOCATION/init_kubectl.sh

chartExist=`$htool list|grep "${chartName}" 2>/dev/null`
echo chartExist=$chartExist
if [[ ! -z "$chartExist" ]]; then
  if [[ "existNotCreate" == "true" ]]; then
    echo "chart $chartName exist, do not create"
    exit
  fi
  echo "chart exist, delete $chartName"
  $htool delete $chartName
  x=1
  shRunning="${chartName}-"
  while [[ ! -z "$shRunning" ]] && [[ $x -le 20 ]]
  do
    sleep 10
    shRunning=`$ktool get pod|grep "${chartName}-"|grep Running|grep '^-build'`
    x=$((x+1))
  done
  if [[ ! -z "$shRunning" ]]; then
    exit 1
  else
    sleep 120
  fi
fi

echo iniFilePath=$iniFilePath
cat $iniFilePath
echo valuesTemplatePath=$valuesTemplatePath
cat $valuesTemplatePath

. $SCRIPT_LOCATION/utilToken.sh

echo "readIniFile $envSection $iniFilePath"
readIniFile $envSection $iniFilePath
showTokens
echo "replaceTemplateTokens $valuesTemplatePath false"
replaceTemplateTokens $valuesTemplatePath false

echo "readIniFile $serviceSection $iniFilePath"
readIniFile $serviceSection $iniFilePath
showTokens
echo "replaceTemplateTokens $valuesTemplatePath true"
replaceTemplateTokens $valuesTemplatePath true

valuesPath=${valuesTemplatePath::-9}
echo "${valuesPath}:"
cat $valuesPath

echo whoami
whoami

chmod -R 777 $chartPath/..
ls -l $chartPath/..

chown -R gitlib-runner $chartPath/..
ls -l $chartPath/..

echo $htool install $chartName $chartPath -f $valuesPath
$htool install $chartName $chartPath -f $valuesPath
