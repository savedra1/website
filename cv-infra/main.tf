

# Backend setup
terraform {
  backend "s3" {
    bucket = var.CV_STATE_BUCKET
    key    = "dev/terraform.tfstate"
    region = "eu-west-1"
  }
}

# Provider with default region
provider "aws" {
  region = var.AWS_REGION 
}

# Create S3 bucket for hosting the pdf file
resource "aws_s3_bucket" "cv_bucket" {
  bucket = var.CV_BUCKET 
}

# Publically available
resource "aws_s3_bucket_public_access_block" "cv_bucket_public_access_block" {
  bucket = aws_s3_bucket.cv_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.cv_bucket.id

  index_document {
    suffix = "cv.pdf"
  }
}

data "aws_iam_policy_document" "allow_public_read" {
  statement {
    sid       = "PublicReadGetObject"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = [
      aws_s3_bucket.cv_bucket.arn,  
      "${aws_s3_bucket.cv_bucket.arn}/*"
    ]

    principals {
      identifiers = [aws_s3_bucket.cv_bucket.id]
      type        = "*"
    }
  }
}

resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = aws_s3_bucket.cv_bucket.id
  policy = data.aws_iam_policy_document.allow_public_read.json
}