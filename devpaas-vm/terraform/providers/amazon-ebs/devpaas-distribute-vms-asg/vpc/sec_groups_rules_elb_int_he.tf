# --------------------------------------------------------------------------------------
#   SECURITY GROUP RULES DEFINITIONS
# --------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------
# START SECURITY GROUP FOR ELASTIC LOAD BALANCER INTERNAL HE
# - it allows the following traffic:
# - HTTP   on port 8080 from security group reverse proxy
# - HTTP   on port 8080 from security group front end
# - HTTP   on port 8080 to   security group head end
# --------------------------------------------------------------------------------------

# IGRESS RULES:

# - SECURITY GROUP RULE HTTP   on port 8080 from security group reverse proxy
resource "aws_security_group_rule" "mm_devpaas_sg_elb_int_he_ig_http_80_from_sg_rp" {

  type                      = "ingress"
  from_port                 = "80"
  to_port                   = "80"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_elb_int_he.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_rp.id}"

}

# - SECURITY GROUP RULE HTTP   on port 8080 from security group front end
resource "aws_security_group_rule" "mm_devpaas_sg_elb_int_he_ig_http_80_from_sg_fe" {

  type                      = "ingress"
  from_port                 = "80"
  to_port                   = "80"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_elb_ext.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_fe.id}"

}

#  EGRESS RULES:

# - EGRESS SECURITY GROUP RULE HTTP   on port 8080 to   security group head end
resource "aws_security_group_rule" "mm_devpaas_sg_elb_int_he_eg_http_80_to_sg_he" {

  type                      = "egress"
  from_port                 = "8080"
  to_port                   = "8080"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_elb_ext.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_he.id}"

}

/* ********************************************************************** */
/* END SECURITY GROUP FOR ELASTIC LOAD BALANCER ELB                     */
/* ********************************************************************** */