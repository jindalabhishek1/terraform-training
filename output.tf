output "web-app-ip" {
  value = aws_instance.web-app.*.public_ip
}

output "ec2-ami" {
  value = data.aws_instance.my-web-app.ami
}