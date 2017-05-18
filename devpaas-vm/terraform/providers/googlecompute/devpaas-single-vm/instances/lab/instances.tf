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