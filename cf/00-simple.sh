#!/bin/bash

aws cloudformation \
  create-stack --stack-name wp-00 \
  --template-body file://./wp-ec2-simple.cf.yaml \
  --parameters \
    "ParameterKey=AMI,ParameterValue=${ami}"


