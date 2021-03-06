/*  This file describe the Network ACLs  */


# --------------------------------------------------------------------------------------
#              NETWORK ACL Definition
# --------------------------------------------------------------------------------------

resource "aws_network_acl" "mm_devpaas_nacl_main" {
  vpc_id = "${aws_vpc.mm_devpaas_vpc.id}"

  subnet_ids = ["${aws_subnet.mm_devpaas_sb_public.id}","${aws_subnet.mm_devpaas_sb_private.id}"]

  tags {
    Name = "${var.project_name}-NACL-Main"
  }
}


#  NETWORK ACL RULES

# INGRESS RULES
# Allow inbound http traffic on 80
resource "aws_network_acl_rule" "mm_devpaas_acl_rule_in_http_80" {

  rule_number     = 100
  protocol        = "tcp"
  rule_action     = "allow"
  cidr_block      = "0.0.0.0/0"
  from_port       = 80
  to_port         = 80

  egress      = false

  network_acl_id = "${aws_network_acl.mm_devpaas_nacl_main.id}"

}

# Allow inbound http traffic on 443
resource "aws_network_acl_rule" "mm_devpaas_acl_rule_in_https_443" {

  rule_number     = 110
  protocol        = "tcp"
  rule_action     = "allow"
  cidr_block      = "0.0.0.0/0"
  from_port       = 443
  to_port         = 443

  egress          = false

  network_acl_id = "${aws_network_acl.mm_devpaas_nacl_main.id}"

}

# Allow inbound ssh traffic on 22
resource "aws_network_acl_rule" "mm_devpaas_acl_rule_in_ssh_22" {

  rule_number     = 120
  protocol        = "tcp"
  rule_action     = "allow"
  cidr_block      = "${var.mm_public_ip}/32"
  from_port       = 22
  to_port         = 22

  egress          = false

  network_acl_id = "${aws_network_acl.mm_devpaas_nacl_main.id}"

}

# Allow return outbound traffic on dynamic ports
# TODO: Replicate this for a return outbound traffic towards a specific IP that I want to connect to in order to reach 3rd Party Endpoints
resource "aws_network_acl_rule" "mm_devpaas_acl_rule_in_dyn_ports" {

  rule_number     = 140
  protocol        = "tcp"
  rule_action     = "allow"
  cidr_block      = "0.0.0.0/0"
  from_port       = 1024
  to_port         = 65535

  egress          = false

  network_acl_id = "${aws_network_acl.mm_devpaas_nacl_main.id}"

}

# EGRESS RULES
# Allow outbound http traffic on 80
resource "aws_network_acl_rule" "mm_devpaas_acl_rule_e_http_80" {

  rule_number     = 100
  protocol        = "tcp"
  rule_action     = "allow"
  cidr_block      = "0.0.0.0/0"
  from_port       = 80
  to_port         = 80

  egress          = true

  network_acl_id = "${aws_network_acl.mm_devpaas_nacl_main.id}"

}

# Allow outbound http traffic on 443
resource "aws_network_acl_rule" "mm_devpaas_acl_rule_e_https_443" {

  rule_number     = 110
  protocol        = "tcp"
  rule_action     = "allow"
  cidr_block      = "0.0.0.0/0"
  from_port       = 443
  to_port         = 443

  egress          = true

  network_acl_id = "${aws_network_acl.mm_devpaas_nacl_main.id}"

}

# Allow return inbound traffic on dynamic ports
resource "aws_network_acl_rule" "mm_devpaas_acl_rule_e_dynports" {

  rule_number     = 140
  protocol        = "tcp"
  rule_action     = "allow"
  cidr_block      = "0.0.0.0/0"
  from_port       = 1024
  to_port         = 65535

  egress          = true

  network_acl_id = "${aws_network_acl.mm_devpaas_nacl_main.id}"

}