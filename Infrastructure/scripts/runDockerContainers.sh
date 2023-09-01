export AWS_ACCESS_KEY_IDD=$(cat /home/ubuntu/accessKey.txt)
export AWS_SECRET_ACCESS_KEYY=$(cat  /home/ubuntu/secAccessKey.txt)
AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_IDD AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEYY aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 729158664723.dkr.ecr.us-east-1.amazonaws.com
sudo docker run --name main-applications-registry -p 80:80 -d 729158664723.dkr.ecr.us-east-1.amazonaws.com/main-applications-registry