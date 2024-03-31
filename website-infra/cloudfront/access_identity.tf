resource "aws_cloudfront_origin_access_identity" "static_site" {
  comment = "my static site"
}