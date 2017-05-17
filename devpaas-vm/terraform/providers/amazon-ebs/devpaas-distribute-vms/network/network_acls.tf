/*  This file describe the Network ACLS  */


/* ************************************************************************************ */
/*              NETWORK ACL Definition                                                  */
/* ************************************************************************************ */

resource "aws_network_acl" "mm_devpaas_acl_all" {

  vpc_id = "${aws_vpc.mm_devpaas_vpc.id}"
  //subnet_ids = ["${aws_subnet.mm_devpaas_sb_public.id}}","${aws_subnet.mm_devpaas_sb_private.id}"]

  /*
  // COMPLETE OPEN ACL to the entire world: JUST FOR TESTING - NOT TO BE USED FOR PRODUCTION
  ingress {
    rule_no     = 10
    protocol    = "-1"
    action      = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port   = 0
    to_port     = 0
  }

  egress {
    rule_no     = 10
    protocol    = "-1"
    action      = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port   = 0
    to_port     = 0
  }
  */

  /*
  // INGRESS RULES
  // Allow inbound http traffic on 80
  ingress {
    rule_no     = 100
    protocol    = "tcp"
    action      = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port   = 80
    to_port     = 80
  }

  // Allow inbound http traffic on 443
  ingress {
    rule_no     = 110
    protocol    = "tcp"
    action      = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port   = 443
    to_port     = 443
  }



  // Allow inbound http traffic on 22
  ingress {
    rule_no     = 120
    protocol    = "tcp"
    action      = "allow"
    cidr_block  = "${var.mm_public_ip}/32"
    from_port   = 22
    to_port     = 22
  }

  // Allow return outbound traffic on dynamic ports
  ingress {
    rule_no     = 140
    protocol    = "tcp"
    action      = "allow"
    cidr_block  = "${var.mm_public_ip}/32"
    from_port   = 1024
    to_port     = 65535
  }



  // EGRESS RULES
  // Allow outbound http traffic on 80
  egress {
    rule_no     = 100
    protocol    = "tcp"
    action      = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port   = 80
    to_port     = 80
  }

  // Allow outbound http traffic on 443
  egress {
    rule_no     = 110
    protocol    = "tcp"
    action      = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port   = 443
    to_port     = 443
  }

  // Allow return inbound traffic on dynamic ports
  egress {
    rule_no     = 140
    protocol    = "tcp"
    action      = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port   = 1024
    to_port     = 65535
  }

  */

  tags {
    Name = "MM-DEVPAAS-ACL"
  }
}

/*  NETWORK ACL ENTRIES */

// INGRESS RULES
// Allow inbound http traffic on 80
resource "aws_network_acl_rule" "mm_devpaas_acl_rule_in_http_80" {

  rule_number     = 100
  protocol        = "tcp"
  rule_action     = "allow"
  cidr_block      = "0.0.0.0/0"
  from_port       = 80
  to_port         = 80

  egress      = false

  network_acl_id = "${aws_network_acl.mm_devpaas_acl_all.id}"

}

// Allow inbound http traffic on 443
resource "aws_network_acl_rule" "mm_devpaas_acl_rule_in_https_443" {

  rule_number     = 110
  protocol        = "tcp"
  rule_action     = "allow"
  cidr_block      = "0.0.0.0/0"
  from_port       = 443
  to_port         = 443

  egress          = false

  network_acl_id  = "${aws_network_acl.mm_devpaas_acl_all.id}"

}

// Allow inbound http traffic on 443
resource "aws_network_acl_rule" "mm_devpaas_acl_rule_in_ssh_22" {

  rule_number     = 120
  protocol        = "tcp"
  rule_action     = "allow"
  cidr_block      = "${var.mm_public_ip}/32"
  from_port       = 22
  to_port         = 22

  egress          = false

  network_acl_id  = "${aws_network_acl.mm_devpaas_acl_all.id}"
}

// Allow return outbound traffic on dynamic ports
resource "aws_network_acl_rule" "mm_devpaas_acl_rule_in_dyn_ports" {

  rule_number     = 140
  protocol        = "tcp"
  rule_action     = "allow"
  cidr_block      = "${var.mm_public_ip}/32"
  from_port       = 1024
  to_port         = 65535

  egress          = false

  network_acl_id  = "${aws_network_acl.mm_devpaas_acl_all.id}"
}

// EGRESS RULES
// Allow outbound http traffic on 80
resource "aws_network_acl_rule" "mm_devpaas_acl_rule_e_http_80" {

  rule_number     = 100
  protocol        = "tcp"
  rule_action     = "allow"
  cidr_block      = "0.0.0.0/0"
  from_port       = 80
  to_port         = 80

  egress          = true

  network_acl_id  = "${aws_network_acl.mm_devpaas_acl_all.id}"
}

// Allow outbound http traffic on 443
resource "aws_network_acl_rule" "mm_devpaas_acl_rule_e_https_443" {

  rule_number     = 110
  protocol        = "tcp"
  rule_action     = "allow"
  cidr_block      = "0.0.0.0/0"
  from_port       = 443
  to_port         = 443

  egress          = true

  network_acl_id = "${aws_network_acl.mm_devpaas_acl_all.id}"
}

// Allow return inbound traffic on dynamic ports
resource "aws_network_acl_rule" "mm_devpaas_acl_rule_e_dynports" {

  rule_number     = 140
  protocol        = "tcp"
  rule_action     = "allow"
  cidr_block      = "0.0.0.0/0"
  from_port       = 1024
  to_port         = 65535

  egress          = true
  network_acl_id  = "${aws_network_acl.mm_devpaas_acl_all.id}"
}