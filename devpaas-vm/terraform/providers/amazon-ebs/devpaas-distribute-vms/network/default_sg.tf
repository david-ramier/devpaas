/*
 *  Security Group definition
 */

resource "aws_security_group" "mm_devpaas_sg_jb" {
  name = "MM-DEVPAAS-SG-JB-${aws_vpc.mm_devpaas_vpc.id}"
  description = "JumpBox SG"
  vpc_id = "${aws_vpc.mm_devpaas_vpc.id}"

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

  tags {
    Name = "MM-DEVPAAS-SG-JB"
  }

}

resource "aws_security_group" "mm_devpaas_sg_fe" {
  name = "MM-DEVPAAS-SG-FE-${aws_vpc.mm_devpaas_vpc.id}"
  description = "Security Group for Front End VMs"
  vpc_id = "${aws_vpc.mm_devpaas_vpc.id}"

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    security_groups = ["${aws_security_group.mm_devpaas_sg_jb.id}"]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "MM-DEVPAAS-SG-FE"
  }

}

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
    security_groups = ["${aws_security_group.mm_devpaas_sg_fe.id}"]
  }

  ingress {
    from_port       = "8080"
    to_port         = "8080"
    protocol        = "TCP"
    security_groups = ["${aws_security_group.mm_devpaas_sg_fe.id}"]
  }

  ingress {
    from_port       = "8081"
    to_port         = "8081"
    protocol        = "TCP"
    security_groups = ["${aws_security_group.mm_devpaas_sg_fe.id}"]
  }

  ingress {
    from_port       = "9000"
    to_port         = "9000"
    protocol        = "TCP"
    security_groups = ["${aws_security_group.mm_devpaas_sg_fe.id}"]
  }

  tags {
    Name = "MM-DEVPAAS-SG-HE"
  }

}
/*
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
*/