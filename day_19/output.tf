output "website_endpoint" {
  value = "http://${aws_s3_bucket_website_configuration.static_website.website_endpoint}"
}