#!/bin/bash


stack="${1}"

aws cloudformation \
  update-stack --stack-name "${stack}" \
  --template-body file://./wp-ec2-deploy.cf.yaml \
  --capabilities CAPABILITY_IAM


while true;
do
  date
  aws cloudformation \
    describe-stack-events --stack-name "${stack}" \
    --output text | awk '{print $1,$2}'
  echo
  sleep 5
done


