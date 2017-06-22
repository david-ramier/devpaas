# --------------------------------------------------------------------------------------
#   SECURITY GROUP RULES DEFINITIONS
# --------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------
# START SECURITY GROUP FOR ELASTIC LOAD BALANCER INTERNAL FE
# - it allows the following traffic:
# - HTTP   on port 9000 from security group reverse proxy
# - HTTP   on port 9000 to   security group front end
# --------------------------------------------------------------------------------------

# IGRESS RULES:

# - SECURITY GROUP RULE HTTP   on port 9000 from security group reverse proxy
resource "aws_security_group_rule" "mm_devpaas_sg_elb_int_fe_ig_http_80_from_sg_rp" {

  type                      = "ingress"
  from_port                 = "80"
  to_port                   = "80"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_elb_int_fe.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_rp.id}"

}

#  EGRESS RULES:

# - EGRESS SECURITY GROUP RULE HTTP   on port 9000 to   security group front end
resource "aws_security_group_rule" "mm_devpaas_sg_elb_int_fe_eg_http_80_to_sg_rp" {

  type                      = "egress"
  from_port                 = "80"
  to_port                   = "80"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_elb_int_fe.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_fe.id}"

}

/* ********************************************************************** */
/* END SECURITY GROUP FOR ELASTIC LOAD BALANCER ELB                     */
/* ********************************************************************** */