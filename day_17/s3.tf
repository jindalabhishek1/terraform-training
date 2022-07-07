resource "aws_s3_bucket" "test_bucket" {
  bucket = "${var.s3_bucket_prefix}-${var.env}-bucket"
  force_destroy = true
  tags = {
    Environment = var.env
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.test_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.test_bucket.bucket
  acl    = "private"
}

# Explicitly block all public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.test_bucket.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "test_object" {

  for_each  = fileset("./test_folder/", "**")
  bucket = aws_s3_bucket.test_bucket.bucket
  key    = "/test_folder/${each.value}" # destination file name
  source = "./test_folder/${each.value}"  # source file path
  etag   = filemd5("./test_folder/${each.value}") # calculating MD5 hash of the file locally and match that with etag in AWS side.
}