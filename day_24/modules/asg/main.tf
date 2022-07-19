data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "default_public_sub" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_launch_configuration" "as_config" {
  name_prefix          = var.env
  image_id             = data.aws_ami.amazon-linux.id
  instance_type        = var.instance_type
  iam_instance_profile = "SSMRoleForEc2"
  security_groups      = [aws_security_group.web_app_sg_http.id]
  user_data            = var.user_data_file

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_app_asg" {
  name                 = "${var.env}_web_app_asg"
  max_size             = 5
  min_size             = 2
  desired_capacity     = 3
  launch_configuration = aws_launch_configuration.as_config.name
  vpc_zone_identifier  = data.aws_subnets.default_public_sub.ids
  tag {
    key                 = "Name"
    value               = "${var.env} - Web app"
    propagate_at_launch = true
  }
  health_check_type     = "ELB"
}

# Autoscaling policy
resource "aws_autoscaling_policy" "asg_policy" {
  name                   = "${var.env}-asg-policy"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name
}

# Autoscaling schedule
resource "aws_autoscaling_schedule" "asg_schedule" {
  scheduled_action_name  = "${var.env}-asg-schedule-action"
  min_size               = 1
  max_size               = 3
  desired_capacity       = 2
  start_time             = "2022-08-08T16:16:46Z"
  end_time               = "2022-08-08T17:16:46Z"
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name
}

resource "aws_security_group" "web_app_sg_http" {
  name        = "${var.env}-web-app-sg-http"
  description = "This sg is created for webapp for HTTP port"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = data.aws_vpc.default_vpc.id
  tags = {
    Name = "${var.env}_wep_app_http_sg"
  }
}

output "aws_autoscaling_group_name" {
  value = aws_autoscaling_group.web_app_asg.name
}
