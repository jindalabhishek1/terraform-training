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
  user_data            = file("user-data.sh")

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
  start_time             = "2022-07-08T16:16:46Z"
  end_time               = "2022-07-08T17:16:46Z"
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name
}

resource "aws_lb" "web_app_lb" {
  name               = "${var.env}-web-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg_http.id]
  subnets            = data.aws_subnets.default_public_sub.ids
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.web_app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }
}

resource "aws_lb_target_group" "lb_tg" {
  name     = "${var.env}-asg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default_vpc.id

  health_check {
    enabled           = true
    healthy_threshold = 2
    matcher           = "200,202"
    path              = "/"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name
  lb_target_group_arn    = aws_lb_target_group.lb_tg.arn
}

resource "aws_security_group" "web_app_sg_http" {
  name        = "${var.env}-web-app-sg-http"
  description = "This sg is created for webapp for HTTP port"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg_http.id]

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

resource "aws_security_group" "lb_sg_http" {
  name        = "${var.env}-al-sg-http"
  description = "This sg is created for webapp for HTTP port"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

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