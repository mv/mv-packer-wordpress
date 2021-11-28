#!/bin/bash
#
# ferreira.mv[ at ]gmail.com    2021-11

owner="099720109477"
os_name="ubuntu-minimal/images/*ubuntu-*-" \
os_version="20.10"

if [ "${1}" == "" ]
then version="${os_version}"
else version="${1}"
fi


aws ec2 describe-images \
  --owners ${owner}     \
  --filters             \
      "Name=virtualization-type,Values=hvm" \
      "Name=root-device-type,Values=ebs"    \
      "Name=name,Values=${os_name}*${version}*" \
  --query 'Images[*].[OwnerId,Architecture,VirtualizationType,Name,ImageId]' \
  --output text | sort


