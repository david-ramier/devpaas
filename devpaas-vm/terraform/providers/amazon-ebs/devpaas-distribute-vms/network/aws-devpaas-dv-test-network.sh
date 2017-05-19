#!/usr/bin/env bash

SECONDS=0
echo " Start: " `date`

echo '****** Retrieve your Public ip in order to secure the SSH connectivity to AWS to only your IP ******'
MM_PUBLIC_IP="$(dig @ns1.google.com -t txt o-o.myaddr.1.google.com +short)"

echo "Your Public IP address is: $MM_PUBLIC_IP"

echo '****** Retrieve script params ******'
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

echo '****** Retrieve Terraform outputs from Terraform state file ******'

export JB_PUB_IP="$(terraform output aws_mm_devpaas_dv_eip_admin_ip)"
export JB_PUB_DNS="$(terraform output aws_mm_devpaas_dv_i_jumpbox_pub_dns)"

export RP_PUB_IP="$(terraform output aws_mm_devpaas_dv_i_reverse_proxy_pub_ip)"
export RP_PUB_DNS="$(terraform output aws_mm_devpaas_dv_i_reverse_proxy_pub_dns)"
export RP_PRIV_IP="$(terraform output aws_mm_devpaas_dv_i_reverse_proxy_priv_ip)"

export FE_PRIV_IP="$(terraform output aws_mm_devpaas_dv_i_front_end_priv_ip)"
export HE_PRIV_IP="$(terraform output aws_mm_devpaas_dv_i_front_end_priv_ip)"
export DB_PRIV_IP="$(terraform output aws_mm_devpaas_dv_i_db_priv_ip)"

echo "JB_PUB_IP:    $JB_PUB_IP"
echo "JB_PUB_DNS:   $JB_PUB_DNS"
echo "RP_PUB_IP:    $RP_PUB_IP"
echo "RP_PUB_DNS:   $RP_PUB_DNS"
echo "RP_PRIV_IP:   $RP_PRIV_IP"
echo "FE_PRIV_IP:   $FE_PRIV_IP"
echo "HE_PRIV_IP:   $HE_PRIV_IP"
echo "DB_PRIV_IP:   $DB_PRIV_IP"


export AWS_KEY_PATH="$HOME/.aws/$AWS_SSH_KEY.pem"
echo "AWS Key path: $AWS_KEY_PATH"

echo "Testing ssh connectivity to the Jump-Box"
ssh -i "${AWS_KEY_PATH}" ubuntu@${JB_PUB_IP} 'ls -al; exit'

echo "Creating a hidden dir in the Jump-Box to store private key"
ssh -i "${AWS_KEY_PATH}" ubuntu@${JB_PUB_IP} 'mkdir -p /home/ubuntu/.aws; exit'

echo "Copy the private key in the Jump-Box to be used to connect to the other VM internally"
scp -i "${AWS_KEY_PATH}" ${AWS_KEY_PATH} ubuntu@${JB_PUB_IP}:/home/ubuntu/.aws

echo "Change permission on the private key"
ssh -i "${AWS_KEY_PATH}" ubuntu@${JB_PUB_IP} "'chmod 400 /home/ubuntu/.aws/$AWS_SSH_KEY.pem; exit'"


echo "************************************************************"
echo "Testing ICMP Internal traffic from Jump-Box to other VMs ..."

echo "Ping the Reverse Proxy VM at the Private IP: $RP_PRIV_IP"
ssh -i "${AWS_KEY_PATH}" ubuntu@${JB_PUB_IP} bash -c "'ping $RP_PRIV_IP -c 2; exit'"

echo "Ping the Front End VM at the Private IP: $FE_PRIV_IP"
ssh -i "${AWS_KEY_PATH}" ubuntu@${JB_PUB_IP} bash -c "'ping $FE_PRIV_IP -c 2; exit'"

echo "Ping the Head End VM at the Private IP: $HE_PRIV_IP"
ssh -i "${AWS_KEY_PATH}" ubuntu@${JB_PUB_IP} bash -c "'ping $HE_PRIV_IP -c 2; exit'"

echo "Ping the DB End VM at the Private IP: $DB_PRIV_IP"
ssh -i "${AWS_KEY_PATH}" ubuntu@${JB_PUB_IP} bash -c "'ping $DB_PRIV_IP -c 2; exit'"


echo "************************************************************"
echo "Testing SSH Internal connectivity from Jump-Box to other VMs ..."
#ssh -i "${AWS_KEY_PATH}" ubuntu@${JB_PUB_IP} bash -c "'ssh -i \"${AWS_KEY_PATH}\" ubuntu@$RP_PRIV_IP bash -c \"'echo \"Hello from $HOSTNAME \" '\" '"


echo "************************************************************"
echo "Testing the HTTP Endpoints ... "

echo "Testing the end point on the Jump Box"
curl http://${JB_PUB_IP}

echo "Testing the end point on the Reverse Proxy"
curl http://$RP_PUB_DNS

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
echo " End: " `date`
