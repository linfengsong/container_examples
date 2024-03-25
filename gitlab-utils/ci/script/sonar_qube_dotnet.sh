#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

srcPath=$1
ciJobName=$2
ciProjectUrl=$3

sonar_security_opts="/d:sonar.token=$SONAR_TOKEN"
if [[ ! -z "${NUGET_PACKAGE_READ}" ]]; then
  dotnet_tool_options="--version ${DOTNET_SONARSCANNER_VERIONS} --add-source ${NUGET_PACKAGE_READ}"
  dotnet_options="--source ${NUGET_PACKAGE_READ}"
fi

dotnet --info

echo dotnet tool install --global dotnet-sonarscanner $dotnet_tool_options
dotnet tool install --global dotnet-sonarscanner $dotnet_tool_options
if [[ ! -f $HOME/.dotnet/tools/dotnet-sonarscanner ]]; then
  echo "fail install dotnet-sonarscanner"
  exit 1
fi
export PATH="$PATH:$HOME/.dotnet/tools"

sonar_opts="/k:$sonar_project_key"
sonar_opts="$sonar_opts /n:$sonar_project_key"
sonar_opts="$sonar_opts /d:sonar.host.url=$SONAR_HOST_URL"
sonar_opts="$sonar_opts /d:sonar.links.ci=$ciJobName"
sonar_opts="$sonar_opts /d:sonar.links.sonar.links.scm=$ciProjectUrl"
sonar_opts="$sonar_opts /d:sonar.qualitygate.wait=true"
#sonar_opts="$sonar_opts /d:sonar.verbose=true"

echo dotnet sonarscanner begin $sonar_opts $dotnet_options $sonar_security_opts
dotnet sonarscanner begin $sonar_opts $dotnet_options $sonar_security_opts
echo dotnet build $dotnet_options
dotnet build $dotnet_options
echo dotnet sonarscanner end $dotnet_options $sonar_security_opts
dotnet sonarscanner end $dotnet_options $sonar_security_opts
