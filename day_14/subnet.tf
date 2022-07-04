variable "vpc_id" {
    type = string
    description = "The id of the VPC you want to refer in the data block."
    # default = "vpc-0711c86d"
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

output "subnet-ids" {
  value = data.aws_subnets.subnets.ids
}

output "vpc_arn" {
    value = data.aws_vpc.vpc.arn
}