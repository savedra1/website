terraform {
  backend "s3" {
    bucket = var.STATE_BUCKET
    key    = var.STATE_FILE
    region = var.AWS_REGION
  }
}

provider "aws" {
  region = var.AWS_REGION  # Replace with your desired AWS region
}


# Create S3 bucket for hosting the static website
resource "aws_s3_bucket" "static_website" {
  bucket = var.SITE_BUCKET  # Replace with your desired bucket name
}


resource "aws_s3_bucket_public_access_block" "static_website_public_access_block" {
  bucket = aws_s3_bucket.static_website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

data "aws_iam_policy_document" "allow_public_read" {
  statement {
    sid       = "PublicReadGetObject"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = [
      aws_s3_bucket.static_website.arn,  
      "${aws_s3_bucket.static_website.arn}/*"
    ]

    principals {
      identifiers = [aws_s3_bucket.static_website.id]
      type        = "*"
    }
  }
}

resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = aws_s3_bucket.static_website.id
  policy = data.aws_iam_policy_document.allow_public_read.json
}



# ===== FILES

resource "aws_s3_object" "index_page" {
  bucket = aws_s3_bucket.static_website.id
  key    = "index.html"
  source = "../website/index.html"

}

resource "aws_s3_object" "error_page" {
  bucket = aws_s3_bucket.static_website.id
  key    = "error.html"
  source = "../website/error.html"

}

resource "aws_s3_object" "css" {
  bucket = aws_s3_bucket.static_website.id
  key    = "styles.css"
  source = "../website/styles.css"
}

resource "aws_s3_object" "terminal" {
  bucket = aws_s3_bucket.static_website.id
  key    = "terminal.js"
  source = "../website/terminal.js"

}

resource "aws_s3_object" "backgroung" {
  bucket = aws_s3_bucket.static_website.id
  key    = "ZE9ZvL4.png"
  source = "../website/ZE9ZvL4.png"

}

