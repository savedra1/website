/* 
    The route53 record used for rerouting the s3 bucket's
    endpoint 
*/
resource "aws_route53_record" "website_record" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = var.domain_name 
  type    = "A"

  alias {
    name                   = "s3-website-${var.region}.amazonaws.com" 
    zone_id                = aws_s3_bucket.static_website.hosted_zone_id
    evaluate_target_health = true
  }
}