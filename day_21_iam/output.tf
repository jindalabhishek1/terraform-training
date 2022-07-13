output "web_server_link" {
  value = "http://${aws_instance.web_app_instance.public_dns}"
}