#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

srcPath=$1
envName=$2
infraName=$3

echo srcPath=$srcPath
echo envName=$envName
echo infraName=$infraName

configConfigFile=$SCRIPT_LOCATION/../conf/project.yml
projectConfigFile=$srcPath/conf/project_${envName}.yml

cp $configConfigFile config.yml
cat $projectConfigFile >> config.yml

if [[ -z "$infraName" ]]; then
  if [[ -z "$IMAGE_TYPE" ]]; then
    export IMAGE_TYPE=$($SCRIPT_LOCATION/build_image_type.sh $srcPath)
  fi
  echo "IMAGE_TYPE: $IMAGE_TYPE" >> config.yml
  cat config.yml
  python3 $SCRIPT_LOCATION/../python/template_replace.py ci -c $configConfigFile -c $projectConfigFile -c config.yml -t $SCRIPT_LOCATION -t $SCRIPT_LOCATION/../build
else
  python3 $SCRIPT_LOCATION/../python/template_replace.py $infraName -c $configConfigFile -c $projectConfigFile -c config.yml -t $SCRIPT_LOCATION -t $SCRIPT_LOCATION/../infra
fi
ls -l $SCRIPT_LOCATION/init.sh
cat $SCRIPT_LOCATION/init.sh
