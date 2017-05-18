

//variable "webserver_machine_type" {}
//variable "webserver_image_name"   {}

// Configure the Google Cloud provider
provider "google" {
  credentials = "${file(var.account_file_path)}"
  project     = "${var.gcloud_project_id}"
  region      = "${var.gcloud_region}"
}

resource "google_compute_network" "devpass_si_network" {
  name       = "${var.platform_name}-network"
}

resource "google_compute_subnetwork" "devpass_si_subnet" {
  name          = "${var.platform_name}"

  region        = "${var.gcloud_region}"
  network       = "${google_compute_network.devpass_si_network.self_link}"
  ip_cidr_range = "10.0.0.0/16"
}

resource "google_compute_firewall" "devpass_si_fr_a_ssh" {
  name    = "${var.platform_name}-fr-allow-ssh"
  network = "${google_compute_network.devpass_si_network.id}"

  allow {
    protocol = "tcp"
    ports    = ["22"] //, "80", "8080", "8081", "9000"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags   = ["ssh"]
}

resource "google_compute_firewall" "devpass_si_fr_a_hhtp_80_8080_8081_9000" {
  name    = "${var.platform_name}-fr-allow-http"
  network = "${google_compute_network.devpass_si_network.id}"

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "8081", "9000"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags   = ["jenkins", "nexus", "sonarqube"]
}

// Create a new instance
resource "google_compute_instance" "jenkins" {
  name         = "${var.platform_name}-01"
  machine_type = "${var.devpaas_machine_type}"
  zone         = "${var.gcloud_zone}"
  tags 		   = ["devpaas-si"]

  disk {
    image = "${var.devpaas_image_name}"
  }

  network_interface {

    subnetwork  = "${google_compute_subnetwork.devpass_si_subnet.name}"

    access_config {
      # ephemeral external ip address
    }
  }
}


/**
 Create a new instance
resource "google_compute_instance" "webserver" {
  name         = "mm-webserver-01"
  machine_type = "${var.webserver_machine_type}"
  zone         = "${var.region}"
  tags 		   = ["webserver"]

  disk {
    image = "${var.webserver_image_name}"
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }
}
*/


/*
module "lab1" {
  source = "./instances/lab/"
  region = "[europe-west1-d, europe-west1-b]"

}

module "lab2" {
  source = "./instances/lab/"

}
*/

/**
output "mm-webserver-01" {
  value = "${google_compute_instance.webserver.network_interface.access_config.assigned_nat_ip}"
}
*/