resource "aws_iam_user" "test_users" {
  for_each = toset(var.iam_users)
  name     = each.value
}