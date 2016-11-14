#!/bin/bash -e

echo "***** Sonar user creation *****"
sudo adduser --no-create-home --disabled-login --disabled-password sonar

sudo apt-get -y install unzip

cp /tmp/sonarqube/resources/.my.cnf ~/

echo "***** Configure mysql for sonarqube db *****"
mysql -h "localhost" < /tmp/sonarqube/resources/sonarqube.sql

echo "***** Download sonarqube *****"
mkdir /home/packer/sonarqube/
wget https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-6.1.zip \
  -O /home/packer/sonarqube/sonarqube-6.1.zip

sudo mkdir /var/lib/sonarqube
sudo cp /home/packer/sonarqube/sonarqube-6.1.zip /var/lib/sonarqube
cd /var/lib/sonarqube
echo "***** Extract Sonarqube *****"
sudo unzip sonarqube-6.1.zip

sudo ln -s sonarqube-6.1 sonar

sudo cp /tmp/sonarqube/resources/sonar.properties /var/lib/sonarqube/sonar/conf

sudo chown -R sonar:sonar /var/lib/sonarqube
