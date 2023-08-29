#!/bin/bash
sudo apt update -y
sudo apt install -y git 

#Clone test-app repo
mkdir -p /srv/app
sudo chmod 755 /srv/app
git clone https://github.com/MateoMatta/DevOps-Interview-AC /srv/app

cd
mkdir test
chmod 644 test
cd test

sudo apt update -y
sudo apt install git -y
sudo mkdir /home/runner/app_content
sudo chmod 755 /home/runner/app_content
echo ''
sudo cp ./Dockerfile /home/runner/app_content/Dockerfile
sudo ls /home/runner/app_content/
#Install ansible
sudo apt install ansible -y
#Run Ansible playbook
# ansible-playbook /srv/app/Infrastructure/conf_mgmt_ansible/playbooks/02-image-pull-and-deploy.yml -e ansible_password='{{ lookup("env", "ANSIBLE_PASSWORD", "OTHER_PASSWORD") }}'
ansible-playbook /srv/app/Infrastructure/conf_mgmt_ansible/playbooks/02-image-pull-and-deploy.yml

#sudo ls /home/runner/work/DevOps-Interview-AC/DevOps-Interview-AC/Infrastructure/conf_mgmt_ansible/playbooks


#AWS_ACCESS_KEY_ID=123 AWS_SECRET_ACCESS_KEY=3456 aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 729158664723.dkr.ecr.us-east-1.amazonaws.com
#sudo docker run -d -p 80:80 --name main-applications-registry 729158664723.dkr.ecr.us-east-1.amazonaws.com/main-applications-registry
#sudo docker images
#sudo docker run -d -p 80:80 --name httpd httpd
#curl localhost:8080


#Install Docker

#Install ansible
# sudo apt install ansible -y

# sudo su #Just for ec2 machine, not container
# ansible-playbook 01-image-build-and-push.yml
# exit #Just for ec2 machine, not container

# #Run nginx-test-app server
# cd /srv/app/test-app
# ##### PROCESS TO RUN APP !
