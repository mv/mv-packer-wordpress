#!/bin/bash
#
# ferreira.mv[ at ]gmail.com    2021-11

owner="amazon"
os_name="amzn2-ami-minimal-hvm"
os_version="2.0.202?"  # 2021,2022,etc...

if [ "${1}" == "" ]
then version="${os_version}"
else version="${1}"
fi


aws ec2 describe-images \
  --owners ${owner}     \
  --filters             \
      "Name=virtualization-type,Values=hvm" \
      "Name=root-device-type,Values=ebs"    \
      "Name=name,Values=${os_name}*${os_version}*" \
  --query 'Images[*].[OwnerId,Architecture,VirtualizationType,Name,ImageId]' \
  --output text | sort


