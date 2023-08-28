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
sudo ls /home/runner/work/DevOps-Interview-AC/DevOps-Interview-AC/Infrastructure/conf_mgmt_ansible/playbooks
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" -y
sudo apt-cache policy docker-ce
sudo apt install docker-ce -y
#Install Docker

#Install ansible
# sudo apt install ansible -y

#Run Ansible playbook
# cd /srv/app/Infrastructure/conf_mgmt_ansible/playbooks
# sudo su #Just for ec2 machine, not container
# ansible-playbook 01-image-build-and-push.yml
# exit #Just for ec2 machine, not container

# #Run nginx-test-app server
# cd /srv/app/test-app
# ##### PROCESS TO RUN APP !
