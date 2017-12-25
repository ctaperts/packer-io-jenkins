#!/bin/bash

set -e

# Setup Postfix",
debconf-set-selections <<< "postfix postfix/mailname string `hostname`"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
apt-get install -y postfix mailutils
sed -i -e 's/inet_interfaces = all/inet_interfaces = localhost/g' /etc/postfix/main.cf
systemctl start postfix
systemctl enable postfix
