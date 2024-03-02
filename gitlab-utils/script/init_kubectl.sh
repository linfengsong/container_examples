#!/bin/bash

if [[ -f /usr/bin/oc ]]; then
  export ktool=oc
else
  user=$(whoami)
  if [[ "$user" == "root" ]]; then
    export ktool="sudo -u gitlab-runner kubectl"
    export htool="sudo -u gitlab-runner helm"
  else
     export ktool=kubectl
     export htool=helm
  fi
fi
$ktool version --client
rc=$?
if [[ $rc -ne 0 ]]; then
  echo "oc or kubectl tool does not install, rc=$rc"
  exit 1
fi

$htool version --client
rc=$?
if [[ $rc -ne 0 ]]; then
  echo "oc or helm tool does not install, rc=$rc"
  exit 1
fi
