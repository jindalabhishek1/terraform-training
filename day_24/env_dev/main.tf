module "web_app" {
  source                = "../modules/asg"
  user_data_file        = "./user-data.sh"
  instance_type         = "t3.micro"
  env                   = var.env
  alb_security_group_id = module.web_app_lb.lb_sg_id
}

module "web_app_lb" {
  source   = "../modules/alb"
  asg_name = module.web_app.aws_autoscaling_group_name
  env      = var.env
}

output "lb_endpoint" {
  value = module.web_app_lb.lb_endpoint
}