/*
 *  List of instances
 */

/* ********************************************************************** */
/* JUMP BOX VM DEFINITION  - START                                        */
/* ********************************************************************** */
data "template_file" "mm_devpaas_dv_tf_user_data_jb" {
  template = "${file("change_hostname.sh.tpl")}"

  vars {
    domain_name = "${var.primary_zone_domain_name}"
    vm_name     = "${var.jumpbox_instance_name}"
  }

}

resource "aws_instance" "mm_devpaas_dv_jumpbox" {

  ami                     = "${var.jumpbox_image_id}"
  instance_type           = "${var.jumpbox_flavor_name}"
  subnet_id               = "${aws_subnet.mm_devpaas_sb_public.id}"
  key_name                = "${var.aws_ssh_key_name}"
  vpc_security_group_ids  = ["${aws_security_group.mm_devpaas_sg_jb.id}"]  // ["${var.sg_jumpbox_id}"]

  user_data               = "${data.template_file.mm_devpaas_dv_tf_user_data_jb.rendered}"

  tags {
    Name = "${var.jumpbox_instance_name}"
  }

  /*
  connection {
    type  = "ssh"
    agent = "false"

    user        = "ubuntu" //to be replaced with a variable
    private_key = "${file("marmac_marcomaccio_rsa.pem")}"

    timeout = "5m"

  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Create directory for private key'",
      "mkdir -p ~/.aws"
    ]
  }

  provisioner "file" {
    source      = "${var.aws_ssh_key_name}.pem"
    destination = "/home/ubuntu/.aws/"
  }
  */

}

resource "aws_eip_association" "mm_devpaas_eip_jb_assoc" {

  instance_id   = "${aws_instance.mm_devpaas_dv_jumpbox.id}"
  allocation_id = "${aws_eip.mm_devpaas_admin_eip.id}"                      //"${var.mm_devpaas_eip_id}"

}

resource "aws_route53_record" "mm_devpaas_dns_r_jb_forward" {

  zone_id = "${aws_route53_zone.mm_devpaas_dns_primary_fw.id}"
  type    = "A"
  name    = "${var.jumpbox_instance_name}"
  records = ["${aws_instance.mm_devpaas_dv_jumpbox.private_ip}"]
  ttl     = "300"

}

resource "aws_route53_record" "mm_devpaas_dns_r_jb_reverse" {

  zone_id = "${aws_route53_zone.mm_devpaas_dns_primary_rv.id}"
  type    = "PTR"
  name    = "${format("%s.%s.0.10.in-addr.arpa",
                  element(split(".",aws_instance.mm_devpaas_dv_jumpbox.private_ip),3),
                  element(split(".",aws_instance.mm_devpaas_dv_jumpbox.private_ip),2))}"
  records = ["${format("mm-devpaas-jb.marmac-labs.internal")}"]

  ttl     = "300"


}

/* ********************************************************************** */
/* JUMP BOX VM DEFINITION  - END                                          */
/* ********************************************************************** */


/* ********************************************************************** */
/* JENKINS MASTER SERVER VM DEFINITION  - START                           */
/* ********************************************************************** */
data "template_file" "mm_devpaas_dv_tf_user_data_jenkins" {
  template = "${file("change_hostname.sh.tpl")}"

  vars {
    domain_name = "${var.primary_zone_domain_name}"
    vm_name     = "${var.jenkins_srv_instance_name}"
  }

}

resource "aws_instance" "mm_devpaas_dv_jenkins" {

  ami                     = "${var.jenkins_srv_image_id}"
  instance_type           = "${var.jenkins_srv_flavor_name}"
  subnet_id               = "${aws_subnet.mm_devpaas_sb_private.id}"
  key_name                = "${var.aws_ssh_key_name}"
  vpc_security_group_ids  = ["${aws_security_group.mm_devpaas_sg_he.id}"]

  user_data = "${data.template_file.mm_devpaas_dv_tf_user_data_jenkins.rendered}"

  tags {
    Name = "${var.jenkins_srv_instance_name}"
  }
}

resource "aws_route53_record" "mm_devpaas_dns_r_jenkins_forward" {

  zone_id = "${aws_route53_zone.mm_devpaas_dns_primary_fw.id}"
  type    = "A"
  name    = "${var.jenkins_srv_instance_name}"
  records = ["${aws_instance.mm_devpaas_dv_jenkins.private_ip}"]
  ttl     = "300"

}

resource "aws_route53_record" "mm_devpaas_dns_r_jenkins_reverse" {

  zone_id = "${aws_route53_zone.mm_devpaas_dns_primary_rv.id}"
  type    = "PTR"
  name    = "${format("%s.%s.0.10.in-addr.arpa",
                  element(split(".",aws_instance.mm_devpaas_dv_jenkins.private_ip),3),
                  element(split(".",aws_instance.mm_devpaas_dv_jenkins.private_ip),2))}"
  records = ["${format("mm-devpaas-jenkins.marmac-labs.internal")}"]

  ttl     = "300"
}

