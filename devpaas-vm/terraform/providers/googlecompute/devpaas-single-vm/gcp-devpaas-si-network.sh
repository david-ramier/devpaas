#!/usr/bin/env bash

SECONDS=0
echo " Start: " `date`

echo '****** Create dir for Terraform logs ******'
mkdir -p .terraform

export TF_LOG_PATH=".terraform/terraform_vpc.log"
export TF_LOG=TRACE


export TERRAFORM_CMD=$1
export GCP_ACCOUNT_FILE_PATH=$2
export GCP_PROJECT_ID=$3
export GCP_REGION=$4
export GCP_ZONE=$5
export GCP_PLATFORM_NAME=$6
export GCP_MACHINE_TYPE=$7
export GPC_IMAGE_NAME_DEVPAAS=$8

echo "Launching Terraform init ... "
terraform init

terraform $TERRAFORM_CMD                                    \
    -var "account_file_path=$GCP_ACCOUNT_FILE_PATH"         \
    -var "gcloud_project_id=$GCP_PROJECT_ID"                \
    -var "gcloud_region=$GCP_REGION"                        \
    -var "gcloud_zone=$GCP_ZONE"                            \
    -var "platform_name=$GCP_PLATFORM_NAME"                 \
    -var "devpaas_machine_type=$GCP_MACHINE_TYPE"           \
    -var "devpaas_image_name=$GPC_IMAGE_NAME_DEVPAAS"


duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
echo " End: " `date`