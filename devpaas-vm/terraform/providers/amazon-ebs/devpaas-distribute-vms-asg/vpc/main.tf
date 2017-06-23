# Terraform configuration

terraform {
  required_version = "> 0.8.0"

  backend "s3" {
    region  = "eu-west-1"
    bucket  = "mm-devpaas"
    key     = "devpaas-distribute-vms-elb-ags/vpc/terraform.tfstate"
  }
}

# AWS Provider configuration

provider "aws" {
  region = "${var.aws_deployment_region}"
}