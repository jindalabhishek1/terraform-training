output "aws_s3_bucket_arn" {
  value = aws_s3_bucket.state_bucket.arn
}

output "aws_dynamodb_table_arn" {
  value = aws_dynamodb_table.terraform_locks.arn
}