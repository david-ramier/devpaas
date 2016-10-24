// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("name-marmac-php-helloworld-3f6f0025f4a6.json")}"
  project     = "name-marmac-php-helloworld"
  region      = "europe-west1-d"
}

// Create a new instance
resource "google_compute_instance" "jenkins" {
  name         = "mm-jenkins-01"
  machine_type = "n1-standard-1"
  zone         = "europe-west1-d"
  tags 		   = ["jenkins"]

  disk {
    image = "mm-jenkins-2-v20161024"
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
  name    = "tf-www-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["jenkins"]
}