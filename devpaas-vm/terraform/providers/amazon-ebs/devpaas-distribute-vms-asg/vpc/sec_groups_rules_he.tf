# --------------------------------------------------------------------------------------
#  Security Group definition
# --------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------
# START SECURITY GROUP RULES FOR HEAD-END (API SERVER) VMs
# - it allows the following traffic:
# - SSH    on port   22 from Jump Box security group
# - HTTP   on port   80 from Reverse Proxy security group
# - HTTP   on port 8080 from Reverse Proxy security group
# - HTTP   on port 8081 from Reverse Proxy security group
# - HTTP   on port 9000 from Reverse Proxy security group
# --------------------------------------------------------------------------------------

# INGRESS RULES:

# - SECURITY GROUP RULE ICMP      on port  all from JB SG
resource "aws_security_group_rule" "mm_devpaas_sg_he_ig_icmp_from_sg_jb" {

  type                      = "ingress"
  from_port                 = "-1"
  to_port                   = "-1"
  protocol                  = "icmp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_he.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_jb.id}"

}

# - SECURITY GROUP RULE SSH      on port   22 from JB SG
resource "aws_security_group_rule" "mm_devpaas_sg_he_ig_ssh_from_sg_jb" {

  type                      = "ingress"
  from_port                 = "22"
  to_port                   = "22"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_he.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_jb.id}"

}

# - SECURITY GROUP RULE HTTP      on port 8080 from RP SG
resource "aws_security_group_rule" "mm_devpaas_sg_he_ig_http_8080_from_sg_rp" {

  type                      = "ingress"
  from_port                 = "8080"
  to_port                   = "8080"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_he.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_rp.id}"

}

# - SECURITY GROUP RULE HTTP      on port 8081 from RP SG
resource "aws_security_group_rule" "mm_devpaas_sg_he_ig_http_8081_from_sg_rp" {

  type                      = "ingress"
  from_port                 = "8081"
  to_port                   = "8081"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_he.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_rp.id}"

}

# - SECURITY GROUP RULE HTTP      on port 9000 from RP SG
resource "aws_security_group_rule" "mm_devpaas_sg_he_ig_http_9000_from_sg_rp" {

  type                      = "ingress"
  from_port                 = "9000"
  to_port                   = "9000"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_he.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_rp.id}"

}

# EGRESS RULES:

# - SECURITY GROUP RULE TCP      on port  3306 to DB SG
resource "aws_security_group_rule" "mm_devpaas_sg_he_eg_tcp_3306_to_sg_db" {

  type                      = "egress"
  from_port                 = "3306"
  to_port                   = "3306"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_fe.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_db.id}"

}

# --------------------------------------------------------------------------------------
# END SECURITY GROUP FOR HEAD-END (API SERVER) VMs
# --------------------------------------------------------------------------------------