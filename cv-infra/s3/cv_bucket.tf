# Create S3 bucket for hosting the pdf file
resource "aws_s3_bucket" "cv_bucket" {
  bucket = var.cv_bucket 
}

# Publically available
resource "aws_s3_bucket_public_access_block" "cv_bucket_public_access_block" {
  bucket = aws_s3_bucket.cv_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Index doc for site config
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.cv_bucket.id

  index_document {
    suffix = "cv.pdf"
  }
}
