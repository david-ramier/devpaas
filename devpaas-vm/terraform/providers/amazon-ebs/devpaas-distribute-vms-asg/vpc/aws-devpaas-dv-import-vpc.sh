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

export TERRAFORM_CMD=$1

export AWS_SSH_KEY=$2

export AWS_REGION=$3
export AWS_VPC_CDIR=$4
export AWS_SUBNET_PUB_CIDR=$5
export AWS_SUBNET_PRIV_CIDR=$6

export AWS_JUMPBOX_INSTANCE_NAME=$7
export AWS_JUMPBOX_IMAGE_ID=$8
export AWS_jumpbox_flavor_name=$9

export AWS_revprx_instance_name=${10}
export AWS_revprx_image_id=${11}
export AWS_revprx_flavor_name=${12}

export AWS_fe_srv_instance_name=${13}
export AWS_fe_srv_image_id=${14}
export AWS_fe_srv_flavor_name=${15}

export AWS_api_srv_instance_name=${16}
export AWS_api_srv_image_id=${17}
export AWS_api_srv_flavor_name=${18}

export AWS_DB_INSTANCE_NAME=${19}
export AWS_DB_IMAGE_ID=${20}
export AWS_DB_FLAVOR_NAME=${21}

export OBJECT_TYPE=${22}
export OBJECT_ID=${23}

echo "Launching Terraform init ... "
terraform init

echo "Launching Terraform command: $TERRAFORM_CMD"

terraform $TERRAFORM_CMD                                                        \
        -var "aws_ssh_key_name=$AWS_SSH_KEY"                                    \
        -var "aws_deployment_region=$AWS_REGION"                                \
        -var "vpc_cidr=$AWS_VPC_CDIR"                                           \
        -var "subnet_private_cidr=$AWS_SUBNET_PRIV_CIDR"                        \
        -var "subnet_public_cidr=$AWS_SUBNET_PUB_CIDR"                          \
        -var "mm_public_ip=$MM_PUBLIC_IP"                                       \
        -var "jumpbox_instance_name=$AWS_JUMPBOX_INSTANCE_NAME"                 \
        -var "jumpbox_image_id=$AWS_JUMPBOX_IMAGE_ID"                           \
        -var "jumpbox_flavor_name=$AWS_jumpbox_flavor_name"                     \
        -var "revprx_instance_name=$AWS_revprx_instance_name"                   \
        -var "revprx_image_id=$AWS_revprx_image_id"                             \
        -var "revprx_flavor_name=$AWS_revprx_flavor_name"                       \
        -var "fe_srv_instance_name=$AWS_fe_srv_instance_name"                   \
        -var "fe_srv_image_id=$AWS_fe_srv_image_id"                             \
        -var "fe_srv_flavor_name=$AWS_fe_srv_flavor_name"                       \
        -var "api_srv_instance_name=$AWS_api_srv_instance_name"                 \
        -var "api_srv_image_id=$AWS_api_srv_image_id"                           \
        -var "api_srv_flavor_name=$AWS_api_srv_flavor_name"                     \
        -var "db_instance_name=$AWS_DB_INSTANCE_NAME"                           \
        -var "db_image_id=$AWS_DB_IMAGE_ID"                                     \
        -var "db_flavor_name=$AWS_DB_FLAVOR_NAME"                               \
        $OBJECT_TYPE $OBJECT_ID


duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
echo " End: " `date`