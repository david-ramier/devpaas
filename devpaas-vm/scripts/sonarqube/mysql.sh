#!/bin/bash -e

echo "***** Install Mysql Server *****"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password devpaas'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password devpaas'
sudo apt-get -y install mysql-server
