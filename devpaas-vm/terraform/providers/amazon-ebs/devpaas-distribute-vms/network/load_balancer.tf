/* This file describe the Elastic Load Balancer ELB */

/*
resource "aws_elb" "mm_devpaas_elb" {

  name                  = "MM-DEVPAAS-ELB"
  instances             = ["${aws_instance.mm_devpaas_dv_reverse_proxy.id}"]
  availability_zones    = ["${var.aws_deployment_region}a"]
  security_groups       = ["${aws_security_group.mm_devpaas_sg_elb.id}"]

  listener {

    lb_port             = 80
    lb_protocol         = "http"

    instance_port       = 80
    instance_protocol   = "http"

  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2

    timeout             = 3

    interval            = 30
    target              = "TCP:80"
  }

}
*/