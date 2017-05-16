#!/usr/bin/env bash

TF_VAR_account_file_path=$1     \
TF_VAR_gcloud_project_id=$2     \
TF_VAR_gcloud_region=$3         \
TF_VAR_gcloud_zone=$4           \
TF_VAR_platform_name=$5         \
TF_VAR_devpaas_machine_type=$6  \
TF_VAR_devpaas_image_name=$7    \
terraform $8