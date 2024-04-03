
resource "aws_cloudfront_distribution" "cf_distribution" {
  enabled             = true
  default_root_object = "cv.pdf"

  origin {
    domain_name = var.regional_domain # the public endpoint for the cv bucket
    origin_id   = var.origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cv_site.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = var.origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  http_version               = "http2"
  is_ipv6_enabled = true
}
