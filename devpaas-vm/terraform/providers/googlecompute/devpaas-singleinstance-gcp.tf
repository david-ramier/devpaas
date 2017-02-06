variable "project_id"           {}
variable "region"               {}
variable "machine_type"         {}
variable "jenkins_image_name"   {}

// Configure the Google Cloud provider
provider "google" {
  credentials = ""        //"${var.gcp-secret-file}"
  project     = "${var.project_id}"
  region      = "${var.region}"
}

// Create a new instance
resource "google_compute_instance" "jenkins" {
  name         = "mm-devpaas-01"
  machine_type = "${var.machine_type}"
  zone         = "${var.region}"
  tags 		     = ["devpaas-si"]

  disk {
    image = "${var.jenkins_image_name}"
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }
}

output "mm-jenkins-01" {
	value = "${google_compute_instance.jenkins.network_interface.access_config.assigned_nat_ip}"
}

resource "google_compute_firewall" "default" {
  name    = "mm-www-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080", "8081", "9000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["jenkins", "nexus", "sonarqube"]
}
