#!/usr/bin/env bash

SECONDS=0
echo " Start: " `date`

echo '****** Create dir for Terraform log ******'
mkdir -p .terraform/plan

export TF_LOG_PATH=".terraform/terraform_network.log"
export TF_LOG=TRACE

echo '****** Retrieve your Public ip in order to secure the SSH connectivity to AWS to only your IP ******'
MM_PUBLIC_IP="$(dig @ns1.google.com -t txt o-o.myaddr.1.google.com +short)"
#MM_PUBLIC_IP=84.74.26.93   #HOME ADDRESS

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

export AWS_jenkins_srv_instance_name=${13}
export AWS_jenkins_srv_image_id=${14}
export AWS_jenkins_srv_flavor_name=${15}

export AWS_nexus_srv_instance_name=${16}
export AWS_nexus_srv_image_id=${17}
export AWS_nexus_srv_flavor_name=${18}

export AWS_SONARQUBE_INSTANCE_NAME=${19}
export AWS_SONARQUBE_IMAGE_ID=${20}
export AWS_SONARQUBE_FLAVOR_NAME=${21}
export OBJECT_TO_DELETE_ARRAY=${22}

export TARGET_STRING=""

declare -a objectsToDelete=($OBJECT_TO_DELETE_ARRAY)

for object in "${objectsToDelete[@]}"

do
    echo "Object to delete: $object"
    TARGET_STRING="-target=$object "$TARGET_STRING
    echo -e "Target String: $TARGET_STRING \n"
done

if [ "$TARGET_STRING" = "" ]; then
    echo "Changes will applied to all object in the directory"
else
    echo -e "Changes will applied only to these objects: \n$TARGET_STRING \n"
fi

if   [ "$TERRAFORM_CMD" = "plan" ] ; then
    rm -f terraform.plan
    export TF_PLAN="-out=terraform.plan"
else
    export TF_PLAN=""
fi

echo "Launching Terraform init ... "
terraform init                              \
    -backend-config="region=$AWS_REGION"    \
    -backend-config="bucket=mm-devpaas"     \
    -backend-config="key=devpaas-distribute-vms-elb-ags/vpc/terraform.tfstate"     \

echo "Launching Terraform command: $TERRAFORM_CMD"

terraform $TERRAFORM_CMD                                                        \
        -var "profile=$AWS_PROFILE"                                             \
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
        -var "jenkins_srv_instance_name=$AWS_jenkins_srv_instance_name"         \
        -var "jenkins_srv_image_id=$AWS_jenkins_srv_image_id"                   \
        -var "jenkins_srv_flavor_name=$AWS_jenkins_srv_flavor_name"             \
        -var "nexus_srv_instance_name=$AWS_nexus_srv_instance_name"             \
        -var "nexus_srv_image_id=$AWS_nexus_srv_image_id"                       \
        -var "nexus_srv_flavor_name=$AWS_nexus_srv_flavor_name"                 \
        -var "sonarqube_instance_name=$AWS_SONARQUBE_INSTANCE_NAME"             \
        -var "sonarqube_image_id=$AWS_SONARQUBE_IMAGE_ID"                       \
        -var "sonarqube_flavor_name=$AWS_SONARQUBE_FLAVOR_NAME"                 \
        $TARGET_STRING $TF_PLAN


duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
echo " End: " `date`