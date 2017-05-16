#!/usr/bin/env bash

SECONDS=0
echo " Start: " `date`

echo '****** Create dir for Terraform log ******'
mkdir -p .terraform

export TF_LOG_PATH=".terraform/terraform_network.log"
export TF_LOG=TRACE

echo '****** Create Retrieve the Public ip ******'
dig @ns1.google.com -t txt o-o.myaddr.1.google.com +short

export AWS_SSH_KEY=$1
export AWS_REGION=$2
export AWS_VPC_CDIR=$3
export AWS_SUBNET_PUB_CIDR=$4
export AWS_SUBNET_PRIV_CIDR=$5
export MM_PUBLIC_IP=$6
export AWS_JUMPBOX_INSTANCE_NAME=$7
export AWS_JUMPBOX_IMAGE_ID=$8
export AWS_jumpbox_flavor_name=$9
export AWS_revprx_instance_name=${10}
export AWS_revprx_image_id=${11}
export AWS_revprx_flavor_name=${12}
export AWS_jenkins_master_instance_name=${13}
export AWS_jenkins_master_image_id=${14}
export AWS_jenkins_master_flavor_name=${15}

export TERRAFORM_CMD=${16}

TF_VAR_aws_ssh_key_name=$AWS_SSH_KEY                                    \
TF_VAR_aws_deployment_region=$AWS_REGION                                \
TF_VAR_vpc_cidr=$AWS_VPC_CDIR                                           \
TF_VAR_subnet_private_cidr=$AWS_SUBNET_PRIV_CIDR                        \
TF_VAR_subnet_public_cidr=$AWS_SUBNET_PUB_CIDR                          \
TF_VAR_mm_public_ip=$MM_PUBLIC_IP                                       \
TF_VAR_jumpbox_instance_name=$AWS_JUMPBOX_INSTANCE_NAME                 \
TF_VAR_jumpbox_image_id=$AWS_JUMPBOX_IMAGE_ID                           \
TF_VAR_jumpbox_flavor_name=$AWS_jumpbox_flavor_name                     \
TF_VAR_revprx_instance_name=$AWS_revprx_instance_name                   \
TF_VAR_revprx_image_id=$AWS_revprx_image_id                             \
TF_VAR_revprx_flavor_name=$AWS_revprx_flavor_name                       \
TF_VAR_jenkins_master_instance_name=$AWS_jenkins_master_instance_name   \
TF_VAR_jenkins_master_image_id=$AWS_jenkins_master_image_id             \
TF_VAR_jenkins_master_flavor_name=$AWS_jenkins_master_flavor_name       \
terraform $TERRAFORM_CMD

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
echo " End: " `date`