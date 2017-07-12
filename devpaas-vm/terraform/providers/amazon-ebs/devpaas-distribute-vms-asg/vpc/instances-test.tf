/*
 *  List of instances
 */

/* ********************************************************************** */
/* JUMP BOX VM DEFINITION                                                 */
/* ********************************************************************** */
resource "aws_instance" "mm_devpaas_dv_jumpbox" {

  ami                     = "${var.jumpbox_image_id}"
  instance_type           = "${var.jumpbox_flavor_name}"
  subnet_id               = "${aws_subnet.mm_devpaas_sb_public.id}"
  key_name                = "${var.aws_ssh_key_name}"
  vpc_security_group_ids  = ["${aws_security_group.mm_devpaas_sg_jb.id}"]  // ["${var.sg_jumpbox_id}"]

  /*
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World ! This is the DevPaas Jump Box VM" > index.html
              nohup busybox httpd -f -p 80 &
              EOF
  */

  tags {
    Name = "${var.jumpbox_instance_name}"
  }

}

resource "aws_eip_association" "mm_devpaas_eip_jb_assoc" {

  instance_id   = "${aws_instance.mm_devpaas_dv_jumpbox.id}"
  allocation_id = "${aws_eip.mm_devpaas_admin_eip.id}"                      //"${var.mm_devpaas_eip_id}"

}