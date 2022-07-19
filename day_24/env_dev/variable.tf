variable "env" {
  type        = string
  description = "The environment you are working"
}

variable "aws_region" {
  type        = string
  description = "The default AWS region in which you want to work."
  default     = "eu-central-1"
}
