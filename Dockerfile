# Dockerfile for app stack installation
# To build locally the image, use: sudo docker build --no-cache -t test-app .
# To run locally the image, use: docker run -d -p 8080:80 --name test-app test-app
# Or
# sudo docker run -dit --name my-apache-app -p 80:80 httpd
# Ubuntu 20.04 image
FROM httpd

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -y
RUN apt upgrade -y

# Install Git
RUN apt install -y git 

#Clone test-app repo
RUN mkdir -p /srv/app
RUN chmod 755 /srv/app
RUN git clone https://github.com/MateoMatta/DevOps-Interview-AC /srv/app

#Install ansible
RUN apt install ansible -y

RUN apt clean 

#Run Ansible playbook
RUN ansible-playbook /srv/app/Infrastructure/conf_mgmt_ansible/playbooks/01-image-build-and-push.yml

# Removing the default index.html page and copying the project code
# "/var/www/html/" for Apache2
# "/usr/local/apache2/htdocs/" for httpd
RUN ls /usr/local/apache2/htdocs/
RUN rm -f /usr/local/apache2/htdocs/index.html

RUN cp /srv/app/Frontend/index.apache-debian.html /usr/local/apache2/htdocs
RUN cp /srv/app/Frontend/000-default.conf /usr/local/apache2/conf/


# (lightest image) 
# RUN apt purge ansible --auto-remove --yes
# Safe image (better) 
RUN apt purge ansible --yes

# Restart apache
RUN service apache2 restart

# Provide executable permissions to the code
RUN chmod -R 0777 /usr/local/apache2/htdocs/*
RUN chmod -R 0777 /usr/*

# Change WORKDIR
WORKDIR /usr/local/apache2/htdocs/

