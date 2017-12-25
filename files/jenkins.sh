#!/bin/bash

set -e

# SETUP JENKINS
## Install Java OpenJDK 7 and Install Jenkins
apt-get install software-properties-common
add-apt-repository ppa:openjdk-r/ppa -y
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
echo 'deb https://pkg.jenkins.io/debian-stable binary/' | tee -a /etc/apt/sources.list
apt-get update
apt-get install -y mlocate
apt-get install -y openjdk-7-jdk
apt-get install -y jenkins
usermod -aG docker jenkins
systemctl start jenkins
systemctl enable jenkins

## Add Jenkins User
# VARS
export JENKINS_ADMIN_PASSWORD_FILE="/var/lib/jenkins/secrets/initialAdminPassword"
export JENKIN_IP=`curl ifconfig.co`
while [ ! -f $JENKINS_ADMIN_PASSWORD_FILE ]; do echo @$JENKIN_IP: $JENKINS_ADMIN_PASSWORD_FILE file does not exist... sleeping && sleep 2;done
echo sleeping 10 seconds && sleep 10
updatedb
echo "jenkins.model.Jenkins.instance.securityRealm.createAccount(\"$JENKINS_USERNAME\", \"$JENKINS_PASSWORD\")" | java -jar `locate jenkins-cli.jar` -auth admin:`cat /var/lib/jenkins/secrets/initialAdminPassword` -s http://localhost:8080/ groovy =
## Install plugins
## Other plugins to consider: cloudbees-folder build-timeout timestamper ws-cleanup workflow-aggregator pipeline-stage-view git github-branch-source docker-commons github ssh-slaves matrix-auth email-ext mailer credentials-binding
cd /root/ && java -jar `locate jenkins-cli.jar` -s http://localhost:8080/ install-plugin git github github-pullrequest github-branch-source email-ext docker-plugin workflow-aggregator --username $JENKINS_USERNAME --password $JENKINS_PASSWORD
## Change jenkins to only listen on address 127.0.0.1, will be redirected with apache2
sed -i -e 's/--httpPort=$HTTP_PORT/--httpPort=$HTTP_PORT --httpListenAddress=127.0.0.1/' /etc/default/jenkins
systemctl restart jenkins
