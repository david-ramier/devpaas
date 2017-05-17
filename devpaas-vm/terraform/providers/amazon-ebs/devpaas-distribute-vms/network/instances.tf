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

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 80 &
              EOF

  tags {
    Name = "${var.jumpbox_instance_name}"
  }

}

resource "aws_eip_association" "mm_devpaas_eip_assoc" {

  instance_id   = "${aws_instance.mm_devpaas_dv_jumpbox.id}"
  allocation_id = "${aws_eip.mm_devpaas_admin_eip.id}"                      //"${var.mm_devpaas_eip_id}"

}

/* ********************************************************************** */
/* REVERSE PROXY VM DEFINITION                                            */
/* ********************************************************************** */
resource "aws_instance" "mm_devpaas_dv_reverse_proxy" {

  ami                     = "${var.revprx_image_id}"
  instance_type           = "${var.revprx_flavor_name}"
  subnet_id               = "${aws_subnet.mm_devpaas_sb_public.id}"         // "${var.subnet_public_id}"
  key_name                = "${var.aws_ssh_key_name}"
  vpc_security_group_ids  = ["${aws_security_group.mm_devpaas_sg_rp.id}"]  // ["${var.sg_reverseproxy_id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 80 &
              EOF

  tags {
    Name = "${var.revprx_instance_name}"
  }

}

/* ********************************************************************** */
/* FRONT-END VM DEFINITION                                                */
/* ********************************************************************** */
resource "aws_instance" "mm_devpaas_dv_fe_srv" {

  ami                     = "${var.fe_srv_image_id}"
  instance_type           = "${var.fe_srv_flavor_name}"
  subnet_id               = "${aws_subnet.mm_devpaas_sb_private.id}"         // "${var.subnet_public_id}"
  key_name                = "${var.aws_ssh_key_name}"
  vpc_security_group_ids  = ["${aws_security_group.mm_devpaas_sg_fe.id}"]  // ["${var.sg_headend_id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 9000 &
              EOF

  tags {
    Name = "${var.fe_srv_instance_name}"
  }

}

/* ********************************************************************** */
/* API SERVER VM DEFINITION                                               */
/* ********************************************************************** */
resource "aws_instance" "mm_devpaas_dv_api_srv" {

  ami                     = "${var.api_srv_image_id}"
  instance_type           = "${var.api_srv_flavor_name}"
  subnet_id               = "${aws_subnet.mm_devpaas_sb_private.id}"         // "${var.subnet_public_id}"
  key_name                = "${var.aws_ssh_key_name}"
  vpc_security_group_ids  = ["${aws_security_group.mm_devpaas_sg_he.id}"]  // ["${var.sg_headend_id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  tags {
    Name = "${var.api_srv_instance_name}"
  }

}


/* ********************************************************************** */
/* DB VM DEFINITION                                                       */
/* ********************************************************************** */
resource "aws_instance" "mm_devpaas_dv_db" {

  ami                     = "${var.db_image_id}"
  instance_type           = "${var.db_flavor_name}"
  subnet_id               = "${aws_subnet.mm_devpaas_sb_private.id}"         // "${var.subnet_public_id}"
  key_name                = "${var.aws_ssh_key_name}"
  vpc_security_group_ids  = ["${aws_security_group.mm_devpaas_sg_db.id}"]  // ["${var.sg_headend_id}"]

  tags {
    Name = "${var.db_instance_name}"
  }

}