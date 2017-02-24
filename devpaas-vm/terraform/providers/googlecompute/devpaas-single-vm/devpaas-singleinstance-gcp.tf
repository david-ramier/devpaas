variable "project_id"             {}
variable "region"                 {}
variable "devpaas_machine_type"   {}
variable "devpaas_image_name"     {}
//variable "webserver_machine_type" {}
//variable "webserver_image_name"   {}

// Configure the Google Cloud provider
provider "google" {
  credentials = ""        //"${var.gcp-secret-file}"
  project     = "${var.project_id}"
  region      = "${var.region}"
}

// Create a new instance
resource "google_compute_instance" "jenkins" {
  name         = "mm-devpaas-01"
  machine_type = "${var.devpaas_machine_type}"
  zone         = "${var.region}"
  tags 		   = ["devpaas-si"]

  disk {
    image = "${var.devpaas_image_name}"
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
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

resource "google_compute_firewall" "default" {
  name    = "mm-www-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "8081", "9000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["jenkins", "nexus", "sonarqube"]
}

output "mm-jenkins-01" {
  value = "${google_compute_instance.jenkins.network_interface.access_config.assigned_nat_ip}"
}

/**
output "mm-webserver-01" {
  value = "${google_compute_instance.webserver.network_interface.access_config.assigned_nat_ip}"
}
*/