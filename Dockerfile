# Dockerfile for app stack installation
# To build locally the image, use: sudo docker build --no-cache -t test-app .
# To run locally the image, use: docker run -d -p 8080:80 --name test-app test-app
# Ubuntu 20.04 image
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y
RUN apt-get upgrade -y

# Install Git
RUN apt install -y git 

#Clone test-app repo
RUN mkdir -p /srv/app
RUN chmod 755 /srv/app
RUN git clone https://github.com/MateoMatta/DevOps-Interview-AC /srv/app

#Install ansible
RUN apt install ansible -y

# Install apache
RUN apt-get install apache2 -y

# Prerequisites for installing php7.3
RUN apt-get install -y software-properties-common

RUN add-apt-repository ppa:ondrej/php

RUN apt install -y php7.3-fpm

# Install php7.3 for this set up
RUN apt install -y php7.3

# Extensions of php
RUN apt install php7.3-common php7.3-mysql php7.3-xml php7.3-xmlrpc php7.3-curl php7.3-gd php7.3-imagick php7.3-cli php7.3-dev php7.3-imap php7.3-mbstring php7.3-opcache php7.3-soap php7.3-zip php7.3-intl -y

# Install ufw
RUN apt install ufw -y
RUN ufw app list

# install library
RUN apt-get install libapache2-mod-php7.3


# install additional packages
RUN a2dismod mpm_event &&  a2enmod mpm_prefork &&  a2enmod php7.3

#Run Ansible playbook
RUN ansible-playbook /srv/app/Infrastructure/conf_mgmt_ansible/playbooks/01-image-build-and-push.yml

# Removing the default index.html page and copying the project code
RUN rm -f /var/www/html/index.html

RUN cp /srv/app/Frontend/index.apache-debian.html /var/www/html/

RUN echo '        RedirectMatch 303 ^/?$ /index.apache-debian.html' >> /etc/apache2/sites-enabled/000-default.conf

# Restart apache
RUN service apache2 reload

# Provide executable permissions to the code
RUN chmod -R 0777 /var/www/html/*
RUN chmod -R 0777 /var/*

# Change WORKDIR
WORKDIR /var/www/html

CMD ["apachectl","-D","FOREGROUND"]

RUN a2enmod rewrite

EXPOSE 80
EXPOSE 443