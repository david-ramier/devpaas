#!/bin/bash -eux

########################################################################
#
# title:          Deploy an image for MM DevPaas HeadEnd Component
# author:         Marco Maccio (http://www.marmac.name)
# url:            http://github.com/marcomaccio/devpaas
# description:    Deploy DEVPAAS server as Virtual Box VM
#
# to run:         sh deploy-devpaas-ubuntu-image.sh ~/Deployment/vms/mm mm-elk-ubuntu-16-04  #This deploy the elk image
#
########################################################################

SECONDS=0
echo " Start: " `date`

MM_DEVPAAS_DEPLOYMENT_HOME_DIR=$1       #ex. $1=~/Development/deployment/vms/mm/devpaas
MM_DEVPAAS_IMAGE_NAME=$2                #ex. $2=mm-devpaas-single-ubuntu  - omit extension .tar.gz

echo "Deployment dir: $MM_DEVPAAS_DEPLOYMENT_HOME_DIR"

if [ ! -d "$MM_DEVPAAS_DEPLOYMENT_HOME_DIR/$MM_DEVPAAS_IMAGE_NAME" ]; then
  echo "Create dir: $MM_DEVPAAS_DEPLOYMENT_HOME_DIR/$MM_DEVPAAS_IMAGE_NAME"
  mkdir -p $MM_DEVPAAS_DEPLOYMENT_HOME_DIR/$MM_DEVPAAS_IMAGE_NAME
fi

echo "****** Copy image $MM_DEVPAAS_IMAGE_NAME  tar file into a deployment dir ******"
cp build/$MM_DEVPAAS_IMAGE_NAME.tar.gz $MM_DEVPAAS_DEPLOYMENT_HOME_DIR/

echo "****** Extract devpaas ubuntu-16.04 image from tar.gz file into a deployment dir ******"
cd $MM_DEVPAAS_DEPLOYMENT_HOME_DIR/
tar -xvf $MM_DEVPAAS_IMAGE_NAME.tar.gz -C $MM_DEVPAAS_IMAGE_NAME/

echo "****** Import .ovf file in Virtual Box ******"
vboxmanage import $MM_DEVPAAS_DEPLOYMENT_HOME_DIR/$MM_DEVPAAS_IMAGE_NAME/$MM_DEVPAAS_IMAGE_NAME.ova

echo "****** Start the VM in Virtual Box ******"
vboxmanage startvm --type gui $MM_DEVPAAS_IMAGE_NAME

echo "**************************************************************************"
echo "TO POWER OFF: vboxmanage controlvm $MM_DEVPAAS_UBUNTU_IMAGE_NAME poweroff"
echo "**************************************************************************"

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
echo " End: " `date`