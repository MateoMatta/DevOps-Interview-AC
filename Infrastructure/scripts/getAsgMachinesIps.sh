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
    echo "Initializing containers..."
    export MACHINE_COMMAND="touch accessKey.txt; echo $3 > accessKey.txt"
    sudo ssh -oStrictHostKeyChecking=no -i "/home/runner/candidate.pem" ubuntu@$IP $MACHINE_COMMAND

    export MACHINE_COMMAND="touch secAccessKey.txt; echo $4 > secAccessKey.txt; ls; pwd"
    sudo ssh -oStrictHostKeyChecking=no -i "/home/runner/candidate.pem" ubuntu@$IP $MACHINE_COMMAND

    export MACHINE_COMMAND="sh /srv/app/Infrastructure/scripts/runDockerContainers.sh"
    sudo ssh -oStrictHostKeyChecking=no -i "/home/runner/candidate.pem" ubuntu@$IP $MACHINE_COMMAND

    # export MACHINE_COMMAND="rm accessKey.txt; rm secAccessKey.txt"
    # sudo ssh -oStrictHostKeyChecking=no -i "/home/runner/candidate.pem" ubuntu@$IP $MACHINE_COMMAND


    ips="$ips,$IP"
done
