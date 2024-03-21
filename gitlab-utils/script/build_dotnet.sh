#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

src_path=$1
output_path=$2

if [[ ! -z "$NUGET_PACKAGE_READ" ]]; then
  dotnet_options="--source ${NUGET_PACKAGE_READ}"
fi
publish_path=$output_path/publish
build_path=$SCRIPT_LOCATION/../build

if [[ -z ${FRAMEWORK_TYPE} ]]; then
  FRAMEWORK_TYPE=net6.0
fi
if [[ -z ${CONFIGURATION_TYPE} ]]; then
  CONFIGURATION_TYPE=Release
fi
if [[ -z ${SOLUTION_NAME} ]]; then
  sln=$(ls $src_path/*.sln)
  if [[ ! -z "$sln" ]]; then
    sln=$(basename $sln)
    SOLUTION_NAME=${sln::-4}
  fi
fi
if [[ -z ${PROJECT_NAME} ]]; then
  prj=$(ls $src_path/src/${SOLUTION_NAME}.*/${SOLUTION_NAME}.*.csproj)
  if [[ ! -z "$prj" ]]; then
    prj=$(basename $prj)
    prj=${prj#"${SOLUTION_NAME}."}
    PROJECT_NAME=${prj%".csproj"}
  fi
fi

dotnet --info
echo dotnet build /nodereuse:false ${SOLUTION_NAME}.sln $dotnet_options --configuration ${CONFIGURATION_TYPE}
dotnet build /nodereuse:false ${SOLUTION_NAME}.sln $dotnet_options --configuration ${CONFIGURATION_TYPE}

mkdir -p ${publish_path}
cp $build_path/* $output_path/
cp -R $build_path/dotnet/* $output_path/
cp -R src/${SOLUTION_NAME}.${PROJECT_NAME}/bin/${CONFIGURATION_TYPE}/${FRAMEWORK_TYPE}/* ${publish_path}/
cp ${publish_path}/${SOLUTION_NAME}.${PROJECT_NAME}.dll ${publish_path}/aspnetapp.dll
cp ${publish_path}/${SOLUTION_NAME}.${PROJECT_NAME}.runtimeconfig.json ${publish_path}/aspnetapp.runtimeconfig.json
cp ${publish_path}/${SOLUTION_NAME}.${PROJECT_NAME}.deps.json ${publish_path}/aspnetapp.deps.json
cp ${publish_path}/${SOLUTION_NAME}.${PROJECT_NAME}.pdb ${publish_path}/aspnetapp.pdb

