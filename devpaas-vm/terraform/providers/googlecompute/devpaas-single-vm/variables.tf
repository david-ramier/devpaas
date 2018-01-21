/*
  This is the file that holds all the global input variables
*/

variable "gcloud_project_id"      {
  default = "name-marmac-devpaas"
}

variable "gcloud_region"          {
  default = "europe-west1"
}

variable "gcloud_zone"            {
  default = "europe-west1-b"
}

variable "platform_name"          {
  default = "mmm-devpaas-si"
}

variable "devpaas_machine_type"   {
  default = "n1-standard-1"
}

variable "devpaas_image_name"     {
  default = "mm-devpaas-singleinstance-ubuntu"
}

variable "devpaas_cidr"           {
  default = "192.168.1.0/24"
}

variable "account_file_path"      {
  default = ""
}