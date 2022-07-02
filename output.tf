output "web-app-ip" {
    value = aws_instance.web-app.*.public_ip
}