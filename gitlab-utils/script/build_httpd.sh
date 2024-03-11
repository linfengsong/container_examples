#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

src_path=$1
output_path=$2

publish_path=$output_path/src
build_path=$SCRIPT_LOCATION/../build
            
mkdir -p ${publish_path}
cp -R $build_path/common/* $output_path/
cp -R $build_path/httpd/* $output_path/
cp -R src/* $publish_path/
