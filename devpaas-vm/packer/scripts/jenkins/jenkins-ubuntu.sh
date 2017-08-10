#!/bin/bash -e
echo "***** JENKINS installation"
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get -y update
sudo apt-get install -y jenkins

echo '****** Installing Jenkins Plugins'
cd /tmp/jenkins/scripts
sudo chmod +x install-jenkins-plugins.sh
sudo ./install-jenkins-plugins.sh plugins.txt
echo 'Installing Jenkins Plugins --> SUCCESS'

echo '****** Stop Jenkins Service ******'
sudo service jenkins stop

echo '****** Moving Jenkins Configuration files ******'
sudo cp /tmp/jenkins/resources/etc-default-jenkins.conf                                     /etc/default/jenkins
sudo cp /tmp/jenkins/resources/config.xml                                                   /var/lib/jenkins/
sudo cp /tmp/jenkins/resources/hudson.tools.JDKInstaller.xml                                /var/lib/jenkins/
sudo cp /tmp/jenkins/resources/hudson.tasks.Ant.xml                                         /var/lib/jenkins/
sudo cp /tmp/jenkins/resources/hudson.tasks.Maven.xml                                       /var/lib/jenkins/
sudo cp /tmp/jenkins/resources/hudson.plugins.git.GitTool.xml                               /var/lib/jenkins/
sudo cp /tmp/jenkins/resources/hudson.plugins.gradle.Gradle.xml                             /var/lib/jenkins/
sudo cp /tmp/jenkins/resources/hudson.plugins.groovy.Groovy.xml                             /var/lib/jenkins/

sudo cp /tmp/jenkins/resources/biz.neustar.jenkins.plugins.packer.PackerPublisher.xml       /var/lib/jenkins/
sudo cp /tmp/jenkins/resources/org.jenkinsci.plugins.terraform.TerraformBuildWrapper.xml    /var/lib/jenkins/

echo '****** Setting up Jenkins admin users'
cd /var/lib/jenkins
sudo mkdir -p users/admin
sudo cp /tmp/jenkins/resources/admin-config.xml /var/lib/jenkins/users/admin/config.xml
echo '****** Start Jenkins Service'
sudo service jenkins start
