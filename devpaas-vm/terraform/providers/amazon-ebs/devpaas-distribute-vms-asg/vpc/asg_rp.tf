
# --------------------------------------------------------------------------------------
#   LAUNCH CONFIGURATION FOR REVERSE PROXY
# --------------------------------------------------------------------------------------

resource "aws_launch_configuration" "mm_devpaas_lc_rp" {
  name            = "mm-devpaas-rp"
  image_id        = "${var.revprx_image_id}"
  instance_type   = "${var.revprx_flavor_name}"
  security_groups = ["${aws_security_group.mm_devpaas_sg_rp.id}"]

  user_data = <<-EOF
              #!/bin/bash -v
              apt-get update -y
              apt-get install -y nginx > /tmp/nginx.log
              EOF


  lifecycle {
    create_before_destroy = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
#    AUTO SCALING GROUP FOR REVERSE PROXY VMs
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_autoscaling_group" "mm_devpaas_asg_rp" {

  launch_configuration      = "${aws_launch_configuration.mm_devpaas_lc_rp.id}"
  availability_zones        = ["${var.aws_deployment_region}a"]
  vpc_zone_identifier       = ["${aws_subnet.mm_devpaas_sb_public.id}"]

  min_size                  = 2
  max_size                  = 10

  load_balancers            = ["${aws_elb.mm_devpaas_elb_external.name}"]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${var.project_name}-ASG"
    propagate_at_launch = true
  }
}