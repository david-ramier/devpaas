/*
 *  Security Group definition
 */

/* ********************************************************************** */
/* START SECURITY GROUP FOR PACKER BUILDER                                */
/* - it allows the following traffic:                                     */
/* - SSH    on port   22 from your Internet Public IP                     */
/* - HTTP   on port   80 from your Internet Public IP                     */
/* - HTTP   on port 8080 from your Internet Public IP                     */
/* - HTTP   on port 8081 from your Internet Public IP                     */
/* - HTTP   on port 9000 from your Internet Public IP                     */
/* - HTTP   on port   80 to all Internet IPs                              */
/* - HTTPS  on port  443 to all Internet IPs                              */
/* ********************************************************************** */

resource "aws_security_group" "mm_devpaas_sg_pb" {

  name          = "MM-DEVPAAS-SG-PB-${aws_vpc.mm_devpaas_vpc.id}"
  description   = "Security Group for Packer Builder"
  vpc_id        = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name        = "MM-DEVPAAS-SG-PB"
  }

}

/* ********************************************************************** */
/* END SECURITY GROUP FOR PACKER BUILDER                                  */
/* ********************************************************************** */


/* ********************************************************************** */
/* START SECURITY GROUP FOR JUMP BOX VM                                   */
/* - it allows the following traffic:                                     */
/* - SSH    on port  22 from your Internet Public IP                      */
/* - HTTP   on port  80 from your Internet Public IP                      */
/* - HTTPS  on port 443 from your Internet Public IP                      */
/* - ICMP   on port all to all other SG inside the VPC                    */
/* - SSH    on port  22 to all other SG inside the VPC                    */
/* ********************************************************************** */

resource "aws_security_group" "mm_devpaas_sg_jb" {

  name          = "MM-DEVPAAS-SG-JB-${aws_vpc.mm_devpaas_vpc.id}"
  description   = "Security Group for JumpBox SG"
  vpc_id        = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name        = "MM-DEVPAAS-SG-JB"
  }

}

/* ********************************************************************** */
/* END SECURITY GROUP FOR JUMP BOX VM                                     */
/* ********************************************************************** */



/* ********************************************************************** */
/* START SECURITY GROUP FOR REVERSE PROXY VMs  (NGINX / APACHE)           */
/* - it allows the following traffic:                                     */
/* - ICMP   on port all from security group of the Jump Box               */
/* - SSH    on port  22 from security group of the Jump Box               */
/* - HTTP   on port  80 from all Internet IPs                             */
/* - HTTPS  on port 443 from all Internet IPs                             */
/* ********************************************************************** */

resource "aws_security_group" "mm_devpaas_sg_rp" {

  name          = "MM-DEVPAAS-SG-RP-${aws_vpc.mm_devpaas_vpc.id}"
  description   = "Security Group for Reverse Proxy VMs"
  vpc_id        = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name        = "MM-DEVPAAS-SG-RP"
  }

}

/* ********************************************************************** */
/* END SECURITY GROUP FOR REVERSE PROXY VMs  (NGINX / APACHE)           */
/* ********************************************************************** */


/* ********************************************************************** */
/* START SECURITY GROUP FOR FRONT-END (WEB SERVER) VMs                    */
/* - it allows the following traffic:                                     */
/* - ICMP   on port  all from security group of the Jump Box              */
/* - SSH    on port   22 from Jump Box security group                     */
/* - HTTP   on port 9000 from Reverse Proxy security group                */
/* - HTTP   on port 8080 to   Head End security group                     */
/* ********************************************************************** */

resource "aws_security_group" "mm_devpaas_sg_fe" {

  name        = "MM-DEVPAAS-SG-FE-${aws_vpc.mm_devpaas_vpc.id}"
  description = "Security Group for Front-End VMs"
  vpc_id      = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name = "MM-DEVPAAS-SG-FE"
  }

}

/* ********************************************************************** */
/* END SECURITY GROUP FOR FRONT-END (WEB SERVER) VMs                    */
/* ********************************************************************** */


/* ********************************************************************** */
/* START SECURITY GROUP FOR HEAD-END (API SERVER) VMs                     */
/* - it allows the following traffic:                                     */
/* - ICMP   on port  all from security group of the Jump Box              */
/* - SSH    on port   22 from Jump Box security group                     */
/* - HTTP   on port   80 from Reverse Proxy security group                */
/* - HTTP   on port 8080 from Reverse Proxy security group                */
/* - HTTP   on port 8081 from Reverse Proxy security group                */
/* - HTTP   on port 9000 from Reverse Proxy security group                */
/* - TCP    on port 3306 to   DB  security group                          */
/* ********************************************************************** */

resource "aws_security_group" "mm_devpaas_sg_he" {
  name = "MM-DEVPAAS-SG-HE-${aws_vpc.mm_devpaas_vpc.id}"
  description = "Security Group for HeadEnd VMs"
  vpc_id = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name = "MM-DEVPAAS-SG-HE"
  }

}

/* ********************************************************************** */
/* END SECURITY GROUP FOR HEAD-END (API SERVER) VMs                       */
/* ********************************************************************** */


/* ********************************************************************** */
/* START SECURITY GROUP FOR DB VMs                                        */
/* - it allows the following traffic:                                     */
/* - ICMP   on port  all from security group of the Jump Box              */
/* - SSH    on port   22 from Jump Box security group                     */
/* - TCP    on port 3306 from Head-End security group                     */
/* ********************************************************************** */

resource "aws_security_group" "mm_devpaas_sg_db" {

  name        = "MM-DEVPAAS-SG-DB-${aws_vpc.mm_devpaas_vpc.id}"
  description = "Security Group for DB VMs"
  vpc_id      = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name = "MM-DEVPAAS-SG-DB"
  }

}

/* ********************************************************************** */
/* END SECURITY GROUP FOR DB VMs                                          */
/* ********************************************************************** */