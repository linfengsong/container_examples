#!/bin/bash

if [[ -z "$(command -v microk8s)" ]]; then
  echo fail to init microk8s
  exit 1 
fi

echo define oc function

function oc() { microk8s kubectl $@; }
