#!/bin/bash
function oc() { microk8s kubectl $@; }
SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

chartName=$1
chartPath=$2
valuesTemplatePath=$3
serviceSection=$4
envSection=$5
iniFilePath=$6
existNotCreate=$7

chartArray=(`helm list --short 2>/dev/null`)
echo chartArray=$chartArray
if [[ " ${chartArray[*]} " =~ [[:space:]]${chartName}[[:space:]] ]]; then
  if [[ "$existNotCreate" == "true" ]]; then
    echo "chart $chartName exist, do not create"
    exit
  fi
  echo "chart exist, delete $chartName"
  helm delete $chartName
  x=1
  shRunning="${chartName}-"
  while [[ ! -z "$shRunning" ]] && [[ $x -le 20 ]]
  do
    sleep 10
    shRunning=`oc get pod|grep "${chartName}-"|grep Running|grep '^-build'`
    x=$((x+1))
  done
  if [[ ! -z "$shRunning" ]]; then
    exit 1
  else
    sleep 120
  fi
else
  echo "chart $chartName does not exist"
fi

echo iniFilePath=$iniFilePath
cat $iniFilePath
echo valuesTemplatePath=$valuesTemplatePath
cat $valuesTemplatePath

. $SCRIPT_LOCATION/util_token.sh

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

echo "replaceTemplateTokens $chartPath true"
replaceTemplateTokens $chartPath true

valuesPath=${valuesTemplatePath::-9}
echo "${valuesPath}:"
cat $valuesPath

echo helm install $chartName $chartPath -f $valuesPath
helm install $chartName $chartPath -f $valuesPath
