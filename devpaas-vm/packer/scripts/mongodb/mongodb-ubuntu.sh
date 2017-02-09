#!/bin/bash -ex

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

echo "deb http://repo.mongodb.org/apt/ubuntu/dists/xenial/mongodb-org/3.4/ multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list

sudo apt-get -y update

sudo apt-get install -y mongodb-org

sudo cp /tmp/mongodb/configs/mongodb.service /etc/systemd/system/mongodb.service

sudo systemctl enable mongodb

sudo systemctl start mongodb