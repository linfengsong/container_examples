#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

src_path=$1
output_path=$2

if [[ -z $IMAGE_TYPE ]]; then
  IMAGE_TYPE=$($SCRIPT_LOCATION/build_image_type.sh $src_path)
fi

if [[ -f $SCRIPT_LOCATION/build_${IMAGE_TYPE}.sh ]]; then
  $SCRIPT_LOCATION/build_${IMAGE_TYPE}.sh $src_path $output_path
elif [[ -z $IMAGE_TYPE ]]; then
  echo project structure does not support by maven, .NET or httpd
  exit 1
else
  echo image_type: $IMAGE_TYPE does not support
  exit 1
fi