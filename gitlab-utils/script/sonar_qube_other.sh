#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

srcPath=$1
ciJobName=$2
ciProjectUrl=3
sources=$4

echo sources=$sources

export PATH="$PATH:/opt/sonar-scanner-cli/bin"

sonar_security_opts="-Dsonar.token=$SONAR_TOKEN"

sonar_opts="-Dsonar.projectKey=$sonar_project_key"
sonar_opts="$sonar_opts -Dsonar.projectName=$sonar_project_key"
sonar_opts="$sonar_opts -Dsonar.host.url=$SONAR_HOST_URL"
sonar_opts="$sonar_opts -Dsonar.links.ci=$ciJobName"
sonar_opts="$sonar_opts -Dsonar.links.sonar.links.scm=$ciProjectUrl"
sonar_opts="$sonar_opts -Dsonar.sources=$sources"
sonar_opts="$sonar_opts -Dsonar.qualitygate.wait=true"
#sonar_opts="$sonar_opts -Dsonar.verbose=true"

echo sonar-scanner $sonar_opts $sonar_security_opts
sonar-scanner $sonar_opts $sonar_security_opts
