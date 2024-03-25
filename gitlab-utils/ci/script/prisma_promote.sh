#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $SCRIPT_LOCATION/../../script/koc_init.sh
rc=$?
if [[ $rc -ne 0 ]]; then
  exit $rc
fi

if [[ -z $image_registry ]]; then
  image_registry='image-registry.openshift-image-registry.svc:5000'
fi
if [[ -z $environment ]]; then
  environment=Test
fi

dest_image_name=$image_name

hasBlank=`$koc get secret 2>/dev/null|grep blank`
if [[ ! -z "$hasBlank" ]]; then
  $koc delete secret blank
fi

if [[ -z $dest_image_name ]]; then
  dest_image=$namespace/$image_name:1.00
else
  dest_image=$namespace/$dest_image_name:1.00
fi
image_path=${image_registry}/${namespace}/${image_name}:${image_tag}

$koc version

echo $koc process openshift//image-promoter-scan -p IMAGE_SCAN=yes -p SRC_IMAGE=${image_path} -p DEST_ENV=${image_dest_env} -p DEST_IMAGE=${dest_image} -p DEST_SECRET=destsecret
#$koc process openshift//image-promoter-scan -p IMAGE_SCAN=yes -p SRC_IMAGE=${image_path} -p DEST_ENV=${image_dest_env} -p DEST_IMAGE=${dest_image} -p DEST_SECRET=destsecret| $koc create -f -
