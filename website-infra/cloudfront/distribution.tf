
resource "aws_cloudfront_distribution" "cf_distribution" {
  origin {
    domain_name = "${var.domain_name}.s3-website-${var.region}.amazinaws.com" 
    origin_id   = "Custom-origin"
  }

  enabled             = true
  default_root_object = "index.html"

  aliases = [
    var.domain_name
  ]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "Custom-origin"

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
      locations        = ["US", "CA", "EU"]
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.cert_id
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  http_version               = "http2"
  is_ipv6_enabled = true
}