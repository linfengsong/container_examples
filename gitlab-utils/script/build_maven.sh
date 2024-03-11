#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

src_path=$1
output_path=$2

publish_path=$output_path/publish
build_path=$SCRIPT_LOCATION/../build

cp $GITLAB_UTILS_PATH/tool/mvnw $src_path/mvnw
mkdir $src_path/.mvn
cp -R $GITLAB_UTILS_PATH/tool/mvn/* $src_path/.mvn/

#MAVEN_OPTS="-Dmaven.repo.local=$CI_PROJECT_DIR/.m2/repository --settings $GITLAB_UTILS_PATH/conf/settings.xml"

current_dir=$(pwd)
cd $src_path
./mvnw $MAVEN_OPTS -Dmaven.test.skip=true clean package
      
      
mkdir -p ${publish_path}
cp -R $build_path/common/* $output_path/
cp -R $build_path/jar/* $output_path/
cp target/application-*-SNAPSHOT.jar $publish_path/application.jar

cd $current_dir