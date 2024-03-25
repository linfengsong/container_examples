#!/bin/bash

if [[ ! -f $HOME/.pip/pip.conf ]] && [[ -f $SCRIPT_LOCATION/../conf/pip.conf ]]; then
  mkdir -p $HOME/.pip
  cp $SCRIPT_LOCATION/../conf/pip.conf $HOME/.pip
fi
yaml_package=$(python3 -m pip list|grep PyYAML)
if [[ -z "$yaml_package" ]]; then
  echo python3 -m pip install PyYAML
  python3 -m pip install PyYAML
fi
python3 -m pip list
