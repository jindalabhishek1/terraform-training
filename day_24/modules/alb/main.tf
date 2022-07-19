data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "default_public_sub" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
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
  autoscaling_group_name = var.asg_name
  lb_target_group_arn    = aws_lb_target_group.lb_tg.arn
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

output "lb_sg_id" {
  value = aws_security_group.lb_sg_http.id
}

output "lb_endpoint" {
  value = "http://${aws_lb.web_app_lb.dns_name}"
}

output "application_endpoint" {
  value = "http://${aws_lb.web_app_lb.dns_name}/index.php"
}