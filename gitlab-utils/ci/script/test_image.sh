#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

src_path=$1

if [[ -f $SCRIPT_LOCATION/test_${IMAGE_TYPE}.sh ]]; then
  $SCRIPT_LOCATION/test_${IMAGE_TYPE}.sh $src_path
elif [[ -z $IMAGE_TYPE ]]; then
  echo project structure does not support by maven, .NET or httpd
  exit 1
else
  echo image_type: $IMAGE_TYPE does not support
  exit 1
fi