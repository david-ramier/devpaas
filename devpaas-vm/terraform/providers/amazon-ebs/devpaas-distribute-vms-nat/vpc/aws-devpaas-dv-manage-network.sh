#!/usr/bin/env bash

SECONDS=0
echo " Start: " `date`

echo '****** Create dir for Terraform log ******'
mkdir -p .terraform

export TF_LOG_PATH=".terraform/terraform_network.log"
export TF_LOG=TRACE

echo '****** Retrieve your Public ip in order to secure the SSH connectivity to AWS to only your IP ******'
MM_PUBLIC_IP="$(dig @ns1.google.com -t txt o-o.myaddr.1.google.com +short)"

echo "Your Public IP address is: $MM_PUBLIC_IP"

terraform init

export AWS_SSH_KEY=$1

export AWS_REGION=$2
export AWS_VPC_CDIR=$3
export AWS_SUBNET_PUB_CIDR=$4
export AWS_SUBNET_PRIV_CIDR=$5

export AWS_JUMPBOX_INSTANCE_NAME=$6
export AWS_JUMPBOX_IMAGE_ID=$7
export AWS_jumpbox_flavor_name=$8

export AWS_revprx_instance_name=$9
export AWS_revprx_image_id=${10}
export AWS_revprx_flavor_name=${11}

export AWS_fe_srv_instance_name=${12}
export AWS_fe_srv_image_id=${13}
export AWS_fe_srv_flavor_name=${14}

export AWS_api_srv_instance_name=${15}
export AWS_api_srv_image_id=${16}
export AWS_api_srv_flavor_name=${17}

export AWS_DB_INSTANCE_NAME=${18}
export AWS_DB_IMAGE_ID=${19}
export AWS_DB_FLAVOR_NAME=${20}

export TERRAFORM_CMD=${21}

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
TF_VAR_fe_srv_instance_name=$AWS_fe_srv_instance_name                   \
TF_VAR_fe_srv_image_id=$AWS_fe_srv_image_id                             \
TF_VAR_fe_srv_flavor_name=$AWS_fe_srv_flavor_name                       \
TF_VAR_api_srv_instance_name=$AWS_api_srv_instance_name                 \
TF_VAR_api_srv_image_id=$AWS_api_srv_image_id                           \
TF_VAR_api_srv_flavor_name=$AWS_api_srv_flavor_name                     \
TF_VAR_db_instance_name=$AWS_DB_INSTANCE_NAME                           \
TF_VAR_db_image_id=$AWS_DB_IMAGE_ID                                     \
TF_VAR_db_flavor_name=$AWS_DB_FLAVOR_NAME                               \
terraform $TERRAFORM_CMD


duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
echo " End: " `date`