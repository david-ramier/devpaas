#!/bin/bash -e

# Create a group and user nexus to run it
echo "***** Nexus group creation *****"
#sudo groupadd -r nexus
echo "***** Nexus user Creation *****"
sudo adduser --no-create-home --disabled-login --disabled-password nexus

echo "***** Download Nexus *****"
mkdir /home/packer/nexus/
wget --no-check-certificate \
 'https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-3.1.0-04-unix.tar.gz' \
 -O /home/packer/nexus/nexus-3.1.0-04-unix.tar.gz

sudo mkdir /var/lib/sonatype
sudo cp /home/packer/nexus/nexus-3.1.0-04-unix.tar.gz /var/lib/sonatype/
cd /var/lib/sonatype/
echo "***** Extract Nexus *****"
sudo tar xvzf nexus-3.1.0-04-unix.tar.gz
sudo ln -s nexus-3.1.0-04 nexus
sudo rm -f nexus-3.1.0-04-unix.tar.gz
sudo chown -R nexus:nexus /var/lib/sonatype
