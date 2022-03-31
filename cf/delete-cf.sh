#!/bin/bash


stack="${1}"

aws cloudformation \
  delete-stack --stack-name "${stack}"


while true;
do
  date
  aws cloudformation \
    describe-stack-events --stack-name "${stack}" \
    --output text | awk '{print $1,$2}'
  echo
  sleep 5
done


