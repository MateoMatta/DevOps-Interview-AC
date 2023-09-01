export AWS_ACCESS_KEY_ID=$(cat accessKey.txt)
export AWS_SECRET_ACCESS_KEY=$(cat secAccessKey.txt)
aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 729158664723.dkr.ecr.us-east-1.amazonaws.com
sudo docker run --name main-applications-registry -p 80:80 -d 729158664723.dkr.ecr.us-east-1.amazonaws.com/main-applications-registry