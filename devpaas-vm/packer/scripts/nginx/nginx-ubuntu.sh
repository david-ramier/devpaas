#!/bin/bash -e

echo "***** Starting NGINX installation"

sudo apt-get -y install nginx

sudo cp /tmp/nginx/configs/default.conf /etc/nginx/sites-available/default

sudo nginx -t

sudo systemctl restart nginx

