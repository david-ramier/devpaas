# --------------------------------------------------------------------------------------
#   SECURITY GROUP DEFINITIONS
# --------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------
/* START SECURITY GROUP FOR PACKER BUILDER                                */
/* - it allows the following traffic:                                     */
/* - SSH    on port   22 from your Internet Public IP                     */
/* - HTTP   on port   80 from your Internet Public IP                     */
/* - HTTP   on port 8080 from your Internet Public IP                     */
/* - HTTP   on port 8081 from your Internet Public IP                     */
/* - HTTP   on port 9000 from your Internet Public IP                     */
/* - HTTP   on port   80 to all Internet IPs                              */
/* - HTTPS  on port  443 to all Internet IPs                              */
# --------------------------------------------------------------------------------------

resource "aws_security_group" "mm_devpaas_sg_pb" {

  name          = "${var.project_name}-SG-PB-${aws_vpc.mm_devpaas_vpc.id}"
  description   = "Security Group for Packer Builder"
  vpc_id        = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name        = "${var.project_name}-SG-PB"
  }

}

# --------------------------------------------------------------------------------------
#  END SECURITY GROUP FOR PACKER BUILDER
# --------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------
/* START SECURITY GROUP FOR JUMP BOX VM                                   */
/* - it allows the following traffic:                                     */
/* - SSH    on port  22 from your Internet Public IP                      */
/* - HTTP   on port  80 from your Internet Public IP                      */
/* - HTTPS  on port 443 from your Internet Public IP                      */
/* - ICMP   on port all to all other SG inside the VPC                    */
/* - SSH    on port  22 to all other SG inside the VPC                    */
# --------------------------------------------------------------------------------------

resource "aws_security_group" "mm_devpaas_sg_jb" {

  name          = "${var.project_name}-SG-JB-${aws_vpc.mm_devpaas_vpc.id}"
  description   = "Security Group for JumpBox SG"
  vpc_id        = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name        = "${var.project_name}-SG-JB"
  }

}

# --------------------------------------------------------------------------------------
# END SECURITY GROUP FOR JUMP BOX VM
# --------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------
# START SECURITY GROUP FOR ELASTIC LOAD BALANCER EXTERNAL
# - it allows the following traffic:
# - HTTP   on port   80 from all internet ips
# - HTTPS  on port  443 to   all internet ips
# - HTTP   on port   80 to   security group reverse proxy
# - HTTPS  on port  443 to   security group reverse proxy
# --------------------------------------------------------------------------------------

resource "aws_security_group" "mm_devpaas_sg_elb_ext" {

  name          = "${var.project_name}-SG-ELB-EXT-${aws_vpc.mm_devpaas_vpc.id}"
  description   = "Security Group for Elastic Load Balancer - External"
  vpc_id        = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name        = "${var.project_name}-SG-ELB-EXT"
  }

}

/*
# --------------------------------------------------------------------------------------
# START SECURITY GROUP FOR ELASTIC LOAD BALANCER INTERNAL FE
# - it allows the following traffic:
# - HTTP   on port 9000 from security group reverse proxy
# - HTTP   on port 9000 to   security group front end
# --------------------------------------------------------------------------------------

resource "aws_security_group" "mm_devpaas_sg_elb_int_fe" {

  name          = "${var.project_name}-SG-ELB-INT-FE-${aws_vpc.mm_devpaas_vpc.id}"
  description   = "Security Group for Elastic Load Balancer - Internal FE"
  vpc_id        = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name        = "${var.project_name}-SG-ELB-INT-FE"
  }

}

# --------------------------------------------------------------------------------------
# START SECURITY GROUP FOR ELASTIC LOAD BALANCER INTERNAL HE
# - it allows the following traffic:
# - HTTP   on port 8080 from security group reverse proxy
# - HTTP   on port 8080 from security group front end
# - HTTP   on port 8080 to   security group head end
# --------------------------------------------------------------------------------------
resource "aws_security_group" "mm_devpaas_sg_elb_int_he" {

  name          = "${var.project_name}-SG-ELB-INT-HE-${aws_vpc.mm_devpaas_vpc.id}"
  description   = "Security Group for Elastic Load Balancer - Internal HE"
  vpc_id        = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name        = "${var.project_name}-SG-ELB-INT-HE"
  }

}

# --------------------------------------------------------------------------------------
# END SECURITY GROUP FOR ELASTIC LOAD BALANCER - HE
# --------------------------------------------------------------------------------------
*/


