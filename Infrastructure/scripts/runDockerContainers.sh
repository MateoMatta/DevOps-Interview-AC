
export AWS_ACCESS_KEY_IDD=$(cat /home/ubuntu/accessKey.txt)
export AWS_SECRET_ACCESS_KEYY=$(cat  /home/ubuntu/secAccessKey.txt)
# cd /root
# apt update -y; apt install unzip curl -y;curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip";unzip awscliv2.zip;./aws/install --update
aws --version
aws configure set aws_access_key_id $AWS_ACCESS_KEY_IDD
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEYY
aws configure set default.region us-east-1
export AWS_PAGER=""
sudo echo 'output = json' >> ~/.aws/config
# cat ~/.aws/config
echo 'Authenticating...'
aws sts get-caller-identity  > /dev/null 2>&1
AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_IDD AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEYY aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 729158664723.dkr.ecr.us-east-1.amazonaws.com
sudo docker run --name main-applications-registry -p 80:80 -d 729158664723.dkr.ecr.us-east-1.amazonaws.com/main-applications-registry