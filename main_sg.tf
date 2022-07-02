resource "aws_security_group" "web-app-http" {
  name        = "WEB-APP-HTTP"
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

  tags = {
    Name = "WEB-APP-HTTP"
  }
}

resource "aws_security_group" "web-app-ssh" {
  name        = "WEB-APP-SSH"
  description = "This sg is created for webapp for SSH port"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.205.152.154/32"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WEB-APP-SSH"
  }
}