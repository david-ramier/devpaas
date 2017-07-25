#!/bin/bash -ex

echo "Starting NGINX installation ..."

echo "***** NGINX installation from apt-get"
sudo apt-get -y install nginx

echo "***** Verify NGINX configuration "
sudo nginx -t

echo "***** Restart NGINX service to verify that restart works"
sudo systemctl restart nginx