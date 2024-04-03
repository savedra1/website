
resource "aws_cloudfront_origin_access_identity" "cv_site" {
  comment = "my public cv - managed by terraform"
}