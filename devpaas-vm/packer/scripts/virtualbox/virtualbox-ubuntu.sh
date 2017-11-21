#!/bin/bash -e

export VBOX_VERSION="5.1.28"

sudo apt-get install -y linux-headers-$(uname -r) build-essential dkms

cd /tmp
mkdir /tmp/isomount
sudo mount -t iso9660 -o loop $HOME/VBoxGuestAdditions_$VBOX_VERSION.iso /tmp/isomount

# Install the drivers
sudo /tmp/isomount/VBoxLinuxAdditions.run

# Cleanup
sudo umount isomount
sudo rm -rf isomount $HOME/VBoxGuestAdditions_$VBOX_VERSION.iso
