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
    zone_id                = var.bucket_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cf_record" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = var.domain_name
  type    = "AAAA"
  ttl     = "300"
  #records = [var.cf_endpoint]
}