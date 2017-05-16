/*
    List of Input variables
 */

variable "aws_deployment_region"  {
  default = "us-east-1"
  description = ""
}

variable "vpc_cidr"               {
  default = "10.0.0.0/16"
  description = "Default CIDR for the DevPaas project"
}


variable "subnet_public_cidr"     {
  default = "10.0.0.0/24"
  description = "Subnet CIDR for Public IP addresses"
}

variable "subnet_private_cidr"    {
  default = "10.0.1.0/24"
  description = "Subnet CIDR for Private IP addresses"
}

variable "mm_public_ip"           {
  default     = ""
  description = "This is the public ip of my personal connection from which only enable the ssh traffic"
}


/* Instances variable */
variable aws_ssh_key_name               {
  default     = ""
  description = ""
}

variable "jumpbox_instance_name"    {
  default     = ""
  description = ""
}

variable "jumpbox_image_id"      {
  default     = "ami-a8d2d7ce"
  description = "Image id for the JumpBox - Default ami-a8d2d7ce (Ubuntu Server 16.04 LTS, SDD Volume Type)"
}

variable "jumpbox_flavor_name"   {
  default     = ""
  description = ""
}

variable "revprx_instance_name"         {
  default     = ""
  description = ""
}

variable "revprx_image_id"       {
  default     = "ami-a8d2d7ce"
  description = "Image id for the Reverse Proxy (NGINX) - Default ami-a8d2d7ce (Ubuntu Server 16.04 LTS, SDD Volume Type)"
}

variable "revprx_flavor_name"    {
  default     = ""
  description = ""
}

variable "jenkins_master_instance_name" {
  description = ""
}

variable "jenkins_master_image_id"  {
  default     = "ami-a8d2d7ce"
  description = "Image id for the Jenkins Master - Default ami-a8d2d7ce (Ubuntu Server 16.04 LTS, SDD Volume Type)"
}

variable "jenkins_master_flavor_name"    {
  description = ""
}