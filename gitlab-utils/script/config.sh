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

if [[ ! -f $HOME/.pip/pip.conf ]] && [[ -f $SCRIPT_LOCATION/../conf/pip.conf ]]; then
  mkdir -p $HOME/.pip
  cp $SCRIPT_LOCATION/../conf/pip.conf $HOME/.pip
fi
yaml_package=$(python3 -m pip list|grep PyYAML)
if [[ -z "$yaml_package" ]; then
  echo python3 -m pip install PyYAML
  python3 -m pip install PyYAML
fi
python3 -m pip list

if [[ -z "$infraName" ]]; then
  if [[ -z "$IMAGE_TYPE" ]]; then
    export IMAGE_TYPE=$($SCRIPT_LOCATION/build_image_type.sh $srcPath)
  fi
  echo "IMAGE_TYPE: $IMAGE_TYPE" > config.yml
  cat config.yml
  python3 $SCRIPT_LOCATION/../python/template_replace.py ci -c $configConfigFile -c $projectConfigFile -c config.yml -t $SCRIPT_LOCATION -t $SCRIPT_LOCATION/../build
else
  python3 $SCRIPT_LOCATION/../python/template_replace.py $infraName -c $configConfigFile -c $projectConfigFile -c config.yml -t $SCRIPT_LOCATION -t $SCRIPT_LOCATION/../infra
fi
ls -l $SCRIPT_LOCATION/init.sh
cat $SCRIPT_LOCATION/init.sh
