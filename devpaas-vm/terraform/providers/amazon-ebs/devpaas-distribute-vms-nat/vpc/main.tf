# Terraform configuration
terraform {
  required_version = "> 0.8.0"

  backend "s3" {
    bucket  = "mm-devpaas"
    key     = "devpaas-distribute-vms-nat/vpc"
  }
}

# AWS Provider configuration

provider "aws" {
  region = "${var.aws_deployment_region}"
}