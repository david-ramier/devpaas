#!/bin/bash -eux

########################################################################
#
# title:          Build Ubuntu Image for DevPaas (Single Instance)
# author:         Marco Maccio (http://marmac.name)
# url:            https://github.com/marcomaccio/devpaas
# description:    Create image for DEVPAAS (Instance) server based on image
#
# to run:         sh build-devpaas-singleinstance-ubuntu-image.sh virtualbox-iso
#
########################################################################

SECONDS=0
echo " Start: " `date`

export ATLAS_TOKEN=$1

echo '****** Build yve ubuntu-1604 image ******'
packer build -force -only=$2 packer-devpaas-single-ubuntu.json

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
echo " End: " `date`
