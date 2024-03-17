#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

srcPath=$1
envName=$2
infraName=$3

echo srcPath=$srcPath
echo envName=$envName
echo infraName=$infraName

DOTNET_SONERSCANNER_VERIONS=6.2.0
#NUGET_PACKAGE_READ="https://nexus.example.com/nexus/service/local/nuget/example-nuget-read/"
#MAVEN_OPTS="-Dmaven.repo.local=$CI_PROJECT_DIR/.m2/repository --settings $GITLAB_UTILS_PATH/conf/settings.xml"

. $SCRIPT_LOCATION/util_token.sh

iniFilePath=$srcPath/conf/project_${envName}.ini

if [[ -z "$infraName" ]]; then
  tempatePath=$SCRIPT_LOCATION/../build
  readIniFile args $iniFilePath
  replaceTemplateTokens $tempatePath false

  readIniFile image $iniFilePath
  if [[ -z "$image_registry" ]]; then
    if [[ "$image_dest_env" == "nonprod" ]]; then
      export image_registry="example.registry-np-v4-uk.example.com"
    elif [[ "$image_dest_env" == "us-nonprod" ]]; then
      export image_registry="example.registry-np-v4-us.example.com"
    elif [[ "$image_dest_env" == "ap-nonprod" ]]; then
      export image_registry="example.registry-np-v4-ap.example.com"
    elif [[ "$image_dest_env" == "prod" ]]; then
      export image_registry="example.registry-prod-v4-uk.example.com"
    elif [[ "$image_dest_env" == "us-prod" ]]; then
      export image_registry="example.registry-prod-v4-us.example.com"
    elif [[ "$image_dest_env" == "ap-prod" ]]; then
      export image_registry="example.registry-prod-v4-ap.example.com"
    else
      echo "image_dest_env: $image_dest_env does not set or support"
      exit 1
    fi
    addToken image_registry
  fi
  replaceTemplateTokens $tempatePath false
  tokenAppend=true
else
  tempatePath=${SCRIPT_LOCATION}/../infra/container
  readIniFile envs $srcPath/conf/project_${envName}.ini
  replaceTemplateTokens $tempatePath false
  tokenAppend=false
fi

echo readIniFile infra $iniFilePath $tokenAppend
readIniFile infra "$iniFilePath" $tokenAppend

if [[ ! -z $infraName ]]; then
  if [[ -f $srcPath/infra/${infraName}/infra_${envName}.ini ]]; then
    echo readIniFile infra $srcPath/infra/${infraName}/infra_${envName}.ini true
    readIniFile infra "$srcPath/infra/${infraName}/infra_${envName}.ini" true
  else
    echo "Error: file does not exist: $srcPath/infra/${infraName}/infra_${envName}.ini"
  fi
fi

echo cluster=$cluster
if [[ ! -z $cluster ]]; then
  if [[ -f $srcPath/conf/cluster_${cluster}.ini ]]; then
    echo readIniFile infra $srcPath/conf/cluster_${cluster}.ini true
    readIniFile infra "$srcPath/conf/cluster_${cluster}.ini" true
  else
    echo "Error: file does not exist: $srcPath/conf/cluster_${cluster}.ini"
  fi
fi

echo "replaceTemplateTokens $tempatePath true"
replaceTemplateTokens $tempatePath true
