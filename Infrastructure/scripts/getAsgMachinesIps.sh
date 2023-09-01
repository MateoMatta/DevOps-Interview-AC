ips=""
ids=""
while [ "$ids" = "" ]; do
  ids=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $1 --region $2 --query AutoScalingGroups[].Instances[].InstanceId --output text)
  sleep 3
  #echo $1
  #echo $2
done
for ID in $ids;
do
    IP=$(aws ec2 describe-instances --instance-ids $ID --region $2 --query Reservations[].Instances[].PublicIpAddress --output text)
    echo $IP
    export COMMAND_FOR_MACHINE= "touch $HOME/accessKey.txt; echo "$3" > $HOME/accessKey.txt"
    sudo ssh -oStrictHostKeyChecking=no -i "/home/runner/candidate.pem" ubuntu@$IP $COMMAND_FOR_MACHINE > /dev/null 2>&1
    export COMMAND_FOR_MACHINE="touch $HOME/secAccessKey.txt; echo "$4" > $HOME/secAccessKey.txt"
    sudo ssh -oStrictHostKeyChecking=no -i "/home/runner/candidate.pem" ubuntu@$IP '' > /dev/null 2>&1

    sudo ssh -oStrictHostKeyChecking=no -i "/home/runner/candidate.pem" ubuntu@$IP 'AWS_ACCESS_KEY_ID=$(cat accessKey.txt) AWS_SECRET_ACCESS_KEY=$(cat secAccessKey.txt) aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 729158664723.dkr.ecr.us-east-1.amazonaws.com' > /dev/null 2>&1
    sudo ssh -oStrictHostKeyChecking=no -i "/home/runner/candidate.pem" ubuntu@$IP 'sudo docker run --name main-applications-registry -p 80:80 -d 729158664723.dkr.ecr.us-east-1.amazonaws.com/main-applications-registry' > /dev/null 2>&1
    sudo ssh -oStrictHostKeyChecking=no -i "/home/runner/candidate.pem" ubuntu@$IP 'rm $HOME/accessKey.txt; rm $HOME/secAccessKey.txt; echo "Initializing containers..."'

    ips="$ips,$IP"
done

