/*
    List of Input variables
 */
variable aws_ssh_key_name               {
  default     = ""
  description = ""
}

variable aws_deployment_region      {
  default     = "us-east-1"
  description = ""
}

variable "subnet_public_id"         {
  description = "Subnet ID for Public IP addresses"
}

variable "subnet_private_id"        {
  description = "Subnet ID for Private IP addresses"
}

variable "mm_devpaas_eip_id"        {
  default     = ""
  description = ""
}

variable "sg_jumpbox_id"            {
  default     = ""
  description = ""
}

variable "sg_headend_id"            {
  description = ""
}

variable "sg_frontend_id"           {
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