ips=""
ids=""
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $1 --region $2 --query AutoScalingGroups[].Instances[].InstanceId --output text