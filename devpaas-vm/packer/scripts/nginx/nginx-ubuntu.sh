#!/bin/bash -ex

echo "Starting NGINX installation ..."

echo "***** NGINX installation from apt-get"
sudo apt-get -y install nginx

echo "***** Deletion of default NGINX configuration"
cd /etc/nginx/sites-available
sudo rm default ../sites-enabled/default

echo "***** Replace NGINX configuration with custom configuration"
sudo cp /tmp/nginx/configs/default.conf /etc/nginx/sites-available/default

sudo nginx -t

sudo systemctl restart nginx

