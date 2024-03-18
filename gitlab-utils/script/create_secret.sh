#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "start set secret"

secret_name=$1
shift

options=
optionsDisplay=
userName=
arrayUserNames=()
for var in "$@"
do
  if [[ -z $userName ]]; then
    userName=$var
  else
    passwd=$(echo $var|base64 -d)
    options="$options --from-literal=$userName=$passwd"
    slen=${#passwd}
    pwdDisplay=`seq -sx 8|tr -d '[:digit:]'|tr -d '\n'`
    optionsDisplay="$optionsDisplay --from-literal=$userName=$pwdDisplay"
    arrayUserNames+=($userName)
    userName=
  fi
done

echo options=$options
echo optionsDisplay=$optionsDisplay

checkSecret()
{
  local name=$1
  if [[ ! -z $secrets ]]; then
    liternalSecret=`echo $secrets|grep $name`
  fi
  if [[ -z "$liternalSecret" ]]; then
    echo "$name secret does not set in openshift"
    noSecret=true
  fi
}

noSecret=false
secrets=`$koc describe secret destsecret 2> /dev/null`
for userName in ${arrayUserNames[@]}
do
  checkSecret $userName
done

if $noSecret; then
  echo "$koc create secret generic destsecret --from-literal=username=$OC_ACCESS_ID --from-literal=password=xxxxxxxxxx"
  $koc create secret generic destsecret --from-literal=username=$OC_ACCESS_ID "--from-literal=password=$OC_ACCESS_KEY"
  rc=$?
  if [[ $rc -ne 0 ]]; then
    echo "end set secret with $rc"
    exit $rc
  fi
else
  echo "require destsecret secret set in openshift"
fi


noSecret=false
secrets=`$koc describe secret $secret_name 2> /dev/null`
for userName in ${arrayUserNames[@]}
do
  checkSecret $userName
done

if $noSecret; then
  if [[ ! -z "$secrets" ]]; then
    $koc delete secret $secret_name
  fi

  echo "$koc create secret generic $secret_name $optionsDisplay"
  $koc create secret generic $secret_name $options
  rc=$?
  if [[ $rc -ne 0 ]]; then
    echo "end set secret with $rc"
    exit $rc
  fi
else
  echo "all require $secret_name secret set in openshift"
  exit
fi
