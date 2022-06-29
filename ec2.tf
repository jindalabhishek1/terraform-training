provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "ec2-web" {
  ami           = "ami-0a1ee2fb28fe05df3"
  instance_type = "t2.micro"
  count         = "1"

  tags = {
    Name = "tf-server"
  }

  user_data = <<EOF
    #!/bin/bash
    echo "Installing httpd"
    sudo yum install -y httpd
    sudo systemctl start httpd.service
    sudo systemctl enable httpd.service
    EOF

  vpc_security_group_ids = [aws_security_group.web_app.id]
  iam_instance_profile   = "SSMRoleForEc2"
}

resource "aws_security_group" "web_app" {
  name        = "web_app"
  description = "Allow HTTP inbound traffic"

  ingress {
    description = "HTTP from Web"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "web_app"
  }
}

resource "aws_security_group" "web_app_sg" {
  name        = "web_app_sg"
  description = "Allow HTTP inbound traffic"

  ingress {
    description = "HTTP from Web"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "web_app_sg"
  }
}

output "instance-ip" {
  value       = aws_instance.ec2-web.*.public_ip
  description = "Public ip address of the server."
}