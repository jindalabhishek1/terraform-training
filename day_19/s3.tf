resource "aws_s3_bucket" "static_web_bucket" {
  bucket        = "${var.s3_bucket_prefix}-${var.env}-website-bucket"
  force_destroy = true
  tags = {
    Environment = var.env
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.static_web_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Defining S3 bucket policy to public
resource "aws_s3_bucket_policy" "static_web_bucket_policy" {
  bucket = aws_s3_bucket.static_web_bucket.id
  policy = data.aws_iam_policy_document.public_access.json
}

# Creating bucket policy document
data "aws_iam_policy_document" "public_access" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.static_web_bucket.arn}/*"
    ]

    effect = "Allow"

  }
}

# Uploading the objects
resource "aws_s3_object" "website_objects" {

  for_each     = fileset("./web/", "**")
  bucket       = aws_s3_bucket.static_web_bucket.bucket
  key          = each.value                     # destination file name
  source       = "./web/${each.value}"          # source file path
  etag         = filemd5("./web/${each.value}") # calculating MD5 hash of the file locally and match that with etag in AWS side.
  content_type = "text/html"                    # Important to display content in browsers
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.static_web_bucket.bucket
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}