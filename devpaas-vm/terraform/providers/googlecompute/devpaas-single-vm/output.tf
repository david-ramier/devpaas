
output "mm-jenkins-01" {
  value = "${google_compute_instance.jenkins.network_interface.access_config.assigned_nat_ip}"
}