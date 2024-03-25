#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

src_path=$1
output_path=$2

publish_path=$output_path/publish
build_path=$SCRIPT_LOCATION/../build

$SCRIPT_LOCATION/maven_launch.sh "-Dmaven.test.skip=true" "clean package" "$src_path"

mkdir -p ${publish_path}
cp $build_path/* $output_path/
cp -R $build_path/jar/* $output_path/

ls -l target
cp target/*-*.jar $publish_path/application.jar
