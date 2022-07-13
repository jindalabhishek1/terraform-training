data "aws_vpc" "default_vpc" {
  default = true
}

# Getting amazon linux ami
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

# Creating ec2 instance
resource "aws_instance" "web_app_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_app_sg_http.id]
  user_data              = <<EOF
        #!/bin/bash
        sudo yum update -y
        sudo yum install -y httpd
        echo "Hello World! from $(hostname -f)" | tee -i /var/www/html/index.html
        sudo systemctl start httpd.service
        sudo systemctl enable httpd.service
        EOF
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  tags = {
    Name = "Web-App"
  }
}

# Creating security group
resource "aws_security_group" "web_app_sg_http" {
  name        = "${var.env}-web-app-sg-http"
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