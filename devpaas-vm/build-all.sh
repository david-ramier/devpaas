#!/bin/bash -e
echo "IMAGE CREATION PART ..."
SECONDS=0
echo " Start: " `date`

echo "Packaging Jenkins Server..."
rm -rf build
packer build -machine-readable -force $1 packer-jenkins-ubuntu.json

echo "Jenkins Server Packaged !"

echo "Packaging Agilefant Server..."

echo "Agilefant Server Packaged !"

echo "Packaging Gitlab Server..."

echo "Gitlab Server Packaged !"

echo "Packaging Nexus Server..."

echo "Nexus Server Packaged !"

echo "Packaging Sonarqube Server..."

echo "Sonarqube Server Packaged !"

echo "Packaging Elastic, Logstash, Kibana (ELK) Server..."
packer build -machine-readable -force $1 packer-elk-ubuntu.json
echo "Elastic, Logstash, Kibana (ELK) Server Packaged !"

echo "Packaging NGINX Server..."

echo "NGINX Server Packaged !"

echo "IMAGE CREATION PART ended successfully !"

echo "VM CREATION PART ..."

echo "VM CREATION PART ended successfully !"

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
echo " End: " `date`
