#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mavenOptions="$1"
mavenGoals="$2"
src_path="$3"

export MAVEN_SETTING_FILE="$SCRIPT_LOCATION/../conf/settings.xml"

cp $GITLAB_UTILS_PATH/tool/mvnw $src_path/mvnw
mkdir $src_path/.mvn
cp -R $GITLAB_UTILS_PATH/tool/mvn/* $src_path/.mvn/

if [[ ! -z "$CI_PROJECT_DIR" ]]; then
  mkdir -p $CI_PROJECT_DIR/.m2/repository
  repository_path=$(realpath $CI_PROJECT_DIR/.m2/repository)
  mavenOptions="$mavenOptions -Dmaven.repo.local=$repository_path"
fi

if [[ -f "$MAVEN_SETTING_FILE" ]]; then
  setting_file=$(realpath $MAVEN_SETTING_FILE)
  mavenOptions="$mavenOptions --settings $setting_file"
fi

current_dir=$(pwd)
cd $src_path
echo ./mvnw $MAVEN_OPTS $mavenOptions $mavenGoals
./mvnw $MAVEN_OPTS $MAVEN_SECURITY_OPTS $mavenOptions $mavenGoals
rc=$?

cd $current_dir
exit $rc
