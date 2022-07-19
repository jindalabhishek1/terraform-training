variable "instance_type" {
  type        = string
  description = "The instance type you want to use for your instance."
  default     = "t2.micro"
}

variable "env" {
  type        = string
  description = "The environment you are working"
}

variable "alb_security_group_id" {
  type        = string
  description = "The arn of the load balancer security group."
}

variable "user_data_file" {
  type        = string
  description = "The file path for user data script which you want to run on instances."
}