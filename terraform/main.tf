terraform {
  backend "s3" {
    bucket = "msavedra-state"  #var.STATE_BUCKET
    key    = "dev/tfstate" #var.STATE_FILE
    region = "eu-west-1"  #var.AWS_REGION
  }
}

provider "aws" {
  region = "eu-west-1" #var.AWS_REGION 
}


# Create S3 bucket for hosting the static website
resource "aws_s3_bucket" "static_website" {
  bucket = "msavedra.com" #var.SITE_BUCKET  # Replace with your desired bucket name
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

######## ROUTE 53

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
    name                   = "s3-website-eu-west-1.amazonaws.com" #"s3-website-${var.AWS_REGION}.amazonaws.com" #aws_s3_bucket_website_configuration.website_config.
    zone_id                = aws_s3_bucket.static_website.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53domains_registered_domain" "my_domain" {
  domain_name = "msavedra.com"

  name_server {
    name = aws_route53_zone.name_servers[0]
  }

  name_server {
    name = aws_route53_zone.name_servers[1]
  }

  name_server {
    name = aws_route53_zone.name_servers[2]
  }

  name_server {
    name = aws_route53_zone.name_servers[3]
  }

}
