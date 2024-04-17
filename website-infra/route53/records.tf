/* 
    The route53 record used for rerouting the s3 bucket's
    endpoint 
*/

# For HTTPS from cloudfront endpoint
resource "aws_route53_record" "cloudfront_record" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = var.domain_name
  type    = "AAAA"

  alias {
    name = var.cloudfront_endpoint
    zone_id = var.cloudfront_zone_id
    evaluate_target_health = false
  }
}

# Cert validation record
resource "aws_route53_record" "cert_record" {
  for_each = {
    for dvo in var.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.hosted_zone.zone_id
}

resource "aws_route53_record" "website_record" { 
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = var.domain_name 
  type    = "A"

  alias {
    name                   = var.cloudfront_endpoint 
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = false
  }
}
