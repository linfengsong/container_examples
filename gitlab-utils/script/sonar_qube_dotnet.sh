#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

srcPath=$1
ciJobName=$2
ciProjectUrl=$3

dotnet tool install --global dotnet-sonarscanner
export PATH="$PATH:$HOME/.dotnet/tools"

sonar_security_opts="/d:sonar.token=$SONAR_TOKEN"

sonar_opts="/k:$sonar_project_key"
sonar_opts="$sonar_opts /n:$sonar_project_key"
sonar_opts="$sonar_opts /d:sonar.host.url=$SONAR_HOST_URL"
sonar_opts="$sonar_opts /d:sonar.links.ci=$ciJobName"
sonar_opts="$sonar_opts /d:sonar.links.sonar.links.scm=$ciProjectUrl"
sonar_opts="$sonar_opts /d:sonar.qualitygate.wait=true"
#sonar_opts="$sonar_opts /d:sonar.verbose=true"

echo dotnet sonarscanner begin $sonar_opts $sonar_security_opts
dotnet sonarscanner begin $sonar_opts $sonar_security_opts
echo dotnet build
dotnet build
echo dotnet sonarscanner end $sonar_security_opts
dotnet sonarscanner end $sonar_security_opts
