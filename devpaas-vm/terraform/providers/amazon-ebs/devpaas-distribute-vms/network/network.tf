/* ************************************************************************************ */
/*              EIP Definition                                                          */
/* ************************************************************************************ */
resource "aws_eip" "mm_devpaas_nat_eip" {
  vpc = true
}

resource "aws_eip" "mm_devpaas_admin_eip" {
  vpc = true
}

/* ************************************************************************************ */
/*              VPC Definition                                                          */
/* ************************************************************************************ */

resource "aws_vpc" "mm_devpaas_vpc" {
  cidr_block = "${var.vpc_cidr}"

  enable_dns_support    = true
  enable_dns_hostnames  = true

  tags {
    Name = "MM-DEVPAAS-VPC"
  }
}

/* ************************************************************************************ */
/*              INTERNET GATEWAY (IGW) Definition                                       */
/* ************************************************************************************ */

resource "aws_internet_gateway" "mm_devpaas_igw" {

  vpc_id = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name = "MM-DEVPAAS-IGW"
  }
}

/* ************************************************************************************ */
/*              SUBNETs                                                                 */
/* ************************************************************************************ */

/* SUBNET Definition for Public addresses */
resource "aws_subnet" "mm_devpaas_sb_public" {

  vpc_id                  = "${aws_vpc.mm_devpaas_vpc.id}"
  cidr_block              = "${var.subnet_public_cidr}"
  availability_zone       = "${var.aws_deployment_region}a"

  map_public_ip_on_launch = true

  tags {
    Name = "MM-DEVPAAS-SB-PUBLIC"
  }
}

/* SUBNET Definition for Private addresses */
resource "aws_subnet" "mm_devpaas_sb_private" {
  vpc_id            = "${aws_vpc.mm_devpaas_vpc.id}"
  cidr_block        = "${var.subnet_private_cidr}"
  availability_zone = "${var.aws_deployment_region}a"

  tags {
    Name = "MM-DEVPAAS-SB-PRIVATE"
  }
}


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

  */

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

  tags {
    Name = "MM-DEVPAAS-ACL-01"
  }
}

/*  NETWORK ACL ENTRIES */

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

/* ************************************************************************************ */
/*              NAT GATEWAY                                                             */
/* ************************************************************************************ */

/* NAT Gateway */
resource "aws_nat_gateway" "mm_devpaas_nat_gw" {
  allocation_id = "${aws_eip.mm_devpaas_nat_eip.id}"
  subnet_id     = "${aws_subnet.mm_devpaas_sb_public.id}"

  depends_on = ["aws_internet_gateway.mm_devpaas_igw"]
}

/* ************************************************************************************ */
/*              ROUTING TABLES & ROUTES                                                 */
/* ************************************************************************************ */

// RouteTable Public
resource "aws_route_table" "mm_devpaas_rt_public" {

  vpc_id = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name = "MM-DEVPAAS-RT-Public"
  }
}

// Route to IGW Gateway
resource "aws_route" "mm_devpaas_route_public" {

  route_table_id          = "${aws_route_table.mm_devpaas_rt_public.id}"
  gateway_id              = "${aws_internet_gateway.mm_devpaas_igw.id}"
  destination_cidr_block  = "0.0.0.0/0"

}

// Route Table association: Route Table Public <--> Public Subnet
resource "aws_route_table_association" "mm_devpaas_rta_sbpublic" {

  route_table_id  = "${aws_route_table.mm_devpaas_rt_public.id}"
  subnet_id       = "${aws_subnet.mm_devpaas_sb_public.id}"

}


// RouteTable Private
resource "aws_route_table" "mm_devpaas_rt_private" {

  vpc_id = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name = "MM-DEVPAAS-RT"
  }
}

// Route to the NAT Gateway
resource "aws_route" "mm_devpaas_route_private" {
  route_table_id          = "${aws_route_table.mm_devpaas_rt_private.id}"
  gateway_id              = "${aws_nat_gateway.mm_devpaas_nat_gw.id}"
  destination_cidr_block  = "0.0.0.0/0"
}

// Route Table association: Route Table Private <--> Private Subnet
resource "aws_route_table_association" "mm_devpaas_rta_sbprivate" {

  route_table_id  = "${aws_route_table.mm_devpaas_rt_private.id}"
  subnet_id       = "${aws_subnet.mm_devpaas_sb_private.id}"

}