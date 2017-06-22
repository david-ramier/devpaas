# --------------------------------------------------------------------------------------
#   SECURITY GROUP RULES DEFINITIONS
# --------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------
# START SECURITY GROUP RULE FOR ELASTIC LOAD BALANCER ELB
# - it allows the following traffic:
# - HTTP   on port  80 from all Internet IPs
# - HTTPS  on port 443 from all Internet IPs
# --------------------------------------------------------------------------------------

# IGRESS RULES:

# - SECURITY GROUP RULE HTTP      on port   80 from all internet ip
resource "aws_security_group_rule" "mm_devpaas_sg_elb_ig_http_80_from_all_internet" {

  type                      = "ingress"
  from_port                 = "80"
  to_port                   = "80"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_elb_ext.id}"
  cidr_blocks               = ["0.0.0.0/0"]

}

# - SECURITY GROUP RULE HTTPS     on port  443 from all internet ip
resource "aws_security_group_rule" "mm_devpaas_sg_elb_ig_https_443_from_all_internet" {

  type                      = "ingress"
  from_port                 = "443"
  to_port                   = "443"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_elb_ext.id}"
  cidr_blocks               = ["0.0.0.0/0"]

}

#  EGRESS RULES:

# - EGRESS SECURITY GROUP RULE HTTP      on port  80 to RP SG

resource "aws_security_group_rule" "mm_devpaas_sg_elb_eg_http_80_to_sg_rp" {

  type                      = "egress"
  from_port                 = "80"
  to_port                   = "80"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_elb_ext.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_rp.id}"

}

# - EGRESS SECURITY GROUP RULE ALL PORT TO ALL IP on INTERNET

resource "aws_security_group_rule" "mm_devpaas_sg_elb_eg_all_to_all" {

  type                      = "egress"
  from_port                 = "0"
  to_port                   = "0"
  protocol                  = "-1"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_elb_ext.id}"
  cidr_blocks               = ["0.0.0.0/0"]

}

# --------------------------------------------------------------------------------------
# END SECURITY GROUP FOR ELASTIC LOAD BALANCER ELB - EXTERNAL
# --------------------------------------------------------------------------------------