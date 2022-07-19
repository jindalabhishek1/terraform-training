resource "aws_instance" "web-app" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  count                  = var.instance_count
  vpc_security_group_ids = [aws_security_group.web-app-http.id, aws_security_group.web-app-ssh.id]
  user_data              = <<EOF
        #!/bin/bash
        sudo yum update -y
        sudo yum install -y httpd
        # sudo echo "Hello World! from $(hostname -f)" | tee -i /var/www/html/index.html
        # cat /var/www/html/index.html
        sudo systemctl start httpd.service
        sudo systemctl enable httpd.service
        EOF
  iam_instance_profile   = "SSMRoleForEc2"
  tags = {
    Name = "Web-App"
  }
}

data "aws_instance" "my-web-app" {
  instance_id = aws_instance.web-app[0].id
}