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


#Install ansible
sudo apt install ansible -y

#Run Ansible playbook
cd /srv/app/Infrastructure/conf_mgmt_ansible/playbooks
# sudo su #Just for ec2 machine, not container
# ansible-playbook 01-image-build-and-push.yml
# exit #Just for ec2 machine, not container

# #Run nginx-test-app server
# cd /srv/app/test-app
# ##### PROCESS TO RUN APP !
