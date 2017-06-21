# --------------------------------------------------------------------------------------
#    List of Input variables
# --------------------------------------------------------------------------------------

variable "aws_deployment_region"  {
  default = "eu-west-1"
  description = "AWS Region in which this infrastructure will be deployed"
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


# --------------------------------------------------------------------------------------
# Instances variable
# --------------------------------------------------------------------------------------
variable aws_ssh_key_name               {
  default     = ""
  description = ""
}

# --------------------------------------------------------------------------------------
# JUMPBOX VM VARIABLES
# --------------------------------------------------------------------------------------
variable "jumpbox_instance_name"    {
  default     = "mm-devpaas-jb"
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

# --------------------------------------------------------------------------------------
# REVERSE-PROXY VM VARIABLES
# --------------------------------------------------------------------------------------
variable "revprx_instance_name"         {
  default     = "mm-devpaas-rp"
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

# --------------------------------------------------------------------------------------
# FRON-END VM VARIABLES
# --------------------------------------------------------------------------------------
variable "fe_srv_instance_name" {
  default     = "mm-devpaas-fe"
  description = ""
}

variable "fe_srv_image_id"  {
  default     = "ami-a8d2d7ce"
  description = "Image id for the API Server - Default ami-a8d2d7ce (Ubuntu Server 16.04 LTS, SDD Volume Type)"
}

variable "fe_srv_flavor_name"    {
  description = ""
}

# --------------------------------------------------------------------------------------
# API VM VARIABLES
# --------------------------------------------------------------------------------------
variable "api_srv_instance_name" {
  default     = "mm-devpaas-he"
  description = ""
}

variable "api_srv_image_id"  {
  default     = "ami-a8d2d7ce"
  description = "Image id for the API Server - Default ami-a8d2d7ce (Ubuntu Server 16.04 LTS, SDD Volume Type)"
}

variable "api_srv_flavor_name"    {
  description = ""
}

# --------------------------------------------------------------------------------------
# DB VM VARIABLES
# --------------------------------------------------------------------------------------
variable "db_instance_name" {
  default     = "mm-devpaas-db"
  description = ""
}

variable "db_image_id" {
  default     = ""
  description = ""
}

variable "db_flavor_name" {
  default     = ""
  description = ""
}