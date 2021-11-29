
aws cloudformation \
  create-stack --stack-name "wp-01" \
  --template-body file://./wp-ec2-deploy.cf.yaml \
  --capabilities CAPABILITY_IAM


while true;
do
    date
    aws cloudformation \
        describe-stack-events --stack-name wp-01 \
        --output text | awk '{print $1,$2}'
    echo
    sleep 5
done


aws cloudformation describe-stack-resources --stack-name wp-01

aws ec2 describe-instances --instance-ids ...



