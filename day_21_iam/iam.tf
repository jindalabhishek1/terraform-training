resource "aws_iam_role" "ec2_role" {
  name               = "${var.iam_role_name}-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json

  managed_policy_arns = [data.aws_iam_policy.ec2_role_ssm_policy.arn]
#   inline_policy {
#     name = "${var.iam_role_name}-${var.env}-inline-policy"
#     policy = jsonencode(
#       {
#         Version = "2012-10-17"
#         Statement = [
#           {
#             Action = [
#               "s3:Get*",
#               "s3:List*"
#             ]
#             Effect   = "Allow"
#             Resource = "*"
#           }
#         ]
#       }
#     )
#   }
}

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "ec2_role_ssm_policy" {
  name = "AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = aws_iam_role.ec2_role.name
  role = aws_iam_role.ec2_role.name
}