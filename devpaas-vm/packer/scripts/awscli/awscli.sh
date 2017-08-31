#!/bin/bash -ex

echo "Installing awscli via pip ..."
sudo pip install awscli

echo "Verify awscli installation ..."
aws --version