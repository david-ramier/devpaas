/*
 *  The outfile file recaps the output variables created by terraform
 */

output "aws_mm_devpaas_eip_id" {
  value="${aws_eip.mm_devpaas_nat_eip.id}"
}

output "aws_mm_devpaas_nat_eip" {
  value="${aws_eip.mm_devpaas_nat_eip.public_ip}"
}

output "aws_mm_devpaas_admin_id" {
  value="${aws_eip.mm_devpaas_admin_eip.id}"
}

output "aws_mm_devpaas_admin_eip" {
  value="${aws_eip.mm_devpaas_admin_eip.public_ip}"
}

output "aws_mm_devpaas_vpc_id" {
  value="${aws_vpc.mm_devpaas_vpc.id}"
}

output "aws_mm_devpaas_private_subnet_id" {
  value="${aws_subnet.mm_devpaas_sb_private.id}"
}

output "aws_mm_devpaas_public_subnet_id" {
  value="${aws_subnet.mm_devpaas_sb_public.id}"
}

output "aws_mm_devpaas_sg_headend_id" {
  value = "${aws_security_group.mm_devpaas_sg_he.id}"
}

output "aws_mm_devpaas_sg_frontend_id" {
  value = "${aws_security_group.mm_devpaas_sg_fe.id}"
}

output "aws_mm_devpaas_sg_jumpbox_id" {
  value = "${aws_security_group.mm_devpaas_sg_jb.id}"
}