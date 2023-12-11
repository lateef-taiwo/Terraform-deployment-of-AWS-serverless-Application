# Create Bucket
resource "aws_s3_bucket" "s3-bucket" {
  bucket = "wild-rides-bucket-5190"
}

# Block Public Access
resource "aws_s3_bucket_public_access_block" "s3-bucket-block" {
  bucket                  = aws_s3_bucket.s3-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create Bucket ACL
# resource "aws_s3_bucket_acl" "s3-bucket-acl" {
#   bucket = aws_s3_bucket.s3-bucket.id
#   acl    = "private"
# }

# Zip the Lambda function on the fly
data "archive_file" "source" {
  type        = "zip"
  source_dir  = "../Wild-Rydes/"
  output_path = "../Wild-Rydes/index.zip"
}

# Upload the zip file to S3 bucket
resource "aws_s3_object" "lambda-function-code" {
  bucket = aws_s3_bucket.s3-bucket.bucket
  source = data.archive_file.source.output_path
  key    = "index.zip"
  acl    = "private"
  depends_on = [aws_s3_bucket.s3-bucket]
}

