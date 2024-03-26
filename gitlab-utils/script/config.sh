#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_PATH="$(dirname $SCRIPT_LOCATION)"

chmod 644 $ROOT_PATH/conf/*
chmod 755 $ROOT_PATH/script/*
      
chmod 644 $ROOT_PATH/ci/conf/*
chmod 755 $ROOT_PATH/ci/script/*
chmod 755 $ROOT_PATH/ci/tool/*

chmod 644 $ROOT_PATH/cd_bcp/conf/*
chmod 755 $ROOT_PATH/cd_bcp/script/*

srcPath=$1
shift
envName=$1
shift

actionType=
script=
for var in "$@"
do
  if [[ ! -z "$actionType" ]]; then
    appName=$var
    echo mkdir -p "$ROOT_PATH/apps/$actionType/$appName"
    mkdir -p "$ROOT_PATH/apps/$actionType/$appName"
    echo $script $srcPath $envName $appName "$ROOT_PATH/apps/$actionType/$appName"
    $script $srcPath $envName $appName "$ROOT_PATH/apps/$actionType/$appName"
    rc=$?
    if [[ $rc -ne 0 ]]; then
      echo "Error fail to setup $var on $envName"
      exit $rc
    fi
    actionName=
    script=
  elif [[ "$var" == "-ci" ]]; then
    actionType=ci
    script=$ROOT_PATH/ci/script/config_ci.sh
  elif [[ "$var" == "-cd_bcp" ]]; then
    actionType=cd_bcp
    script=$ROOT_PATH/cd_bcp/script/config_cd_bcp.sh
  else
    echo "Not support arg: $var"
  fi
done
