variable "aws_region" {
  type        = string
  description = "The default AWS region in which you want to work."
  default     = "eu-central-1"
}

variable "aws_s3_bucket_name" {
  type        = string
  description = "The name of s3 bucket to be created."
}