output "mm_devpaas_network_public_name" {
  value = "${google_compute_network.devpass_si_network.name}"
}

output "mm_devpaas_network_public_id" {
  value = "${google_compute_network.devpass_si_network.id}"
}

output "mm_devpaas_vm_01_id" {
  value = "${google_compute_instance.devpass_vm_singleinstance.id}"
}

output "mm_devpaas_vm_01_name" {
  value = "${google_compute_instance.devpass_vm_singleinstance.name}"
}

output "mm_devpaas_vm_01_ip" {
  value = "${google_compute_instance.devpass_vm_singleinstance.network_interface.0.access_config.0.assigned_nat_ip}"
}