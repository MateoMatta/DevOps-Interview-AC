#!/bin/bash
sudo apt update -y
sudo apt install -y git 

#Clone test-app repo
mkdir -p /srv/app
sudo chmod 777 /srv/app
##### CHANGE to chmod 755
# git clone https://github.com/MateoMatta/DevOps-Interview-AC /srv/app

#Install ansible
sudo apt install ansible -y

# #Run Ansible playbook
