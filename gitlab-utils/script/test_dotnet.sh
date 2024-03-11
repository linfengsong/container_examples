#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

src_path=$1

if [[ -z ${SOLUTION_NAME} ]]; then
  sln=$(ls $src_path/*.sln)
  if [[ ! -z "$sln" ]]; then
    sln=$(basename $sln)
    SOLUTION_NAME=${sln::-4}
  fi
fi

dotnet --info
echo dotnet test ${SOLUTION_NAME}.sln
dotnet test $src_path/${SOLUTION_NAME}.sln
