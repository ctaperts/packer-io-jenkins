#!/bin/bash

set -e

# SETUP APACHE REVERSE PROXY
mkdir /etc/ssl/jenkins
cd /etc/ssl/jenkins && openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout jenkins.key -out jenkins.crt -subj '/C=US/ST=NY/L=NY/O=jenkins/OU=jenkins/CN=jenkins'
apt-get install apache2 -y
a2enmod proxy proxy_http proxy_html ssl headers
mv /tmp/jenkins.conf /etc/apache2/conf-available/jenkins.conf
ln -s /etc/apache2/conf-available/jenkins.conf /etc/apache2/conf-enabled/
systemctl restart apache2
systemctl enable apache2
