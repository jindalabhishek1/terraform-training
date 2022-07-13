output "iam_user_arn" {
  value = aws_iam_user.test_users[each.key].arn
}