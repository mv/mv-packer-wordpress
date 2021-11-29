#!/bin/bash
#


stack="${1}"
ami="${2}"
instance_type="${3}"

aws cloudformation \
  create-stack --stack-name "${stack}" \
  --template-body file://./wp-ec2-deploy.cf.yaml \
  --capabilities CAPABILITY_IAM \
  --parameters \
    "ParameterKey=AMI,ParameterValue=${ami}" \
    "ParameterKey=InstanceType,ParameterValue=${instance_type}"

#   "ParameterKey=InstanceType,ParameterValue=t4g.micro"


while true;
do
    date
    aws cloudformation \
        describe-stack-events --stack-name "${stack}" \
        --output text | awk '{print $1,$2}'
    echo
    sleep 5
done


# aws cloudformation describe-stack-resources --stack-name wp-01
# aws ec2 describe-instances --instance-ids ...



