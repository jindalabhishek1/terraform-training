variable "aws_region" {
  type        = string
  description = "The default AWS region in which you want to work."
  default     = "eu-central-1"
}

variable "instance_ami" {
  type        = string
  description = "A valid AMI id for the region you are working."
  default     = "ami-0a1ee2fb28fe05df3"
}

variable "instance_count" {
  type        = number
  description = "Number of instances you want to deploy."
  default     = 1
}

variable "instance_type" {
  type        = string
  description = "The instance type you want to use for your instance."
  default     = "t2.micro"
}