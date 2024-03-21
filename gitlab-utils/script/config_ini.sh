#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

srcPath=$1
envName=$2
infraName=$3

echo srcPath=$srcPath
echo envName=$envName
echo infraName=$infraName

sed -i "s|\%\[ci.|\%\[|g" $SCRIPT_LOCATION/init.sh.template
sed -i "s|\%\[ci.|\%\[|g" $SCRIPT_LOCATION/../build/buildconfig.yaml.template
sed -i "s|\%\[ci.|\%\[|g" $SCRIPT_LOCATION/../build/docker_build.template

. $SCRIPT_LOCATION/util_token.sh

iniPreFilePath=$SCRIPT_LOCATION/../conf/project_pre.ini
iniPostFilePath=$SCRIPT_LOCATION/../conf/project_post.ini
iniFilePath=$srcPath/conf/project_${envName}.ini

if [[ -z "$infraName" ]]; then
  tempatePath=$SCRIPT_LOCATION/../build
  readIniFile args $iniFilePath
  replaceTemplateTokens $tempatePath false
  
  echo readIniFile infra $iniPreFilePath
  readIniFile infra "$iniPreFilePath"
  
  if [[ -z "$IMAGE_TYPE" ]]; then
    export IMAGE_TYPE=$($SCRIPT_LOCATION/build_image_type.sh $srcPath)
  fi
  addToken IMAGE_TYPE
    
  echo readIniFile image $iniFilePath true
  readIniFile image $iniFilePath true
  
  replaceTemplateTokens $tempatePath false
else
  tempatePath=${SCRIPT_LOCATION}/../infra/container
  readIniFile envs $iniFilePath
  replaceTemplateTokens $tempatePath false
  
  echo readIniFile infra $iniPreFilePath
  readIniFile infra "$iniPreFilePath"
fi

echo readIniFile infra $iniFilePath true
readIniFile infra "$iniFilePath" true

if [[ ! -z $infraName ]]; then
  if [[ -f $srcPath/infra/${infraName}/infra_${envName}.ini ]]; then
    echo readIniFile infra $srcPath/infra/${infraName}/infra_${envName}.ini true
    readIniFile infra "$srcPath/infra/${infraName}/infra_${envName}.ini" true
  else
    echo "Error: file does not exist: $srcPath/infra/${infraName}/infra_${envName}.ini"
  fi
fi

echo readIniFile infra $iniPostFilePath true
readIniFile infra "$iniPostFilePath" true

echo "replaceTemplateTokens $tempatePath true"
replaceTemplateTokens $tempatePath true

echo "replaceTemplateTokens $SCRIPT_LOCATION/init.sh.template true"
replaceTemplateTokens $SCRIPT_LOCATION/init.sh.template true

ls -l $SCRIPT_LOCATION/init.sh
cat $SCRIPT_LOCATION/init.sh
