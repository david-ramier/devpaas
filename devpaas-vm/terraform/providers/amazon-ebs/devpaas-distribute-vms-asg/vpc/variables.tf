# --------------------------------------------------------------------------------------
#    List of Input variables
# --------------------------------------------------------------------------------------

variable "profile" {
  default     = "marmac-marcomaccio"
  description = ""
}

variable "project_name"           {
  default     = "mm-devpaas-dv-asg"
  description = "Name of the project for this infrastructure"
}

variable "aws_deployment_region"  {
  default     = "eu-west-1"
  description = "AWS region in which this infrastructure will be deployed"
}

variable "sns_email"              {
  default     = "marcus.maccio@gmail.com"
  description = ""
}

variable "vpc_cidr"               {
  default     = "10.0.0.0/16"
  description = "Default CIDR for the DevPaas project"
}

variable "subnet_public_cidr"     {
  default     = "10.0.1.0/24"
  description = "Subnet CIDR for Public IP addresses"
}

variable "subnet_private_cidr"    {
  default     = "10.0.2.0/24"
  description = "Subnet CIDR for Private IP addresses"
}

variable "mm_public_ip"           {
  default     = ""
  description = "This is the public ip of my personal connection from which only enable the ssh traffic"
}

variable "primary_zone_domain_name" {
  default     = "marmac-labs.internal"
  description = "Primary DNS Zone Name"
}

# Instances variables
variable "aws_ssh_key_name"       {
  default     = "marmac_marcomaccio_rsa"
  description = "ssh key name used to connect to the vms"
}


# JUMPBOX VM VARIABLES
variable "jumpbox_instance_name"  {
  default     = "mm-devpaas-jb"
  description = "Name of the instance of the"
}

variable "jumpbox_image_id"       {
  default     = "ami-11be7268"
  description = "Image id for the JumpBox - Default ami-11be7268 (Ubuntu Server 16.04 LTS, SDD Volume Type)"
}

variable "jumpbox_flavor_name"    {
  default     = "t2.micro"
  description = ""
}


# REVERSE-PROXY VM VARIABLES
variable "revprx_instance_name"   {
  default     = "mm-devpaas-rp"
  description = ""
}

variable "revprx_image_id"        {
  default     = "ami-5e884527"
  description = "Image id for the Reverse Proxy (NGINX) - Default ami-5e884527 (Ubuntu Server 16.04 LTS, SDD Volume Type)"
}

variable "revprx_flavor_name"     {
  default     = "t2.micro"
  description = ""
}

variable "revprx_server_port"     {
  default     = "80"
  description = "Port of the Reverse Proxy"
}

/*
# FRON-END VM VARIABLES
variable "fe_srv_instance_name"   {
  default     = "mm-devpaas-fe"
  description = ""
}

variable "fe_srv_image_id"        {
  default     = "ami-a8d2d7ce"
  description = "Image id for the API Server - Default ami-a8d2d7ce (Ubuntu Server 16.04 LTS, SDD Volume Type)"
}

variable "fe_srv_flavor_name"    {
  default     = "t2.micro"
  description = ""
}

variable "fe_server_port"     {
  default     = "9000"
  description = "Port of the Front End VMs"
}
*/

# JENKINS VM VARIABLES
variable "jenkins_srv_instance_name" {
  default     = "mm-devpaas-jenkins"
  description = ""
}

variable "jenkins_srv_image_id"  {
  default     = "ami-4422e03d"
  description = "Image id for the API Server - Default ami-a8d2d7ce (Ubuntu Server 16.04 LTS, SDD Volume Type)"
}

variable "jenkins_srv_flavor_name"    {
  default     = "t2.micro"
  description = ""
}

variable "jenkins_server_port"     {
  default     = "8080"
  description = "Jenkins Master Port"
}

# NEXUS VM VARIABLES
variable "nexus_srv_instance_name" {
  default     = "mm-devpaas-nexus"
  description = ""
}

variable "nexus_srv_image_id"  {
  default     = "ami-89814cf0"
  description = "Image id for the Nexus VM - Default ami-a8d2d7ce (Ubuntu Server 16.04 LTS, SDD Volume Type)"
}

variable "nexus_srv_flavor_name"    {
  default     = "t2.micro"
  description = ""
}

variable "nexus_server_port"     {
  default     = "8081"
  description = "Nexus Port"
}

# SONARQUBE VM VARIABLES
variable "sonarqube_srv_instance_name" {
  default     = "mm-devpaas-sonarqube"
  description = ""
}

variable "sonarqube_srv_image_id"  {
  default     = "ami-68884511"
  description = "Image id for the Sonarqube VM - Default ami-68884511 (Ubuntu Server 16.04 LTS, SDD Volume Type)"
}

variable "sonarqube_srv_flavor_name"    {
  default     = "t2.micro"
  description = ""
}

variable "sonarqube_server_port"     {
  default     = "9000"
  description = "Sonarqube Port"
}

# DB VM VARIABLES
variable "db_instance_name" {
  default     = "mm-devpaas-db"
  description = ""
}

variable "db_image_id" {
  default     = "ami-a8d2d7ce"
  description = ""
}

variable "db_flavor_name" {
  default     = "t2.micro"
  description = ""
}