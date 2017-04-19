#!/bin/bash -eux

########################################################################
#
# title:          Build Ubuntu Image for DevPaas (Single Instance)
# author:         Marco Maccio (http://marmac.name)
# url:            https://github.com/marcomaccio/devpaas
# description:    Create image for DEVPAAS (Instance) server based on image
#
# to run:         sh VBOX-build-image-devpaas-baseimage-ubuntu.sh virtualbox-iso
#
########################################################################

SECONDS=0
echo " Start: " `date`
mkdir -p packer_logs

export PACKER_LOG=1
export PACKER_LOG_PATH="./packer_logs/VBOX-packer-devpass-base-ubuntu.log"

export PACKER_PROVIDERS_LIST=$1

export DEBUG=$2

export ATLAS_USERNAME=$2
export ATLAS_TOKEN=$3

export VBOX_SSH_USERNAME=$4
export VBOX_SSH_PASSWORD=$5


echo '****** Build marmac devpaas single instance x ubuntu-1604 image ******'
packer build -force -only=$PACKER_PROVIDERS_LIST  $DEBUG            \
        -var "atlas_username=$ATLAS_USERNAME"                       \
        -var "atlas_token=$ATLAS_TOKEN"                             \
        -var "vbox_ssh_username=$VBOX_SSH_USERNAME"                 \
        -var "vbox_ssh_password=$VBOX_SSH_PASSWORD"                 \
        images/packer-devpaas-base-ubuntu.json

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
echo " End: " `date`
