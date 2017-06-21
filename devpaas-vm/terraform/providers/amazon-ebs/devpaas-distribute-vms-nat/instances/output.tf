// The outfile file recaps the output variables created by terraform

output "aws_mm_devpaas_jumpbox_id" {
  value="${aws_instance.mm_devpaas_dv_jumpbox.id}"
}

output "aws_mm_devpaas_jumpbox_ip" {
  value="${aws_instance.mm_devpaas_dv_jumpbox.public_ip}"
}

output "aws_mm_devpaas_jenkins_id" {
  value="${aws_instance.mm_devpaas_dv_jenkins_master.id}"
}

output "aws_mm_devpaas_jenkins_ip" {
  value="${aws_instance.mm_devpaas_dv_jenkins_master.private_ip}"
}

output "aws_mm_devpaas_revprx_id" {
  value="${aws_instance.mm_devpaas_dv_reverse_proxy.id}"
}

output "aws_mm_devpaas_revprx_ip" {
  value="${aws_instance.mm_devpaas_dv_reverse_proxy.public_ip}"
}

