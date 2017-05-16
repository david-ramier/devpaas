/*
  This is the file that holds all the global input variables
*/

variable "gcloud_project_id"             {
  default = ""
}

variable "gcloud_region"                 {
  default = "europe-west1"
}

variable "gcloud_zone"                   {
  default = "europe-west1-b"
}

variable "platform_name"          {
  default = "mmm-devpaas-si"
}

variable "devpaas_machine_type"   {
  default = ""
}

variable "devpaas_image_name"     {
  default = ""
}

variable "account_file_path"      {
  default = ""
}