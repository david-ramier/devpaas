/*
 *  List of instances
 */

resource "aws_instance" "mm_devpaas_dv_jumpbox" {

  ami                     = "${var.jumpbox_image_id}"
  instance_type           = "${var.jumpbox_flavor_name}"
  subnet_id               = "${var.subnet_public_id}"
  key_name                = "${var.aws_ssh_key_name}"
  vpc_security_group_ids  = ["${var.sg_jumpbox_id}"]

  associate_public_ip_address = true

  tags {
    Name = "${var.jumpbox_instance_name}"
  }

}

resource "aws_eip_association" "mm_devpaas_eip_assoc" {

  instance_id   = "${aws_instance.mm_devpaas_dv_jumpbox.id}"
  allocation_id = "${var.mm_devpaas_eip_id}"

}

resource "aws_instance" "mm_devpaas_dv_reverse_proxy" {

  ami                     = "${var.revprx_image_id}"
  instance_type           = "${var.revprx_flavor_name}"
  subnet_id               = "${var.subnet_public_id}"
  key_name                = "${var.aws_ssh_key_name}"
  vpc_security_group_ids  = ["${var.sg_frontend_id}"]

  tags {
    Name = "${var.revprx_instance_name}"
  }

}

resource "aws_instance" "mm_devpaas_dv_jenkins_master" {

  ami                     = "${var.jenkins_master_image_id}"
  instance_type           = "${var.jenkins_master_flavor_name}"
  subnet_id               = "${var.subnet_private_id}"
  key_name                = "${var.aws_ssh_key_name}"
  vpc_security_group_ids  = ["${var.sg_headend_id}"]

  /*
  provisioner "remote-exec" {

    connection {
      type        = "ssh"
      agent       = "false"
      user        = "ec2-user"
      private_key = "${var.aws_ssh_key_name}"
    }

  }
  */

  tags {
    Name = "${var.jenkins_master_instance_name}"
  }

}