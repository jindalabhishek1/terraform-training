variable "aws_region" {
  type        = string
  description = "The default AWS region in which you want to work."
  default     = "eu-central-1"
}

variable "s3_bucket_prefix" {
  type        = string
  description = "The prefix of the s3 bucket name."
  default     = "rb-bsh-dps-xaas-alice"
}

variable "env" {
  type        = string
  description = "The environment in which you are working."
}