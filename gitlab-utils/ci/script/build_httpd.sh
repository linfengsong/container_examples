#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

src_path=$1
output_path=$2

publish_path=$output_path/dist
build_path=$SCRIPT_LOCATION/../build
            
mkdir -p ${publish_path}
cp $build_path/* $output_path/
cp -R $build_path/httpd/* $output_path/
if [[ -f $src_path/package.json ]]; then
  currentDir=$(pwd)
  cd $src_path
  nodejs --version
  npm --version
  echo npm install
  npm install
  echo npm run build
  npm run build
  rc=$?
  cd $currentDir
  exit $rc
else
  cp -R $src_path/src/* $publish_path/
fi