# --------------------------------------------------------------------------------------
#  Security Group Rules definition for Jump-Box SG
# --------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------
# START SECURITY GROUP RULES FOR JUMP BOX VM
# - it allows the following traffic:
# - ICMP   on port  all from your Internet Public IP
# - SSH    on port   22 from your Internet Public IP
# - HTTP   on port   80 from your Internet Public IP
# - HTTPS  on port  443 from your Internet Public IP
# - ICMP   on port  all to all other SG inside the VPC
# - SSH    on port   22 to all other SG inside the VPC
# --------------------------------------------------------------------------------------

# INGRESS RULES:

# - SECURITY GROUP RULE ICMP      on port  all from your Internet Public IP
resource "aws_security_group_rule" "mm_devpaas_sg_jb_ig_icmp_from_pers_pub_ip" {

  type                      = "ingress"
  from_port                 = "-1"
  to_port                   = "-1"
  protocol                  = "icmp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_jb.id}"
  cidr_blocks               = ["${var.mm_public_ip}/32"]

}

# - SECURITY GROUP RULE SSH      on port  22 from your Internet Public IP
resource "aws_security_group_rule" "mm_devpaas_sg_jb_ig_ssh_from_pers_pub_ip" {

  type                      = "ingress"
  from_port                 = "22"
  to_port                   = "22"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_jb.id}"
  cidr_blocks               = ["${var.mm_public_ip}/32"]

}

# - SECURITY GROUP RULE HTTP     on port  80 from your Internet Public IP
resource "aws_security_group_rule" "mm_devpaas_sg_jb_ig_http_from_pers_pub_ip" {

  type                      = "ingress"
  from_port                 = "80"
  to_port                   = "80"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_jb.id}"
  cidr_blocks               = ["${var.mm_public_ip}/32"]

}

# - SECURITY GROUP RULE HTTPS    on port 443 from your Internet Public IP
resource "aws_security_group_rule" "mm_devpaas_sg_jb_ig_https_from_pers_pub_ip" {

  type                      = "ingress"
  from_port                 = "443"
  to_port                   = "443"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_jb.id}"
  cidr_blocks               = ["${var.mm_public_ip}/32"]

}

# EGRESS RULES:

# - SECURITY GROUP RULE SSH    on port  22 to SG RP
resource "aws_security_group_rule" "mm_devpaas_sg_jb_eg_ssh_to_sg_rp" {

  type                      = "egress"
  from_port                 = "22"
  to_port                   = "22"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_jb.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_rp.id}"

}

# - SECURITY GROUP RULE SSH    on port  22 to SG FE
resource "aws_security_group_rule" "mm_devpaas_sg_jb_eg_ssh_to_sg_fe" {

  type                      = "egress"
  from_port                 = "22"
  to_port                   = "22"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_jb.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_fe.id}"

}

# - SECURITY GROUP RULE SSH    on port  22 to SG HE
resource "aws_security_group_rule" "mm_devpaas_sg_jb_eg_ssh_to_sg_he" {

  type                      = "egress"
  from_port                 = "22"
  to_port                   = "22"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_jb.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_he.id}"

}

# - SECURITY GROUP RULE SSH    on port  22 to SG DB
resource "aws_security_group_rule" "mm_devpaas_sg_jb_eg_ssh_to_sg_db" {

  type                      = "egress"
  from_port                 = "22"
  to_port                   = "22"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_jb.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_db.id}"

}

# - SECURITY GROUP RULE ICMP    on all  ports to SG RP
resource "aws_security_group_rule" "mm_devpaas_sg_jb_eg_icmp_to_sg_rp" {

  type                      = "egress"
  from_port                 = "-1"
  to_port                   = "-1"
  protocol                  = "icmp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_jb.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_rp.id}"

}

# - SECURITY GROUP RULE ICMP    on all  ports to SG FE
resource "aws_security_group_rule" "mm_devpaas_sg_jb_eg_icmp_to_sg_fe" {

  type                      = "egress"
  from_port                 = "-1"
  to_port                   = "-1"
  protocol                  = "icmp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_jb.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_fe.id}"

}

# - SECURITY GROUP RULE ICMP    on all  ports to SG HE
resource "aws_security_group_rule" "mm_devpaas_sg_jb_eg_icmp_to_sg_he" {

  type                      = "egress"
  from_port                 = "-1"
  to_port                   = "-1"
  protocol                  = "icmp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_jb.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_he.id}"

}

# - SECURITY GROUP RULE ICMP    on all  ports to SG DB
resource "aws_security_group_rule" "mm_devpaas_sg_jb_eg_icmp_to_sg_db" {

  type                      = "egress"
  from_port                 = "-1"
  to_port                   = "-1"
  protocol                  = "icmp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_jb.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_db.id}"

}

# --------------------------------------------------------------------------------------
# END SECURITY GROUP FOR JUMP BOX VM
# --------------------------------------------------------------------------------------