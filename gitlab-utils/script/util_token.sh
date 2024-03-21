#!/bin/bash

renameTemplateFile()
{
  local filePath=$1
  local renameFile=$2
  if [[ "$renameFile" == "true" ]]; then
    local f=${filePath::-9}
    echo "mv $filePath $f"
    mv $filePath $f
  fi
}

replaceToken()
{
  local filePath=$1
  local tokenName="$2"
  local invisibleTokenValue="$3"
  local tokenValue=""
  eval "local tokenValue=\${${tokenName}}"
  local displayTokenValue=$tokenValue
  if [[ "$invisibleTokenValue" == "true" ]]; then
    if [[ -z "$tokenValue" ]]; then
      displayTokenValue="value length:0"
    else
      displayTokenValue="value length:${#tokenValue}"
    fi
  fi
  if [[ ${tokenName:0:1} == "_" ]]; then
    local temp=${tokenName:1}
    tokenName=$tokenValue
    tokenValue=$temp
    displayTokenValue=$temp
  fi 
  echo sed -i "s|\%\[${tokenName}\]\%|$displayTokenValue|g" $filePath
  sed -i "s|\%\[${tokenName}\]\%|$tokenValue|g" $filePath
}

replaceTokens()
{
  local filePath=$1
  local renameFile=$2
  local invisibleTokenValue="$3"
  
  echo "replaceTokens $filePath $renameFile $invisibleTokenValue"
  for i in "${arrayTokenNames[@]}"
  do
    replaceToken $filePath $i $invisibleTokenValue
  done
  renameTemplateFile $filePath $renameFile
}

replaceBlock()
{
  local filePath=$1
  local renameFile=$2
  local invisibleTokenValue="$3"
  
  hasBlock=$(cat $filePath|grep '%%\[START' 2>/dev/null||true)
  if [[ -z "$hasBlock" ]]; then
    echo "replaceBlock $filePath No Block"
    renameTemplateFile $filePath $renameFile
    return
  fi
  
  echo "replaceBlock $filePath $renameFile $invisibleTokenValue"
  inBlock="false"
  block=
  rfilePath="${filePath}.tmp"
  if [[ -f "${rfilePath}" ]]; then
    rm "${rfilePath}"
  fi
  while IFS= read line
  do
    tline=$(echo $line| tr -d ' ')
    sline=${tline:0:8}
    eline=${tline:0:9}
    if [[ "$sline" == "%%[START" ]]; then
      inBlock="true"
      block=
    elif [[ "$eline" == "%%[END]%%" ]]; then
      inBlock="false"
      for tokenName in "${arrayTokenNames[@]}"
      do
        eval "local tokenValue=\${${tokenName}}"
        local displayTokenValue=$tokenValue
        if [[ "$invisibleTokenValue" == "true" ]]; then
          displayTokenValue="value lenght:${#tokenValue}"
        fi
        echo sed -e "s|\%\[NAME\]\%|$tokenName|g"|sed -e "s|\%\[VALUE\]\%|$displayTokenValue|g"
        echo "$block"|sed -e "s|\%\[NAME\]\%|$tokenName|g"|sed -e "s|\%\[VALUE\]\%|$tokenValue|g">>"${rfilePath}"
      done
    elif [[ "$inBlock" == "true" ]]; then
      if [[ -z "$block" ]]; then
        block="$line"
      else
        block="${block}"$'\n'"${line}"
      fi
    else
      echo "$line">>"${rfilePath}"
    fi
  done < <(grep "" "$filePath")
  rm "$filePath" 
  mv "${rfilePath}" "$filePath"
  renameTemplateFile $filePath $renameFile
}

replaceTemplateTokens()
{
  local path=$1
  local renameFile=$2
  local invisibleTokenValue="$3"
  if [[ -d $path ]]; then
    for f in $(find $path -name '*.template'); do
      replaceTemplateTokens $f $renameFile $invisibleTokenValue
    done
  elif [[ $path==*.template ]]; then
    echo "replaceTemplateTokens replace: $path"
    replaceBlock $path false $invisibleTokenValue
    replaceTokens $path $renameFile $invisibleTokenValue
  fi
}

getTokenValue() 
{
  local name=$1
  local tmpFile=$(mktemp)
  rm $tmpFile
  
  local templatePropFile=$tmpFile.template
  echo -n "%[$name]%"> $templatePropFile
  replaceTemplateTokens $templatePropFile false
  export TOKEN_VALUE="$(cat $templatePropFile)"
  rm $templatePropFile
}

setTokens()
{
  local tokenNames=$1
  local tokenSecretNames=$2
  arrayTokenNames=(${tokenNames//,/ })

  showTokens
  
  if [[ ! -z $tokenSecretNames ]]; then
    arrayTokenSecretNames=(${tokenSecretNames//,/ })
    for i in "${arrayTokenSecretNames[@]}"
    do
	  arrayTokenNames+=($i)
      eval "local tokenValue=\${${i}}"
	  if [[ -z $tokenValue ]]; then
        echo $i=[length: 0]
	  else
	    echo $i=[length: ${#tokenValue}]
	  fi
    done  
  fi
}

addToken()
{
  token=$1
  value=$(eval echo '$'"$token")
  echo add token: $token=$value
  arrayTokenNames+=($token)
}

showTokens() 
{
  for i in "${arrayTokenNames[@]}"
  do
    eval "local tokenValue=\${${i}}"
    echo $i=$tokenValue
  done
}

readTokens() {
  local path=$1
  local bAppend=$2
  if [[ $bAppend == "false" ]]; then
    arrayTokenNames=()
  fi
  while IFS='=' read -r key value
  do
    if [[ ! -z ${key} ]]; then
      key="$(echo ${key}|sed -e 's/^[[:space:]]*//')"
      value="$(echo ${value}|sed -e 's/^[[:space:]]*//')"
      value=${value/\$/\\$}
      eval export ${key}=\'${value}\'
      arrayTokenNames+=(${key})
    fi 
  done < <(grep "" $path)
}

createTokenFile() {
  local section=$1
  local path=$2
  local output_path=$3
  if [[ -f "${output_path}" ]]; then
    rm "${output_path}"
  fi
  bInsection=false
  while read -r line
  do
    tline=$(echo $line| tr -d ' ')
    if [[ -z $tline ]]; then
      line=$line
    elif [[ "${tline:0:1}" == "#" ]]; then
      line=$line
    elif [[ "${line:0:1}" == "[" ]]; then
      if [[ "[$section]" == "$line" ]]; then
        bInsection=true
      else
        bInsection=false
      fi
    elif [[ "$bInsection" == "true" ]]; then
      echo $line>>"${output_path}"
    fi
  done < <(grep "" $path)
}

readIniFile() {
  local section="$1"
  local path="$2"
  local bAppend="$3"
  if [[ -z $bAppend ]]; then
    bAppend=false
  fi
  local output_path="${path}.tmp"
  createTokenFile $section "$path" "$output_path"
  
  if [[ -f "$output_path" ]]; then
    readTokens "$output_path" $bAppend
    rm "$output_path"
  fi
}
