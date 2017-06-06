/*
 *  Security Group definition
 */

/* ********************************************************************** */
/* START SECURITY GROUP FOR ELASTIC LOAD BALANCER ELB                     */
/* - it allows the following traffic:                                     */
/* - HTTP   on port  80 from all Internet IPs                             */
/* - HTTPS  on port 443 from all Internet IPs - NOT YET ENABLED           */
/* ********************************************************************** */

/*
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
  */

  /* TODO: TO BE ENABLED WITH A REALCASE
  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  */

  /*
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

*/

/* ********************************************************************** */
/* END SECURITY GROUP FOR ELASTIC LOAD BALANCER ELB                     */
/* ********************************************************************** */