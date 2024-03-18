#!/bin/bash

src_path=$1

if [[ -z "$src_path" ]]; then
  >&2 echo "Error: src_path is empty"
  exit 1
fi

solution_file=($(ls $src_path/*.sln 2> /dev/null||true))

if [[ -f $src_path/pom.xml ]]; then
  echo maven
elif [[ ! -z $solution_file ]] && [[ -f $solution_file ]]; then
  echo dotnet
elif [[ -d $src_path/src ]]; then
  echo httpd
else
  >&2 echo "Error: project only support maven, .Net SDK and httpd and root folder with pom.xml, *.sln file or src directory"
  >&2 ls -l $src_path
  exit 1
fi
