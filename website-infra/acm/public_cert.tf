
resource "aws_acm_certificate" "domain_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

#import {
#  to = aws_acm_certificate.cert
#  id = var.cert_arn
#}