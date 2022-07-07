output "lb_endpoint" {
  value = "http://${aws_lb.web_app_lb.dns_name}"
}

output "application_endpoint" {
  value = "http://${aws_lb.web_app_lb.dns_name}/index.php"
}

output "asg_name" {
  value = aws_autoscaling_group.web_app_asg.name
}
