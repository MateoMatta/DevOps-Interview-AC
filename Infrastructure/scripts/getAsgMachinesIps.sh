ips=""
ids=""
echo "Initializing containers..."
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

    export MACHINE_COMMAND='touch accessKey.txt; echo '$3' > accessKey.txt'
    sudo ssh -oStrictHostKeyChecking=no -i "/home/runner/candidate.pem" ubuntu@$IP $MACHINE_COMMAND > /dev/null 2>&1

    export MACHINE_COMMAND='touch secAccessKey.txt; echo '$4' > secAccessKey.txt; ls; pwd'
    sudo ssh -oStrictHostKeyChecking=no -i "/home/runner/candidate.pem" ubuntu@$IP $MACHINE_COMMAND > /dev/null 2>&1

    export MACHINE_COMMAND='AWS_ACCESS_KEY_ID=$(cat accessKey.txt) AWS_SECRET_ACCESS_KEY=$(cat secAccessKey.txt) aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 729158664723.dkr.ecr.us-east-1.amazonaws.com'
    sudo ssh -oStrictHostKeyChecking=no -i "/home/runner/candidate.pem" ubuntu@$IP $MACHINE_COMMAND > /dev/null 2>&1
    
    export MACHINE_COMMAND='sudo docker run --name main-applications-registry -p 80:80 -d 729158664723.dkr.ecr.us-east-1.amazonaws.com/main-applications-registry'
    sudo ssh -oStrictHostKeyChecking=no -i "/home/runner/candidate.pem" ubuntu@$IP $MACHINE_COMMAND > /dev/null 2>&1
    
    export MACHINE_COMMAND='rm accessKey.txt; rm secAccessKey.txt'
    sudo ssh -oStrictHostKeyChecking=no -i "/home/runner/candidate.pem" ubuntu@$IP $MACHINE_COMMAND 


    ips="$ips,$IP"
done

