#!/bin/bash -eux

echo "***** Nexus user creation *****"
sudo adduser --no-create-home --disabled-login --disabled-password nexus

echo "***** Download Nexus 3 *****"
mkdir $HOME/nexus/
wget --no-check-certificate \
 'https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-3.1.0-04-unix.tar.gz' \
 -O $HOME/nexus/nexus-3.1.0-04-unix.tar.gz

echo "***** Create Sonatype dir and copy the tar.gz file *****"
sudo mkdir /var/lib/sonatype
sudo cp $HOME/nexus/nexus-3.1.0-04-unix.tar.gz /var/lib/sonatype/

echo "***** Extract Nexus *****"
cd /var/lib/sonatype/
sudo tar xvzf nexus-3.1.0-04-unix.tar.gz
sudo ln -s nexus-3.1.0-04 nexus
sudo rm -f nexus-3.1.0-04-unix.tar.gz

echo "***** Create some dirs for Nexus *****"
sudo mkdir -p nexus/bin/jsw/conf/
sudo mkdir -p sonatype-work/home/
sudo chown -R nexus:nexus /var/lib/sonatype

echo '****** Nexus Service Configuration ******'
sudo cp /tmp/nexus/resources/nexus.service        /etc/systemd/system/
sudo cp /tmp/nexus/resources/wrapper.conf         /var/lib/sonatype/nexus/bin/jsw/conf/

sudo systemctl daemon-reload
sudo systemctl enable nexus.service
sudo systemctl start nexus.service
