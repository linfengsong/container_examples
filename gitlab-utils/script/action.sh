#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_PATH="$(dirname $SCRIPT_LOCATION)"

if [[ $# -eq 0 ]]; then
  echo "Inputs: -t <actionType> -n <actionName> -a <appName>"
  exit 1
fi

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -n)
      shift
      actionName=$1
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
      POSITIONAL_ARGS+=("$1")
      shift
      ;;
  esac
done

echo actionType=$actionType
echo actionName=$actionName
echo appName=$appName

export UTIL_SCRIPT_PATH=$SCRIPT_LOCATION

env_file=$ROOT_PATH/apps/$actionType/$appName/conf/$actionType.env
script=$ROOT_PATH/$actionType/script/$actionName.sh

if [[ ! -f $env_file ]]; then
  echo "actionType: $actionType does not support, $env_file does not exist"
  exit 1
fi

echo source $env_file
source $env_file

echo $script ${POSITIONAL_ARGS[@]}
$script ${POSITIONAL_ARGS[@]}
