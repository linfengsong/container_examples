#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

src_path=$1

$SCRIPT_LOCATION/maven_launch.sh " " "test" "$src_path"
