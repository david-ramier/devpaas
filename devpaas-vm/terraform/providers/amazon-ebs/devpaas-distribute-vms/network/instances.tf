/*
 *  List of instances
 */

resource "aws_instance" "mm_devpaas_dv_jumpbox" {

  ami                     = "${var.jumpbox_image_id}"
  instance_type           = "${var.jumpbox_flavor_name}"
  subnet_id               = "${aws_subnet.mm_devpaas_sb_public.id}"
  key_name                = "${var.aws_ssh_key_name}"
  vpc_security_group_ids  = ["${aws_security_group.mm_devpaas_sg_jb.id}"]  // ["${var.sg_jumpbox_id}"]

  /*
  provisioner "remote-exec" {

    connection {
      type        = "ssh"
      agent       = "false"
      host        = "${aws_eip.mm_devpaas_admin_eip.public_ip}"
      user        = "ec2-user"
      private_key = "${var.aws_ssh_key_name}"
    }

  }
  */

  tags {
    Name = "${var.jumpbox_instance_name}"
  }

}

resource "aws_eip_association" "mm_devpaas_eip_assoc" {

  instance_id   = "${aws_instance.mm_devpaas_dv_jumpbox.id}"
  allocation_id = "${aws_eip.mm_devpaas_admin_eip.id}"                      //"${var.mm_devpaas_eip_id}"

}


resource "aws_instance" "mm_devpaas_dv_reverse_proxy" {

  ami                     = "${var.revprx_image_id}"
  instance_type           = "${var.revprx_flavor_name}"
  subnet_id               = "${aws_subnet.mm_devpaas_sb_public.id}"         // "${var.subnet_public_id}"
  key_name                = "${var.aws_ssh_key_name}"
  vpc_security_group_ids  = ["${aws_security_group.mm_devpaas_sg_fe.id}"]  // ["${var.sg_frontend_id}"]

  tags {
    Name = "${var.revprx_instance_name}"
  }

}


resource "aws_instance" "mm_devpaas_dv_jenkins_master" {

  ami                     = "${var.jenkins_master_image_id}"
  instance_type           = "${var.jenkins_master_flavor_name}"
  subnet_id               = "${aws_subnet.mm_devpaas_sb_private.id}"         // "${var.subnet_public_id}"
  key_name                = "${var.aws_ssh_key_name}"
  vpc_security_group_ids  = ["${aws_security_group.mm_devpaas_sg_he.id}"]  // ["${var.sg_headend_id}"]

  tags {
    Name = "${var.jenkins_master_instance_name}"
  }

}
/*
resource "aws_instance" "mm_devpaas_dv_mysql" {

  ami                     = "${var.mysql_image_id}"
  instance_type           = "${var.mysql_flavor_name}"
  subnet_id               = "${aws_subnet.mm_devpaas_sb_private.id}"         // "${var.subnet_public_id}"
  key_name                = "${var.aws_ssh_key_name}"
  vpc_security_group_ids  = ["${aws_security_group.mm_devpaas_sg_db.id}"]  // ["${var.sg_headend_id}"]

  tags {
    Name = "${var.jenkins_master_instance_name}"
  }

}
*/