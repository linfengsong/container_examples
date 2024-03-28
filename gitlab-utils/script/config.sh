#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_PATH="$(dirname $SCRIPT_LOCATION)"

chmod 644 $ROOT_PATH/conf/*
chmod 755 $ROOT_PATH/script/*
      
chmod 644 $ROOT_PATH/ci/conf/*
chmod 755 $ROOT_PATH/ci/script/*
chmod 755 $ROOT_PATH/ci/tool/*

chmod 644 $ROOT_PATH/bcp/conf/*
chmod 755 $ROOT_PATH/bcp/script/*

if [[ $# -eq 0 ]]; then
  echo "Inputs: -s <srcPath> -e <envName> -t <actionType> -a <appName>"
  exit 1
fi

while [[ $# -gt 0 ]]; do
  case $1 in
    -s)
      shift
      srcPath=$1
      shift
      ;;
    -e)
      shift
      envName=$1
      shift
      ;;
    -t)
      shift
      actionType=$1
      shift
      ;;
    -a)
      shift
      appName=$1
      shift
      ;;
    *)
      shift
      ;;
  esac
done

echo srcPath=$srcPath
echo envName=$envName
echo actionType=$actionType
echo appName=$appName

utilPath=$(dirname $SCRIPT_LOCATION)

$SCRIPT_LOCATION/python_launch.sh template_build.py $envName $srcPath $utilPath $actionType $appName
