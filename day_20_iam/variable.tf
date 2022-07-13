variable "aws_region" {
  type        = string
  description = "The default AWS region in which you want to work."
  default     = "eu-central-1"
}

variable "env" {
  type        = string
  description = "The environment in which you are working."
  default     = "test"
}

variable "iam_users" {
  type        = list(string)
  description = "The list of IAM users you want to create. Usage: [\"user1\", \"user2\"]."
}