#!/bin/bash

mavenOptions="$1"
mavenGoals="$2"
src_path="$3"

cp $GITLAB_UTILS_PATH/tool/mvnw $src_path/mvnw
mkdir $src_path/.mvn
cp -R $GITLAB_UTILS_PATH/tool/mvn/* $src_path/.mvn/

current_dir=$(pwd)
cd $src_path
echo ./mvnw $MAVEN_OPTS $mavenOptions $mavenGoals
./mvnw $MAVEN_OPTS $MAVEN_SECURITY_OPTS $mavenOptions $mavenGoals
rc=$?

cd $current_dir
exit $rc
