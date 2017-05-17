/*
 *  Security Group definition
 */

/* ********************************************************************** */
/* SECURITY GROUP FOR ELASTIC LOAD BALANCER ELB                           */
/* - it allows the following traffic:                                     */
/* - HTTP   on port  80 from all Internet IPs                             */
/* - HTTPS  on port 443 from all Internet IPs - NOT YET ENABLED           */
/* ********************************************************************** */

resource "aws_security_group" "mm_devpaas_sg_elb" {

  name          = "MM-DEVPAAS-SG-ELB-${aws_vpc.mm_devpaas_vpc.id}"
  description   = "Security Group for ELB"
  vpc_id        = "${aws_vpc.mm_devpaas_vpc.id}"

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  /* TODO: TO BE ENABLED WITH A REALCASE
  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  */

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "MM-DEVPAAS-SG-ELB"
  }

}

/* ********************************************************************** */
/* SECURITY GROUP FOR JUMP BOX VM                                         */
/* - it allows the following traffic:                                     */
/* - SSH    on port  22 from deployed Internet Public IP                  */
/* - HTTP   on port  80 from deployed Internet Public IP                  */
/* - HTTPS  on port 443 from deployed Internet Public IP                  */
/* ********************************************************************** */

resource "aws_security_group" "mm_devpaas_sg_jb" {

  name          = "MM-DEVPAAS-SG-JB-${aws_vpc.mm_devpaas_vpc.id}"
  description   = "Security Group for JumpBox SG"
  vpc_id        = "${aws_vpc.mm_devpaas_vpc.id}"

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    cidr_blocks = ["${var.mm_public_ip}/32"]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "TCP"
    cidr_blocks = ["${var.mm_public_ip}/32"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "TCP"
    cidr_blocks = ["${var.mm_public_ip}/32"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["${aws_security_group.mm_devpaas_sg_rp}", "${aws_security_group.mm_devpaas_sg_fe}", "${aws_security_group.mm_devpaas_sg_he}", "${aws_security_group.mm_devpaas_sg_db}"]
  }

  egress {
    from_port = 0
    to_port   = 65535
    protocol  = "-1"
    cidr_blocks = ["${aws_security_group.mm_devpaas_sg_rp}", "${aws_security_group.mm_devpaas_sg_fe}", "${aws_security_group.mm_devpaas_sg_he}", "${aws_security_group.mm_devpaas_sg_db}"]
  }

  tags {
    Name        = "MM-DEVPAAS-SG-JB"
  }

}

/* ********************************************************************** */
/* SECURITY GROUP FOR REVERSE PROXY VMs  (NGINX / APACHE)                 */
/* - it allows the following traffic:                                     */
/* - SSH    on port  22 from security group of the Jump Box               */
/* - HTTP   on port  80 from all Internet IPs                             */
/* - HTTPS  on port 443 from all Internet IPs                             */
/* ********************************************************************** */

resource "aws_security_group" "mm_devpaas_sg_rp" {

  name          = "MM-DEVPAAS-SG-RP-${aws_vpc.mm_devpaas_vpc.id}"
  description   = "Security Group for Reverse Proxy VMs"
  vpc_id        = "${aws_vpc.mm_devpaas_vpc.id}"

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "TCP"
    security_groups = ["${aws_security_group.mm_devpaas_sg_jb.id}"]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]  //TODO: This should be replaced with a security group that points to the ELB sg
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]  //TODO: This should be replaced with a security group that points to the ELB sg
  }

  tags {
    Name        = "MM-DEVPAAS-SG-RP"
  }

}

/* ********************************************************************** */
/* SECURITY GROUP FOR FRONT-END (WEB SERVER) VMs                          */
/* - it allows the following traffic:                                     */
/* - SSH    on port   22 from Jump Box security group                     */
/* - HTTP   on port 9000 from Reverse Proxy security group                */
/* ********************************************************************** */

resource "aws_security_group" "mm_devpaas_sg_fe" {

  name        = "MM-DEVPAAS-SG-FE-${aws_vpc.mm_devpaas_vpc.id}"
  description = "Security Group for Front-End VMs"
  vpc_id      = "${aws_vpc.mm_devpaas_vpc.id}"

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "TCP"
    security_groups = ["${aws_security_group.mm_devpaas_sg_jb.id}"]
  }

  ingress {
    from_port       = "9000"
    to_port         = "9000"
    protocol        = "TCP"
    security_groups = ["${aws_security_group.mm_devpaas_sg_rp.id}"]
  }

  tags {
    Name = "MM-DEVPAAS-SG-FE"
  }

}


/* ********************************************************************** */
/* SECURITY GROUP FOR HEAD-END (API SERVER) VMs                           */
/* - it allows the following traffic:                                     */
/* - SSH    on port   22 from Jump Box security group                     */
/* - HTTP   on port   80 from Reverse Proxy security group                */
/* - HTTP   on port 8080 from Reverse Proxy security group                */
/* - HTTP   on port 8081 from Reverse Proxy security group                */
/* - HTTP   on port 9000 from Reverse Proxy security group                */
/* ********************************************************************** */

resource "aws_security_group" "mm_devpaas_sg_he" {
  name = "MM-DEVPAAS-SG-HE-${aws_vpc.mm_devpaas_vpc.id}"
  description = "Security Group for HeadEnd VMs"
  vpc_id = "${aws_vpc.mm_devpaas_vpc.id}"

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "TCP"
    security_groups = ["${aws_security_group.mm_devpaas_sg_jb.id}"]
  }

  ingress {
    from_port       = "80"
    to_port         = "80"
    protocol        = "TCP"
    security_groups = ["${aws_security_group.mm_devpaas_sg_rp.id}"]
  }

  ingress {
    from_port       = "8080"
    to_port         = "8080"
    protocol        = "TCP"
    security_groups = ["${aws_security_group.mm_devpaas_sg_rp.id}"]
  }

  ingress {
    from_port       = "8081"
    to_port         = "8081"
    protocol        = "TCP"
    security_groups = ["${aws_security_group.mm_devpaas_sg_rp.id}"]
  }

  ingress {
    from_port       = "9000"
    to_port         = "9000"
    protocol        = "TCP"
    security_groups = ["${aws_security_group.mm_devpaas_sg_rp.id}"]
  }

  tags {
    Name = "MM-DEVPAAS-SG-HE"
  }

}

/* ********************************************************************** */
/* SECURITY GROUP FOR DB VMs                                              */
/* - it allows the following traffic:                                     */
/* - SSH    on port   22 from Jump Box security group                     */
/* - HTTP   on port 3306 from Head-End security group                     */
/* ********************************************************************** */

resource "aws_security_group" "mm_devpaas_sg_db" {

  name        = "MM-DEVPAAS-SG-DB-${aws_vpc.mm_devpaas_vpc.id}"
  description = "Security Group for DB VMs"
  vpc_id      = "${aws_vpc.mm_devpaas_vpc.id}"

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "TCP"
    security_groups = ["${aws_security_group.mm_devpaas_sg_jb.id}"]
  }

  ingress {
    from_port       = "3306"
    to_port         = "3306"
    protocol        = "TCP"
    security_groups = ["${aws_security_group.mm_devpaas_sg_he.id}"]
  }

  tags {
    Name = "MM-DEVPAAS-SG-DB"
  }

}