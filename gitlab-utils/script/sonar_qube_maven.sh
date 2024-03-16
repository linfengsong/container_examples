#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

srcPath=$1
ciJobName=$2
ciProjectUrl=$3

maven_opts="-Dsonar.projectKey=$sonar_project_key"
maven_opts="$maven_opts -Dsonar.projectName=$sonar_project_key"
maven_opts="$maven_opts -Dsonar.host.url=$SONAR_HOST_URL"
maven_opts="$maven_opts -Dsonar.links.ci=$ciJobName"
maven_opts="$maven_opts -Dsonar.links.sonar.links.scm=$ciProjectUrl"
maven_opts="$maven_opts -Dsonar.qualitygate.wait=true"
maven_opts="$maven_opts -Dmaven.test.skip=true"

export MAVEN_SECURITY_OPTS="-Dsonar.token=$SONAR_TOKEN"

$SCRIPT_LOCATION/maven_launch.sh "$maven_opts" "verify sonar:sonar" "$srcPath"
