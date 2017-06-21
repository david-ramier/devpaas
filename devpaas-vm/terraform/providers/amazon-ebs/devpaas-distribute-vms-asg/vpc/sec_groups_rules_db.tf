# --------------------------------------------------------------------------------------
#  Security Group definition
# --------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------
# START SECURITY GROUP RULES FOR DB VMs
# - it allows the following traffic:
# - SSH    on port   22 from Jump Box security group
# - TCP    on port 3306 from Head-End security group
# --------------------------------------------------------------------------------------

# INGRESS RULES:

# - SECURITY GROUP RULE ICMP      on port  all from JB SG
resource "aws_security_group_rule" "mm_devpaas_sg_db_ig_icmp_from_sg_jb" {

  type                      = "ingress"
  from_port                 = "-1"
  to_port                   = "-1"
  protocol                  = "icmp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_db.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_jb.id}"

}

# - SECURITY GROUP RULE SSH      on port   22 from JB SG
resource "aws_security_group_rule" "mm_devpaas_sg_db_ig_ssh_from_sg_jb" {

  type                      = "ingress"
  from_port                 = "22"
  to_port                   = "22"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_db.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_jb.id}"

}

# - SECURITY GROUP RULE TCP      on port 3306 from HE SG
resource "aws_security_group_rule" "mm_devpaas_sg_db_ig_tcp_3306_from_sg_he" {

  type                      = "ingress"
  from_port                 = "3306"
  to_port                   = "3306"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_db.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_he.id}"

}

# EGRESS RULES:


# --------------------------------------------------------------------------------------
# END SECURITY GROUP FOR DB VMs
# --------------------------------------------------------------------------------------