/* ********************************************************************** */
/* JENKINS MASTER SERVER VM DEFINITION  - END                             */
/* ********************************************************************** */


/* ********************************************************************** */
/* NEXUS SERVER VM DEFINITION  - START                                    */
/* ********************************************************************** */
data "template_file" "mm_devpaas_dv_tf_user_data_nexus" {
  template = "${file("change_hostname.sh.tpl")}"

  vars {
    domain_name = "${var.primary_zone_domain_name}"
    vm_name     = "${var.nexus_srv_instance_name}"
  }

}

resource "aws_instance" "mm_devpaas_dv_nexus" {

  ami                     = "${var.nexus_srv_image_id}"
  instance_type           = "${var.nexus_srv_flavor_name}"
  subnet_id               = "${aws_subnet.mm_devpaas_sb_private.id}"
  key_name                = "${var.aws_ssh_key_name}"
  vpc_security_group_ids  = ["${aws_security_group.mm_devpaas_sg_he.id}"]

  user_data = "${data.template_file.mm_devpaas_dv_tf_user_data_nexus.rendered}"

  tags {
    Name = "${var.nexus_srv_instance_name}"
  }
}

resource "aws_route53_record" "mm_devpaas_dns_r_nexus_forward" {

  zone_id = "${aws_route53_zone.mm_devpaas_dns_primary_fw.id}"
  type    = "A"
  name    = "${var.nexus_srv_instance_name}"
  records = ["${aws_instance.mm_devpaas_dv_nexus.private_ip}"]
  ttl     = "300"

}

resource "aws_route53_record" "mm_devpaas_dns_r_nexus_reverse" {

  zone_id = "${aws_route53_zone.mm_devpaas_dns_primary_rv.id}"
  type    = "PTR"
  name    = "${format("%s.%s.0.10.in-addr.arpa",
                  element(split(".",aws_instance.mm_devpaas_dv_nexus.private_ip),3),
                  element(split(".",aws_instance.mm_devpaas_dv_nexus.private_ip),2))}"
  records = ["${format("mm-devpaas-nexus.marmac-labs.internal")}"]

  ttl     = "300"
}
/* ********************************************************************** */
/* NEXUS SERVER VM DEFINITION  - END                                      */
/* ********************************************************************** */


/* ********************************************************************** */
/* SONARQUBE SERVER VM DEFINITION  - START                                */
/* ********************************************************************** */
data "template_file" "mm_devpaas_dv_tf_user_data_sonarqube" {
  template = "${file("change_hostname.sh.tpl")}"

  vars {
    domain_name = "${var.primary_zone_domain_name}"
    vm_name     = "${var.sonarqube_srv_instance_name}"
  }

}

resource "aws_instance" "mm_devpaas_dv_sonarqube" {

  ami                     = "${var.sonarqube_srv_image_id}"
  instance_type           = "${var.sonarqube_srv_flavor_name}"
  subnet_id               = "${aws_subnet.mm_devpaas_sb_private.id}"
  key_name                = "${var.aws_ssh_key_name}"
  vpc_security_group_ids  = ["${aws_security_group.mm_devpaas_sg_he.id}"]

  user_data = "${data.template_file.mm_devpaas_dv_tf_user_data_sonarqube.rendered}"

  tags {
    Name = "${var.sonarqube_srv_instance_name}"
  }
}

resource "aws_route53_record" "mm_devpaas_dns_r_sonarqube_forward" {

  zone_id = "${aws_route53_zone.mm_devpaas_dns_primary_fw.id}"
  type    = "A"
  name    = "${var.sonarqube_srv_instance_name}"
  records = ["${aws_instance.mm_devpaas_dv_sonarqube.private_ip}"]
  ttl     = "300"

}

resource "aws_route53_record" "mm_devpaas_dns_r_sonarqube_reverse" {

  zone_id = "${aws_route53_zone.mm_devpaas_dns_primary_rv.id}"
  type    = "PTR"
  name    = "${format("%s.%s.0.10.in-addr.arpa",
                  element(split(".",aws_instance.mm_devpaas_dv_sonarqube.private_ip),3),
                  element(split(".",aws_instance.mm_devpaas_dv_sonarqube.private_ip),2))}"
  records = ["${format("mm-devpaas-sonarqube.marmac-labs.internal")}"]

  ttl     = "300"
}
/* ********************************************************************** */
/* SONARQUBE SERVER VM DEFINITION  - END                                  */
/* ********************************************************************** */


/* ********************************************************************** */
/* ELK SERVER VM DEFINITION  - START                                      */
/* ********************************************************************** */

/* ********************************************************************** */
/* ELK SERVER VM DEFINITION  - END                                        */
/* ********************************************************************** */