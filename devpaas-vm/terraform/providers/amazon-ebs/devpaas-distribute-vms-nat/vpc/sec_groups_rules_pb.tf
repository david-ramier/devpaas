/*
 *  Security Group definition
 */

/* ********************************************************************** */
/* START SECURITY GROUP RULES FOR PACKER BUILDER                          */
/* - it allows the following traffic:                                     */
/* - SSH    on port   22 from your Internet Public IP                     */
/* - HTTP   on port   80 from your Internet Public IP                     */
/* - HTTP   on port 8080 from your Internet Public IP                     */
/* - HTTP   on port 8081 from your Internet Public IP                     */
/* - HTTP   on port 9000 from your Internet Public IP                     */
/* - HTTP   on port   80 to all Internet IPs                              */
/* - HTTPS  on port  443 to all Internet IPs                              */
/* ********************************************************************** */

/* IGRESS RULES:                                            */

/* - SECURITY GROUP RULE ICMP      on port  all from your Public Internet IP  */
resource "aws_security_group_rule" "mm_devpaas_sg_pb_ig_icmp_from_pers_pub_ip" {

  type                      = "ingress"
  from_port                 = "-1"
  to_port                   = "-1"
  protocol                  = "icmp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_pb.id}"
  cidr_blocks               = ["${var.mm_public_ip}/32"]

}

/* - SECURITY GROUP RULE SSH      on port   22 from your Public Internet IP  */
resource "aws_security_group_rule" "mm_devpaas_sg_pb_ig_ssh_from_pers_pub_ip" {

  type                      = "ingress"
  from_port                 = "22"
  to_port                   = "22"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_pb.id}"
  cidr_blocks               = ["${var.mm_public_ip}/32"]

}

/* - SECURITY GROUP RULE HTTP      on port   80 from your Public Internet IP  */
resource "aws_security_group_rule" "mm_devpaas_sg_pb_ig_http_80_from_pers_pub_ip" {

  type                      = "ingress"
  from_port                 = "80"
  to_port                   = "80"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_pb.id}"
  cidr_blocks               = ["${var.mm_public_ip}/32"]

}

/* - SECURITY GROUP RULE HTTP      on port 8080 from your Public Internet IP  */
resource "aws_security_group_rule" "mm_devpaas_sg_pb_ig_http_8080_from_pers_pub_ip" {

  type                      = "ingress"
  from_port                 = "8080"
  to_port                   = "8080"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_pb.id}"
  cidr_blocks               = ["${var.mm_public_ip}/32"]

}

/* - SECURITY GROUP RULE HTTP      on port 8081 from your Public Internet IP  */
resource "aws_security_group_rule" "mm_devpaas_sg_pb_ig_http_8081_from_pers_pub_ip" {

  type                      = "ingress"
  from_port                 = "8081"
  to_port                   = "8081"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_pb.id}"
  cidr_blocks               = ["${var.mm_public_ip}/32"]

}

/* - SECURITY GROUP RULE HTTP      on port 9000 from your Public Internet IP  */
resource "aws_security_group_rule" "mm_devpaas_sg_pb_ig_http_9000_from_pers_pub_ip" {

  type                      = "ingress"
  from_port                 = "9000"
  to_port                   = "9000"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_pb.id}"
  cidr_blocks               = ["${var.mm_public_ip}/32"]

}

/* - SECURITY GROUP RULE HTTPS      on port 443 from your Public Internet IP  */
resource "aws_security_group_rule" "mm_devpaas_sg_pb_ig_https_443_from_pers_pub_ip" {

  type                      = "ingress"
  from_port                 = "443"
  to_port                   = "443"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_pb.id}"
  cidr_blocks               = ["${var.mm_public_ip}/32"]

}

/* EGRESS RULES:                                            */

/* - EGRESS SECURITY GROUP RULE HTTP      on port  80 to all internet  */
resource "aws_security_group_rule" "mm_devpaas_sg_pb_eg_http_80_to_all" {

  type                      = "egress"
  from_port                 = "80"
  to_port                   = "80"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_pb.id}"
  cidr_blocks               = ["0.0.0.0/0"]

}

/* - EGRESS SECURITY GROUP RULE HTTP      on port  80 to all internet  */
resource "aws_security_group_rule" "mm_devpaas_sg_pb_eg_http_8080_to_all" {

  type                      = "egress"
  from_port                 = "8080"
  to_port                   = "8080"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_pb.id}"
  cidr_blocks               = ["0.0.0.0/0"]

}


/* ********************************************************************** */
/* END SECURITY GROUP FOR REVERSE PROXY VMs  (NGINX / APACHE)             */
/* ********************************************************************** */