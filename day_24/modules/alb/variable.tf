variable "env" {
  type        = string
  description = "The environment you are working"
}

variable "asg_name" {
  type        = string
  description = "The name of autoscalling group which need to attached to load balancer."
}