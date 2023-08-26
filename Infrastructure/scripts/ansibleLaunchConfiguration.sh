#!/bin/bash
sudo apt update -y
sudo apt install -y git 

#Clone test-app repo
mkdir -p /srv/app
sudo chmod 755 /srv/app
git clone https://github.com/MateoMatta/DevOps-Interview-AC /srv/app

#Install ansible
sudo apt install ansible -y

#Run Ansible playbook
cd /srv/app/Infrastructure/conf_mgmt_ansible/playbooks
sudo su #Just for ec2 machine, not container
ansible-playbook 01-image-build-and-push.yml
exit
#Inside the playbook, a COPY module copies file "index.nginx-debian.html" to "/var/www/html/" directory

# #Run nginx-test-app server
# cd /srv/app/test-app
# ##### PROCESS TO RUN APP !
