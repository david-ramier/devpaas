# ---------------------------------------------------------------------------------------------------------------------
# ELASTIC LOAD BALANCER TO ROUTE TRAFFIC ACROSS THE AUTO SCALING GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_elb" "mm_devpaas_elb" {

  name                = "${var.project_name}-elb"
  security_groups     = ["${aws_security_group.mm_devpaas_sg_elb.id}"]
  subnets             = ["${aws_subnet.mm_devpaas_sb_public.id}"]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:${var.revprx_server_port}/"
  }

  # This adds a listener for incoming HTTP requests.
  listener {
    lb_port             = 80
    lb_protocol         = "http"
    instance_port       = "${var.revprx_server_port}"
    instance_protocol   = "http"
  }
}