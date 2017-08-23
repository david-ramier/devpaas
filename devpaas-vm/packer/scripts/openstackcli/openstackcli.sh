#!/bin/bash -ex

echo "Installing Openstack client ..."
sudo pip install python-openstackclient

echo "Verify Openstack client installation"
openstack --version