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