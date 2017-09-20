
# --------------------------------------------------------------------------------------
#   LAUNCH CONFIGURATION FOR REVERSE PROXY
# --------------------------------------------------------------------------------------


data "template_file" "mm_devpaas_dv_tf_user_data_rp" {
  template = "${file("change_hostname.sh.tpl")}"

  vars {
    domain_name = "${var.primary_zone_domain_name}"
    vm_name     = "${var.revprx_instance_name}"
  }

}


resource "aws_launch_configuration" "mm_devpaas_lc_rp" {
  name_prefix     = "${var.revprx_instance_name}"
  image_id        = "${var.revprx_image_id}"
  instance_type   = "${var.revprx_flavor_name}"
  security_groups = ["${aws_security_group.mm_devpaas_sg_rp.id}"]

  key_name        = "${var.aws_ssh_key_name}"

  /*
  user_data = <<-EOF
              #!/bin/bash -v
              apt-get update -y
              apt-get install -y nginx > /tmp/nginx.log
              EOF
  */
  user_data = "${data.template_file.mm_devpaas_dv_tf_user_data_rp.rendered}"

  connection {
    type                = "ssh"
    bastion_host        = "${aws_eip.mm_devpaas_admin_eip.public_ip}"
    bastion_private_key = "${file("marmac_marcomaccio_rsa.pem")}"
    bastion_user        = "ubuntu"
    user                = "ubuntu"
    private_key         = "${file("marmac_marcomaccio_rsa.pem")}"
    timeout             = "10m"

  }

  provisioner "file" {
    source      = "../../../../resources/nginx/default.conf"
    destination = "/tmp/"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Change NGINX Configuration'",
      "sudo cp /tmp/default.conf /etc/nginx/sites-available/default"
    ]
  }

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
  desired_capacity          = 3

  load_balancers            = ["${aws_elb.mm_devpaas_elb_external.name}"]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${var.project_name}-ASG"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "mm_devpaas_asg_pol_scale_up" {
  name                    = "revproxy-scale-down"
  adjustment_type         = "ChangeInCapacity"
  scaling_adjustment      = "-1"
  cooldown                = "300"
  autoscaling_group_name  = "${aws_autoscaling_group.mm_devpaas_asg_rp.name}"
}

resource "aws_autoscaling_policy" "mm_devpaas_asg_pol_scale_down" {
  name                    = "revproxy-scale-up"
  adjustment_type         = "ChangeInCapacity"
  scaling_adjustment      = "1"
  cooldown                = "300"
  autoscaling_group_name  = "${aws_autoscaling_group.mm_devpaas_asg_rp.name}"
}

resource "aws_autoscaling_notification" "mm_devpaas_asg_notif" {

  group_names   = ["${aws_autoscaling_group.mm_devpaas_asg_rp.name}"]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
  ]

  topic_arn     = "${aws_sns_topic.mm_devpaas_sns_topic_main.arn}"
}

resource "aws_sns_topic" "mm_devpaas_sns_topic_main" {
  name = "${var.project_name}-sns-topic"

  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.sns_email}"
  }
}

resource "aws_cloudwatch_metric_alarm" "mm_devpaas_cma_memory_high" {
  alarm_name          = "mem-util-high-agents"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 memory for high utilization on agent hosts"

  alarm_actions       = ["${aws_autoscaling_policy.mm_devpaas_asg_pol_scale_up.arn}"]

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.mm_devpaas_asg_rp.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "mm_devpaas_cma_memory_low" {
  alarm_name = "mem-util-low-agents"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "MemoryUtilization"
  namespace = "System/Linux"
  period = "300"
  statistic = "Average"
  threshold = "40"
  alarm_description = "This metric monitors ec2 memory for low utilization on agent hosts"

  alarm_actions = ["${aws_autoscaling_policy.mm_devpaas_asg_pol_scale_down.arn}"]

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.mm_devpaas_asg_rp.name}"
  }
}