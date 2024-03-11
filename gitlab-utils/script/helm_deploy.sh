#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

chartName=$1
chartPath=$2
valuesPath=$3
existNotCreate=$4

chartArray=(`helm list --short 2>/dev/null`)
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
    shRunning=`$koc get pod|grep "${chartName}-"|grep Running|grep '^-build'`
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

echo helm install $chartName $chartPath -f $valuesPath
helm install $chartName $chartPath -f $valuesPath
