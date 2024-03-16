terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "msavedra-website"
  acl    = "public-read"
  website { # depricated
    index_document = "index.html"
    error_document = "error.html"
  }
}

# Configure Bucket Policy for Public Read Access
resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          "${aws_s3_bucket.website_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Create a Hosted Zone in Route 53
resource "aws_route53_zone" "hosted_zone" {
  name = "msavedra.com" 
}

# Create an A Record and Alias to the S3 Website Endpoint
resource "aws_route53_record" "website_record" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = "msavedra.com" 
  type    = "A"

  alias {
    name                   = aws_s3_bucket.website_bucket.website_endpoint
    zone_id                = aws_s3_bucket.website_bucket.hosted_zone_id
    evaluate_target_health = true
  }
}