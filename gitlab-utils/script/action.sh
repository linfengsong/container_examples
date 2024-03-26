#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_PATH="$(dirname $SCRIPT_LOCATION)"

appType=$1
shift
actionName=$1
shift
appName=$1
shift

export UTIL_SCRIPT_PATH=$SCRIPT_LOCATION

if [[ $appType == "-ci" ]]; then
  env_file=$ROOT_PATH/apps/ci/$appName/ci.env
  script=$ROOT_PATH/ci/script/$actionName.sh
elif [[ $appType == "-cd_bcp" ]]; then
  env_file=$ROOT_PATH/apps/cd_bcp/$appName/conf/cd_bcp.env
  script=$ROOT_PATH/cd_bcp/script/$actionName.sh
fi

echo source $env_file
source $env_file

echo $script $@
$script $@
