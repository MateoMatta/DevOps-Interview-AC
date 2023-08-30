ips=""
ids=""
aws configure set aws_access_key_id ${{ secrets.AWS_ACCESS_KEY_ID }}
aws configure set aws_secret_access_key ${{ secrets.AWS_SECRET_ACCESS_KEY }}
aws configure set default.region us-east-1
export AWS_PAGER=""
#sudo echo 'output = json' >> /home/runner/.aws/config
echo 'Authenticating...'
aws sts get-caller-identity
while [ "$ids" = "" ]; do
  ids=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $1 --region $2 --query AutoScalingGroups[].Instances[].InstanceId --output text)
  sleep 1
  echo $1
  echo $2
done
for ID in $ids;
do
    IP=$(aws ec2 describe-instances --instance-ids $ID --region $2 --query Reservations[].Instances[].PublicIpAddress --output text)
    echo $IP
    
    sudo ssh -oStrictHostKeyChecking=no -i "candidate.pem" ubuntu@$IP 'touch $HOME/accessKey.txt; echo ${{ secrets.AWS_ACCESS_KEY_ID }} > $HOME/accessKey.txt' > /dev/null 2>&1
    sudo ssh -oStrictHostKeyChecking=no -i "candidate.pem" ubuntu@$IP 'touch $HOME/secAccessKey.txt; echo ${{ secrets.AWS_SECRET_ACCESS_KEY }} > $HOME/secAccessKey.txt' > /dev/null 2>&1
    #sudo ssh -oStrictHostKeyChecking=no -i "candidate.pem" ubuntu@$IP 'AWS_ACCESS_KEY_ID=$(cat accessKey.txt) AWS_SECRET_ACCESS_KEY=$(cat secAccessKey.txt) aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 729158664723.dkr.ecr.us-east-1.amazonaws.com' > /dev/null 2>&1
    #sudo ssh -oStrictHostKeyChecking=no -i "candidate.pem" ubuntu@$IP 'sudo docker run --name main-applications-registry -p 80:80 -d 729158664723.dkr.ecr.us-east-1.amazonaws.com/main-applications-registry' > /dev/null 2>&1

    ips="$ips,$IP"
done
