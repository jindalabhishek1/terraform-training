terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "jindal-tf-state-bucket"
    key    = "backend/day_19/terraform.tfstate"
    region = "eu-central-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "jindal-tf-lock"
    encrypt        = true
  }
}