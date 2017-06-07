
# --------------------------------------------------------------------------------------
#   LAUNCH CONFIGURATION FOR REVERSE PROXY
# --------------------------------------------------------------------------------------

resource "aws_launch_configuration" "mm_devpaas_lc_rp" {

  image_id        = "${var.revprx_image_id}"
  instance_type   = "${var.revprx_flavor_name}"
  security_groups = ["${aws_security_group.mm_devpaas_sg_rp.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.revprx_server_port}" &
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
#    AUTO SCALING GROUP FOR REVERSE PROXY VMs
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_autoscaling_group" "mm_devpaas_asg_rp" {

  launch_configuration  = "${aws_launch_configuration.mm_devpaas_lc_rp.id}"
  availability_zones    = ["${var.aws_deployment_region}a"]

  min_size          = 2
  max_size          = 10

  load_balancers    = ["${aws_elb.mm_devpaas_elb.name}"]
  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "${var.project_name}-ASG"
    propagate_at_launch = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ELASTIC LOAD BALANCER TO ROUTE TRAFFIC ACROSS THE AUTO SCALING GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_elb" "mm_devpaas_elb" {

  name                = "${var.project_name}-elb"
  security_groups     = ["${aws_security_group.mm_devpaas_sg_elb.id}"]
  availability_zones  = ["${var.aws_deployment_region}a"]

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