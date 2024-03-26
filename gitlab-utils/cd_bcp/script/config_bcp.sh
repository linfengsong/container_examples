#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

srcPath=$1
envName=$2
instName=$3

echo srcPath=$srcPath
echo envName=$envName
echo instName=$instName

projectConfigFile=$srcPath/conf/project_${envName}.yml

templatePath=$SCRIPT_LOCATION/../infra
configInstFile=$SCRIPT_LOCATION/../conf/project_cd.yml
echo "inst: $instName."> config.yml
echo "applicationName: $instName">> config.yml
configInput=cd.$instName:config.yml
projectInput=$projectConfigFile
  
cat $configInstFile >> config.yml
echo config.yml:
cat config.yml
echo $SCRIPT_LOCATION/../../script/template_replace.sh -c $projectInput -c $configInput -t $SCRIPT_LOCATION -t $templatePath
$SCRIPT_LOCATION/../../script/template_replace.sh -c $projectInput -c $configInput -t $SCRIPT_LOCATION -t $templatePath
rc=$?
if [[ $rc -ne 0 ]]; then
  exit $rc
fi

ls -l $SCRIPT_LOCATION/init_cd.sh
cat $SCRIPT_LOCATION/init_cd.sh
