#!/bin/bash -e
echo "Logstash Installation ..."
echo "deb http://packages.elastic.co/logstash/2.3/debian stable main" | sudo tee -a /etc/apt/sources.list
sudo apt-get -y update
sudo apt-get install -y logstash
sudo mkdir -p /etc/pki/tls/certs
sudo mkdir /etc/pki/tls/private
sudo systemctl daemon-reload
sudo systemctl enable logstash
sudo systemctl start logstash
