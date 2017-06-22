# --------------------------------------------------------------------------------------
#   SECURITY GROUP RULES DEFINITIONS
# --------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------
# START SECURITY GROUP RULES FOR REVERSE PROXY VMs  (NGINX / APACHE)
# - it allows the following traffic:
# - SSH    on port  22 from security group of the Jump Box
# - HTTP   on port  80 from all Internet IPs
# - HTTPS  on port 443 from all Internet IPs
# --------------------------------------------------------------------------------------

#  IGRESS RULES:

# - SECURITY GROUP RULE ICMP      on port  all from JB SG
resource "aws_security_group_rule" "mm_devpaas_sg_rp_ig_icmp_from_sg_jb" {

  type                      = "ingress"
  from_port                 = "-1"
  to_port                   = "-1"
  protocol                  = "icmp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_rp.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_jb.id}"

}

# - SECURITY GROUP RULE SSH      on port   22 from JB SG
resource "aws_security_group_rule" "mm_devpaas_sg_rp_ig_ssh_from_sg_jb" {

  type                      = "ingress"
  from_port                 = "22"
  to_port                   = "22"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_rp.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_jb.id}"

}

# - SECURITY GROUP RULE HTTP      on port   80 from from ELB SG
resource "aws_security_group_rule" "mm_devpaas_sg_rp_ig_http_from_all_internet" {

  type                      = "ingress"
  from_port                 = "80"
  to_port                   = "80"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_rp.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_elb_ext.id}"

}

# - SECURITY GROUP RULE HTTPS      on port   443 from ELB SG
resource "aws_security_group_rule" "mm_devpaas_sg_rp_ig_https_from_all_internet" {

  type                      = "ingress"
  from_port                 = "443"
  to_port                   = "443"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_rp.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_elb_ext.id}"

}

# EGRESS RULES:

# - EGRESS SECURITY GROUP RULE HTTP      on port  80 to all internet
resource "aws_security_group_rule" "mm_devpaas_sg_rp_eg_http_80_to_all" {

  type                      = "egress"
  from_port                 = "80"
  to_port                   = "80"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_rp.id}"
  cidr_blocks               = ["0.0.0.0/0"]

}

# - EGRESS SECURITY GROUP RULE HTTP      on port  9000 to FE SG
resource "aws_security_group_rule" "mm_devpaas_sg_rp_eg_http_9000_to_sg_fe" {

  type                      = "egress"
  from_port                 = "9000"
  to_port                   = "9000"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_rp.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_fe.id}"

}

# - EGRESS SECURITY GROUP RULE HTTP      on port  8080 to HE SG
resource "aws_security_group_rule" "mm_devpaas_sg_rp_eg_http_8080_to_sg_he" {

  type                      = "egress"
  from_port                 = "8080"
  to_port                   = "8080"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_rp.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_he.id}"

}

# - EGRESS SECURITY GROUP RULE HTTP      on port  8081 to HE SG
resource "aws_security_group_rule" "mm_devpaas_sg_rp_eg_http_8081_to_sg_he" {

  type                      = "egress"
  from_port                 = "8081"
  to_port                   = "8081"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_rp.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_he.id}"

}

# - EGRESS SECURITY GROUP RULE HTTP      on port  9000 to HE SG
resource "aws_security_group_rule" "mm_devpaas_sg_rp_eg_http_9000_to_sg_he" {

  type                      = "egress"
  from_port                 = "9000"
  to_port                   = "9000"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_rp.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_he.id}"

}

# --------------------------------------------------------------------------------------
# END SECURITY GROUP FOR REVERSE PROXY VMs  (NGINX / APACHE)
# --------------------------------------------------------------------------------------