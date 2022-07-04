data "aws_vpc" "vpc" {
    filter {
        name = "tag:Environment"
        values = ["prod"]
    }
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