# --------------------------------------------------------------------------------------
# START SECURITY GROUP FOR REVERSE PROXY VMs  (NGINX / APACHE)
# - it allows the following traffic:
# - ICMP   on port all from security group of the Jump Box
# - SSH    on port  22 from security group of the Jump Box
# - HTTP   on port  80 from security group of ELB
# - HTTPS  on port 443 from security group of ELB
# --------------------------------------------------------------------------------------

resource "aws_security_group" "mm_devpaas_sg_rp" {

  name          = "${var.project_name}-SG-RP-${aws_vpc.mm_devpaas_vpc.id}"
  description   = "Security Group for Reverse Proxy VMs"
  vpc_id        = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name        = "${var.project_name}-SG-RP"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# --------------------------------------------------------------------------------------
# END SECURITY GROUP FOR REVERSE PROXY VMs  (NGINX / APACHE)
# --------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------
/* START SECURITY GROUP FOR FRONT-END (WEB SERVER) VMs                    */
/* - it allows the following traffic:                                     */
/* - ICMP   on port  all from security group of the Jump Box              */
/* - SSH    on port   22 from Jump Box security group                     */
/* - HTTP   on port 9000 from Reverse Proxy security group                */
/* - HTTP   on port 8080 to   Head End security group                     */
# --------------------------------------------------------------------------------------

resource "aws_security_group" "mm_devpaas_sg_fe" {

  name        = "${var.project_name}-SG-FE-${aws_vpc.mm_devpaas_vpc.id}"
  description = "Security Group for Front-End VMs"
  vpc_id      = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name = "${var.project_name}-FE"
  }

}

# --------------------------------------------------------------------------------------
# END SECURITY GROUP FOR FRONT-END (WEB SERVER) VMs
# --------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------
/* START SECURITY GROUP FOR HEAD-END (API SERVER) VMs                     */
/* - it allows the following traffic:                                     */
/* - ICMP   on port  all from security group of the Jump Box              */
/* - SSH    on port   22 from Jump Box security group                     */
/* - HTTP   on port   80 from Reverse Proxy security group                */
/* - HTTP   on port 8080 from Reverse Proxy security group                */
/* - HTTP   on port 8081 from Reverse Proxy security group                */
/* - HTTP   on port 9000 from Reverse Proxy security group                */
/* - TCP    on port 3306 to   DB  security group                          */
# --------------------------------------------------------------------------------------

resource "aws_security_group" "mm_devpaas_sg_he" {
  name = "${var.project_name}-SG-HE-${aws_vpc.mm_devpaas_vpc.id}"
  description = "Security Group for HeadEnd VMs"
  vpc_id = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name = "${var.project_name}-SG-HE"
  }

}

# --------------------------------------------------------------------------------------
# END SECURITY GROUP FOR HEAD-END (API SERVER) VMs
# --------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------
/* START SECURITY GROUP FOR DB VMs                                        */
/* - it allows the following traffic:                                     */
/* - ICMP   on port  all from security group of the Jump Box              */
/* - SSH    on port   22 from Jump Box security group                     */
/* - TCP    on port 3306 from Head-End security group                     */
# --------------------------------------------------------------------------------------

resource "aws_security_group" "mm_devpaas_sg_db" {

  name        = "${var.project_name}-SG-DB-${aws_vpc.mm_devpaas_vpc.id}"
  description = "Security Group for DB VMs"
  vpc_id      = "${aws_vpc.mm_devpaas_vpc.id}"

  tags {
    Name = "${var.project_name}-SG-DB"
  }

}

# --------------------------------------------------------------------------------------
# END SECURITY GROUP FOR DB VMs
# --------------------------------------------------------------------------------------


#  RULES TO ADD
# - SG AS - OUTBOUND
#   - HTTP on port 8731 to IPs in 10.0.0.0/8
#   - SSH on port    22 to IPs in 10.0.0.0/8