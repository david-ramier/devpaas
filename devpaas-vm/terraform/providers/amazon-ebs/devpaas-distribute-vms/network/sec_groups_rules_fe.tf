/*
 *  Security Group definition
 */

/* ********************************************************************** */
/* START SECURITY GROUP RULES FOR FRONT-END (WEB SERVER) VMs              */
/* - it allows the following traffic:                                     */
/* - SSH    on port   22 from Jump Box security group                     */
/* - HTTP   on port 9000 from Reverse Proxy security group                */
/* ********************************************************************** */

/* INGRESS RULES:                                            */

/* - SECURITY GROUP RULE ICMP      on port  all from JB SG   */
resource "aws_security_group_rule" "mm_devpaas_sg_fe_ig_icmp_from_sg_jb" {

  type                      = "ingress"
  from_port                 = "-1"
  to_port                   = "-1"
  protocol                  = "icmp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_fe.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_jb.id}"

}

/* - SECURITY GROUP RULE SSH      on port   22 from JB SG  */
resource "aws_security_group_rule" "mm_devpaas_sg_fe_ig_ssh_from_sg_jb" {

  type                      = "ingress"
  from_port                 = "22"
  to_port                   = "22"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_fe.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_jb.id}"

}

/* - SECURITY GROUP RULE HTTP      on port 9000 from RP SG  */
resource "aws_security_group_rule" "mm_devpaas_sg_fe_ig_http_9000_from_sg_rp" {

  type                      = "ingress"
  from_port                 = "9000"
  to_port                   = "9000"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_fe.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_rp.id}"

}

/* EGRESS RULES:                                             */

/* - SECURITY GROUP RULE HTTP      on port  8080 to HE SG    */
resource "aws_security_group_rule" "mm_devpaas_sg_fe_eg_http_8080_to_sg_he" {

  type                      = "egress"
  from_port                 = "8080"
  to_port                   = "8080"
  protocol                  = "tcp"

  security_group_id         = "${aws_security_group.mm_devpaas_sg_fe.id}"
  source_security_group_id  = "${aws_security_group.mm_devpaas_sg_he.id}"

}

/* ********************************************************************** */
/* END SECURITY GROUP FOR FRONT-END (WEB SERVER) VMs                      */
/* ********************************************************************** */