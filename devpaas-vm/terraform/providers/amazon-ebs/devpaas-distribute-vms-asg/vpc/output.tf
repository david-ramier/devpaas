/*
 *  The outfile file recaps the output variables created by terraform
 */


output "aws_mm_devpaas_dv_eip_admin_id" {
  value="${aws_eip.mm_devpaas_admin_eip.id}"
}

output "aws_mm_devpaas_dv_eip_admin_ip" {
  value="${aws_eip.mm_devpaas_admin_eip.public_ip}"
}

/* VPC output */

output "aws_mm_devpaas_dv_vpc_id" {
  value="${aws_vpc.mm_devpaas_vpc.id}"
}

/* Subnets output        */

output "aws_mm_devpaas_dv_sb_private_id" {
  value="${aws_subnet.mm_devpaas_sb_private.id}"
}

output "aws_mm_devpaas_dv_sb_public_id" {
  value="${aws_subnet.mm_devpaas_sb_public.id}"
}

/* Security Groups output */

output "aws_mm_devpaas_dv_sg_headend_id" {
  value = "${aws_security_group.mm_devpaas_sg_he.id}"
}

output "aws_mm_devpaas_dv_sg_frontend_id" {
  value = "${aws_security_group.mm_devpaas_sg_fe.id}"
}

output "aws_mm_devpaas_dv_sg_revproxy_id" {
  value = "${aws_security_group.mm_devpaas_sg_rp.id}"
}

output "aws_mm_devpaas_dv_sg_jumpbox_id" {
  value = "${aws_security_group.mm_devpaas_sg_jb.id}"
}

output "aws_mm_devpaas_dv_sg_packerbuilder_id" {
  value = "${aws_security_group.mm_devpaas_sg_pb.id}"
}

/* Instances output variable

# JumpBox VM outputs
output "aws_mm_devpaas_dv_i_jumpbox_id" {
  value = "${aws_instance.mm_devpaas_dv_jumpbox.id}"
}

output "aws_mm_devpaas_dv_i_jumpbox_pub_ip" {
  value = "${aws_instance.mm_devpaas_dv_jumpbox.public_ip}"
}

output "aws_mm_devpaas_dv_i_jumpbox_priv_ip" {
  value = "${aws_instance.mm_devpaas_dv_jumpbox.private_ip}"
}

output "aws_mm_devpaas_dv_i_jumpbox_pub_dns" {
  value = "${aws_instance.mm_devpaas_dv_jumpbox.public_dns}"
}

# Reverse Proxy VM outputs
output "aws_mm_devpaas_dv_i_reverse_proxy_id" {
  value = "${aws_instance.mm_devpaas_dv_reverse_proxy.id}"
}

output "aws_mm_devpaas_dv_i_reverse_proxy_pub_ip" {
  value = "${aws_instance.mm_devpaas_dv_reverse_proxy.public_ip}"
}

output "aws_mm_devpaas_dv_i_reverse_proxy_pub_dns" {
  value = "${aws_instance.mm_devpaas_dv_reverse_proxy.public_dns}"
}

output "aws_mm_devpaas_dv_i_reverse_proxy_priv_ip" {
  value = "${aws_instance.mm_devpaas_dv_reverse_proxy.private_ip}"
}

# Front End VM outputs
output "aws_mm_devpaas_dv_i_front_end_id" {
  value = "${aws_instance.mm_devpaas_dv_fe_srv.id}"
}

output "aws_mm_devpaas_dv_i_front_end_priv_ip" {
  value = "${aws_instance.mm_devpaas_dv_fe_srv.private_ip}"
}

# Head End VM outputs
output "aws_mm_devpaas_dv_i_head_end_id" {
  value = "${aws_instance.mm_devpaas_dv_api_srv.id}"
}

output "aws_mm_devpaas_dv_i_head_end_priv_ip" {
  value = "${aws_instance.mm_devpaas_dv_api_srv.private_ip}"
}

# DB VM outputs
output "aws_mm_devpaas_dv_i_db_id" {
  value = "${aws_instance.mm_devpaas_dv_db.id}"
}

output "aws_mm_devpaas_dv_i_db_priv_ip" {
  value = "${aws_instance.mm_devpaas_dv_db.private_ip}"
}
*/